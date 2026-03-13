#!/bin/bash
# Don't use set -e here since we're running background processes
# We want the script to continue even if one process has issues starting

# Colors for output
GREEN='\x1b[0;32m'
BLUE='\x1b[0;34m'
YELLOW='\x1b[1;33m'
NC='\x1b[0m' # No Color

echo -e "$GREENStarting tutorial environment...$NC"
echo ""

# Function to handle cleanup on exit
cleanup() {
  echo ""
  echo -e "$YELLOWShutting down servers...$NC"
  # Kill all background processes in this process group
  kill 0 2>/dev/null || true
  exit 0
}

trap cleanup SIGINT SIGTERM EXIT

# Start Astro tutorial server in background
echo -e "$BLUE[Tutorial]$NC Starting Astro server on port 1234..."
(npm run dev -- --host 0.0.0.0 --port 1234 2>&1 | sed "s/^/[Tutorial] /") &
ASTRO_PID=$!

# Wait a moment for Astro to start
sleep 2

# Start learner application server in background
echo -e "$BLUE[Learner]$NC Starting node server in learner-project..."
(cd learner-project && npm run dev 2>&1 | sed "s/^/[Learner] /") &
LEARNER_PID=$!

# Give the learner app a moment to bind to port 3000
sleep 3

# Try to make port 3000 public in Codespaces
if command -v gh >/dev/null 2>&1 && [ -n "${CODESPACE_NAME:-}" ]; then
  echo -e "${BLUE}[Codespaces]${NC} Making learner app port 3000 public..."
  gh codespace ports visibility 3000:public -c "$CODESPACE_NAME" >/dev/null 2>&1 || \
    echo -e "${YELLOW}[Codespaces]${NC} Could not set port 3000 to public automatically."
else
  echo -e "${YELLOW}[Codespaces]${NC} gh CLI or CODESPACE_NAME not available; skipping automatic port visibility."
fi

echo ""
echo -e "$GREEN✓ Both servers are running$NC"
echo -e "$GREEN✓ Tutorial available at http://localhost:1234$NC"
echo -e "$GREEN✓ Learner app available at http://localhost:3000$NC"
echo ""
echo "Press Ctrl+C to stop both servers"
echo ""

# Wait for both processes
wait
