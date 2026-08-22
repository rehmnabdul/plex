/**
 * Runtime environment. The ABP Modern template resolves these from
 * `dynamic-env.json` at boot so one build can be promoted across environments;
 * until that endpoint is wired here, Vite's build-time vars are the fallback.
 */
export interface AppEnv {
  apiUrl: string;
  authUrl: string;
  clientId: string;
  /** Serve the mock dataset instead of calling the API. */
  useMocks: boolean;
}

let env: AppEnv = {
  apiUrl: import.meta.env.VITE_API_URL ?? '/api',
  authUrl: import.meta.env.VITE_AUTH_URL ?? '',
  clientId: import.meta.env.VITE_CLIENT_ID ?? 'LoopConsole_App',
  useMocks: (import.meta.env.VITE_USE_MOCKS ?? 'true') !== 'false',
};

export const getEnv = () => env;

/** Call before rendering once `/getEnvConfig` is available. */
export async function loadRuntimeConfig(): Promise<AppEnv> {
  try {
    const res = await fetch('/getEnvConfig');
    if (!res.ok) return env;
    const cfg = await res.json();
    env = {
      ...env,
      apiUrl: cfg?.remoteEnv?.apis?.default?.url ?? env.apiUrl,
      authUrl: cfg?.remoteEnv?.oAuthConfig?.issuer ?? env.authUrl,
      clientId: cfg?.remoteEnv?.oAuthConfig?.clientId ?? env.clientId,
      useMocks: false,
    };
  } catch {
    /* offline / mock mode — keep defaults */
  }
  return env;
}
