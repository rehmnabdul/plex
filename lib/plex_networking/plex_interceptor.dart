import 'package:plex/plex_networking/plex_networking.dart';

/// Interceptor for HTTP requests and responses.
///
/// Add via [PlexNetworking.addInterceptor]. Interceptors run in order:
/// - [onRequest] before each request (can modify headers)
/// - [onResponse] after each response (can modify or replace response)
/// - [onError] when an exception occurs (can return a custom error response)
abstract class PlexInterceptor {
  /// Called before the request is sent. Return modified headers.
  Future<Map<String, String>> onRequest(String url, Map<String, String> headers) async => headers;

  /// Called after the response is received. Return the (possibly modified) response.
  Future<PlexApiResponse> onResponse(PlexApiResponse response) async => response;

  /// Called when an exception occurs. Return a [PlexApiResponse] (typically [PlexError]).
  Future<PlexApiResponse> onError(Object error, StackTrace stack) async =>
      PlexError(400, error.toString());
}

/// Interceptor that adds an `Authorization: Bearer <token>` header from a token provider.
class PlexAuthInterceptor extends PlexInterceptor {
  final Future<String> Function() tokenProvider;

  PlexAuthInterceptor(this.tokenProvider);

  @override
  Future<Map<String, String>> onRequest(String url, Map<String, String> headers) async {
    final token = await tokenProvider();
    if (token.isNotEmpty) {
      headers = Map<String, String>.from(headers);
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}

/// Configuration for retry behavior. Used by the networking pipeline when this interceptor
/// is in the chain.
class PlexRetryInterceptor extends PlexInterceptor {
  final int maxAttempts;
  final List<int> retryOnStatusCodes;

  PlexRetryInterceptor({
    this.maxAttempts = 3,
    this.retryOnStatusCodes = const [500, 502, 503],
  });
}
