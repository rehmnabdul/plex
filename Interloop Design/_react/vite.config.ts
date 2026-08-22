import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';
import path from 'node:path';

// Dev proxy mirrors the ABP Modern template: the SPA always talks to same-origin
// paths and Vite forwards them to the API host / auth server.
const API = process.env.VITE_API_URL || 'https://localhost:44305';
const AUTH = process.env.VITE_AUTH_URL || 'https://localhost:44305';

export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: { alias: { '@': path.resolve(__dirname, './src') } },
  server: {
    port: 5173,
    proxy: {
      '/api': { target: API, changeOrigin: true, secure: false },
      '/connect': { target: AUTH, changeOrigin: true, secure: false },
      '/getEnvConfig': { target: API, changeOrigin: true, secure: false },
    },
  },
});
