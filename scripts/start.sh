#!/bin/bash
set -e

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
  kill 0
  exit 0
}

trap cleanup SIGINT SIGTERM

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

echo ""
echo -e "$GREEN✓ Both servers are running$NC"
echo -e "$GREEN✓ Tutorial available at http://localhost:1234$NC"
echo -e "$GREEN✓ Learner app available at http://localhost:3000$NC"
echo ""
echo "Press Ctrl+C to stop both servers"
echo ""

# Wait for both processes
wait
