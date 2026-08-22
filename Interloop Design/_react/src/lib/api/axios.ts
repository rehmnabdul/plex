import axios from 'axios';
import { getEnv } from '@/env';

/**
 * Shared axios instance. Endpoints are written WITHOUT the `/api` prefix
 * (`/app/order`, not `/api/app/order`) — the base URL supplies it.
 *
 * AUTH SEAM: the ABP template attaches the OIDC access token here. Drop the
 * token getter in when `@volo/abp-react-oidc-auth` is wired up.
 */
export const api = axios.create({
  baseURL: '/api',
  headers: { 'Content-Type': 'application/json' },
});

api.interceptors.request.use((config) => {
  const env = getEnv();
  if (env.apiUrl && env.apiUrl !== '/api') config.baseURL = `${env.apiUrl.replace(/\/$/, '')}/api`;

  // const token = getAccessToken();
  // if (token) config.headers.Authorization = `Bearer ${token}`;

  const tenant = localStorage.getItem('__tenant');
  if (tenant) config.headers.__tenant = tenant;
  config.headers['Accept-Language'] = localStorage.getItem('lang') ?? 'en';
  return config;
});

export interface RequestFlags {
  skipAuthRedirect?: boolean;
  skip403Redirect?: boolean;
}

api.interceptors.response.use(
  (r) => r,
  (error) => {
    const cfg = (error.config ?? {}) as RequestFlags;
    const status = error.response?.status;
    if (status === 401 && !cfg.skipAuthRedirect) window.dispatchEvent(new CustomEvent('auth:unauthenticated'));
    if (status === 403 && !cfg.skip403Redirect) window.location.assign('/403');
    return Promise.reject(error);
  },
);

/** ABP's standard paged envelope. */
export interface PagedResult<T> {
  items: T[];
  totalCount: number;
}

/** ABP's standard paged/sorted request. */
export interface PagedRequest {
  skipCount?: number;
  maxResultCount?: number;
  sorting?: string;
  filter?: string;
}
