import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  integrations: [
    starlight({
      title: 'Build a Webhook Listener',
      social: {
        github: 'https://github.com',
      },
      // Auto-generate sidebar from content files
      sidebar: [
        {
          label: 'Tutorial',
          autogenerate: { directory: 'docs' }
        }
      ],
      // Override Footer to add step navigation
      components: {
        Footer: './src/components/Footer.astro',
      },
    }),
  ],
  server: {
    port: 4321,
  },
});
