import React from 'react';
import ReactDOM from 'react-dom/client';
import { QueryClientProvider } from '@tanstack/react-query';
import { RouterProvider } from '@tanstack/react-router';
import { loadRuntimeConfig } from './env';
import { queryClient } from './lib/query';
import { router } from './routes/router';
import './lib/i18n';
import './styles/globals.css';

/**
 * Bootstrap-first, as in the ABP Modern template: runtime config resolves
 * before the first render. `initUserManager()` belongs here too once OIDC
 * is wired — the app should never render in an unknown auth state.
 */
async function bootstrap() {
  await loadRuntimeConfig();

  ReactDOM.createRoot(document.getElementById('root')!).render(
    <React.StrictMode>
      <QueryClientProvider client={queryClient}>
        <RouterProvider router={router} />
      </QueryClientProvider>
    </React.StrictMode>,
  );
}

void bootstrap();
