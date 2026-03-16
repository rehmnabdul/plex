import 'dart:io';

import 'package:plex/plex_networking/plex_networking.dart';

/// Application-level API client. Provides simplified methods for making API calls
/// using the underlying [PlexNetworking] functionality, returning flat [PlexApiResult].
class PlexApi {
  /// Singleton instance of PlexApi
  static final PlexApi instance = PlexApi._();

  PlexApi._();

  /// Sets the base URL for all API calls
  ///
  /// [baseUrl] - The base URL for the API (e.g., 'https://api.example.com')
  void setBaseUrl(String baseUrl) {
    PlexNetworking.instance.setBasePath(baseUrl);
  }

  /// Sets a callback that will be called before each request to add headers
  ///
  /// [headersCallback] - A function that returns a map of headers to add to each request
  void setHeadersCallback(Future<Map<String, String>> Function() headersCallback) {
    PlexNetworking.instance.addHeaders = headersCallback;
  }

  /// Allows bad HTTPS certificates for development purposes
  ///
  /// Warning: This should only be used in development environments
  void allowBadHttpsCertificates() {
    PlexNetworking.instance.allowBadCertificateForHTTPS();
  }

  /// Makes a GET request to the specified endpoint
  Future<PlexApiResult> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    bool useFullUrl = false,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    final url = useFullUrl ? endpoint : endpoint;
    final response = await PlexNetworking.instance.get(
      url,
      query: queryParams,
      headers: headers,
      timeout: timeout,
      cancelToken: cancelToken,
    );
    return _handleResponse(response);
  }

  /// Makes a GET request with type-safe response parsing.
  Future<PlexApiResult> getTyped<T>(
    String endpoint, {
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    bool useFullUrl = false,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    final url = useFullUrl ? endpoint : endpoint;
    final response = await PlexNetworking.instance.getTyped<T>(
      url,
      query: queryParams,
      headers: headers,
      fromJson: fromJson,
      timeout: timeout,
      cancelToken: cancelToken,
    );
    return _handleResponse(response);
  }

  /// Makes a POST request to the specified endpoint
  Future<PlexApiResult> post(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Map<String, dynamic>? formData,
    bool useFullUrl = false,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    final url = useFullUrl ? endpoint : endpoint;
    final response = await PlexNetworking.instance.post(
      url,
      query: queryParams,
      headers: headers,
      body: body,
      formData: formData,
      timeout: timeout,
      cancelToken: cancelToken,
    );
    return _handleResponse(response);
  }

  /// Makes a POST request with type-safe response parsing.
  Future<PlexApiResult> postTyped<T>(
    String endpoint, {
    required T Function(Map<String, dynamic>) fromJson,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Map<String, dynamic>? formData,
    bool useFullUrl = false,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    final url = useFullUrl ? endpoint : endpoint;
    final response = await PlexNetworking.instance.postTyped<T>(
      url,
      query: queryParams,
      headers: headers,
      body: body,
      formData: formData,
      fromJson: fromJson,
      timeout: timeout,
      cancelToken: cancelToken,
    );
    return _handleResponse(response);
  }

  /// Makes a PUT request to the specified endpoint (used for updates)
  Future<PlexApiResult> put(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Map<String, dynamic>? formData,
    bool useFullUrl = false,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    final url = useFullUrl ? endpoint : endpoint;
    final response = await PlexNetworking.instance.put(
      url,
      query: queryParams,
      headers: headers,
      body: body,
      formData: formData,
      timeout: timeout,
      cancelToken: cancelToken,
    );
    return _handleResponse(response);
  }

  /// Makes a DELETE request to the specified endpoint
  Future<PlexApiResult> delete(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    dynamic body,
    bool useFullUrl = false,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    final url = useFullUrl ? endpoint : endpoint;
    final response = await PlexNetworking.instance.delete(
      url,
      query: queryParams,
      headers: headers,
      body: body,
      timeout: timeout,
      cancelToken: cancelToken,
    );
    return _handleResponse(response);
  }

  /// Makes a multipart POST request to the specified endpoint for uploading files
  Future<PlexApiResult> uploadFiles(
    String endpoint, {
    required Map<String, String> formData,
    required Map<String, File> files,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    bool useFullUrl = false,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    final url = useFullUrl ? endpoint : endpoint;
    final response = await PlexNetworking.instance.postMultipart2(
      url,
      query: queryParams,
      headers: headers,
      formData: formData,
      files: files,
      timeout: timeout,
      cancelToken: cancelToken,
    );
    return _handleResponse(response);
  }

  /// Downloads a file from the specified URL
  Future<void> downloadFile(String url, {required String filename, required Function(int downloaded, double? percentage, File? file) onProgressUpdate}) {
    return PlexNetworking.instance.downloadFile(url, filename: filename, onProgressUpdate: onProgressUpdate);
  }

  PlexApiResult _handleResponse(PlexApiResponse response) {
    if (response is PlexSuccess) {
      return PlexApiResult(true, 200, 'Success', response.response);
    }
    if (response is PlexError) {
      return PlexApiResult(false, response.code, response.message, null);
    }
    if (response is PlexNetworkTimeout) {
      return PlexApiResult(false, 408, 'Request timeout', null);
    }
    if (response is PlexNetworkNoConnectivity) {
      return PlexApiResult(false, 5001, 'Network not available', null);
    }
    if (response is PlexNetworkCancelled) {
      return PlexApiResult(false, 499, 'Request cancelled', null);
    }
    if (response is PlexNetworkServerError) {
      return PlexApiResult(false, response.statusCode, response.body.toString(), null);
    }
    if (response is PlexNetworkParseError) {
      return PlexApiResult(false, 400, response.cause, null);
    }
    return PlexApiResult(false, 0, 'Unknown error', null);
  }
}

/// Deprecated: Use [PlexApi] instead.
@Deprecated('Use PlexApi instead')
typedef PlexCalls = PlexApi;
