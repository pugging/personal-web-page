import { defineConfig } from 'vite';
import basicSsl from '@vitejs/plugin-basic-ssl';

export default defineConfig({
  root: 'ceilor',
  plugins: [
    process.env.VITE_HTTPS === 'true' ? basicSsl() : null
  ].filter(Boolean),
  server: {
    port: 3000,
    https: process.env.VITE_HTTPS === 'true',
    host: true,
    open: true
  },
  build: {
    outDir: '../dist',
    emptyOutDir: true,
  }
});
