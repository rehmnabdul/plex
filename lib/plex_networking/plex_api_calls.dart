import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:plex/plex_networking/plex_networking.dart';

/// A utility class that provides simplified methods for making API calls
/// using the underlying PlexNetworking functionality.
class PlexCalls {
  /// Singleton instance of PlexCalls
  static final PlexCalls instance = PlexCalls._();

  PlexCalls._();

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
  ///
  /// [endpoint] - The API endpoint (will be appended to the base URL)
  /// [queryParams] - Optional query parameters to append to the URL
  /// [headers] - Optional headers to include in the request
  /// [useFullUrl] - If true, [endpoint] is treated as a complete URL
  ///
  /// Returns a [Future<PlexApiResult>] containing the response
  Future<PlexApiResult> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    bool useFullUrl = false,
  }) async {
    final url = useFullUrl ? endpoint : endpoint;
    final response = await PlexNetworking.instance.get(
      url,
      query: queryParams,
      headers: headers,
    );

    return _handleResponse(response);
  }

  /// Makes a POST request to the specified endpoint
  ///
  /// [endpoint] - The API endpoint (will be appended to the base URL)
  /// [body] - The request body (will be serialized to JSON)
  /// [queryParams] - Optional query parameters to append to the URL
  /// [headers] - Optional headers to include in the request
  /// [formData] - Optional form data (for application/x-www-form-urlencoded)
  /// [useFullUrl] - If true, [endpoint] is treated as a complete URL
  ///
  /// Returns a [Future<PlexApiResult>] containing the response
  Future<PlexApiResult> post(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Map<String, dynamic>? formData,
    bool useFullUrl = false,
  }) async {
    final url = useFullUrl ? endpoint : endpoint;
    final response = await PlexNetworking.instance.post(
      url,
      query: queryParams,
      headers: headers,
      body: body,
      formData: formData,
    );

    return _handleResponse(response);
  }

  /// Makes a PUT request to the specified endpoint (used for updates)
  ///
  /// [endpoint] - The API endpoint (will be appended to the base URL)
  /// [body] - The request body (will be serialized to JSON)
  /// [queryParams] - Optional query parameters to append to the URL
  /// [headers] - Optional headers to include in the request
  /// [formData] - Optional form data (for application/x-www-form-urlencoded)
  /// [useFullUrl] - If true, [endpoint] is treated as a complete URL
  ///
  /// Returns a [Future<PlexApiResult>] containing the response
  Future<PlexApiResult> put(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    Map<String, dynamic>? formData,
    bool useFullUrl = false,
  }) async {
    final url = useFullUrl ? endpoint : endpoint;
    final response = await PlexNetworking.instance.put(
      url,
      query: queryParams,
      headers: headers,
      body: body,
      formData: formData,
    );

    return _handleResponse(response);
  }

  /// Makes a DELETE request to the specified endpoint
  ///
  /// [endpoint] - The API endpoint (will be appended to the base URL)
  /// [queryParams] - Optional query parameters to append to the URL
  /// [headers] - Optional headers to include in the request
  /// [body] - Optional request body (will be serialized to JSON)
  /// [useFullUrl] - If true, [endpoint] is treated as a complete URL
  ///
  /// Returns a [Future<PlexApiResult>] containing the response
  Future<PlexApiResult> delete(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    dynamic body,
    bool useFullUrl = false,
  }) async {
    final url = useFullUrl ? endpoint : endpoint;

    // Create headers with standard content type if not specified
    final Map<String, String> requestHeaders = headers ?? {};
    if (!requestHeaders.containsKey("Content-Type")) {
      requestHeaders["Content-Type"] = "application/json";
    }

    final uri = Uri.parse(url);
    http.Response response;

    try {
      if (await PlexNetworking.instance.isNetworkAvailable() == false) {
        return PlexApiResult(false, 5001, 'Network not available', null);
      }

      // Apply standard headers from callback if available
      if (PlexNetworking.instance.addHeaders != null) {
        final standardHeaders = await PlexNetworking.instance.addHeaders!();
        requestHeaders.addAll(standardHeaders);
      }

      if (kDebugMode) print("DELETE Started: ${uri.toString()}");
      final startTime = DateTime.now();

      if (body != null) {
        response = await http.delete(
          uri,
          headers: requestHeaders,
          body: jsonEncode(body),
        );
      } else {
        response = await http.delete(
          uri,
          headers: requestHeaders,
        );
      }

      final diffInMillis = DateTime.now().difference(startTime).inMilliseconds;
      if (kDebugMode) print("DELETE Completed: ${response.statusCode}: ${uri.toString()} in ${diffInMillis}ms");

      // Parse response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        dynamic responseData;
        try {
          responseData = jsonDecode(response.body);
        } catch (e) {
          responseData = response.body;
        }
        return PlexApiResult(true, response.statusCode, 'Success', responseData);
      } else {
        return PlexApiResult(false, response.statusCode, response.body.isEmpty ? response.reasonPhrase ?? 'Error' : response.body, null);
      }
    } catch (e) {
      if (kDebugMode) print("DELETE Error: ${e.toString()}");
      if (e is SocketException) {
        return PlexApiResult(false, 5002, 'Network Available But Unable To Connect With Server', null);
      }
      return PlexApiResult(false, 400, e.toString(), null);
    }
  }

  /// Makes a multipart POST request to the specified endpoint for uploading files
  ///
  /// [endpoint] - The API endpoint (will be appended to the base URL)
  /// [formData] - Required form data for the multipart request
  /// [files] - Required map of file names to File objects to upload
  /// [queryParams] - Optional query parameters to append to the URL
  /// [headers] - Optional headers to include in the request
  /// [useFullUrl] - If true, [endpoint] is treated as a complete URL
  ///
  /// Returns a [Future<PlexApiResult>] containing the response
  Future<PlexApiResult> uploadFiles(
    String endpoint, {
    required Map<String, String> formData,
    required Map<String, File> files,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    bool useFullUrl = false,
  }) async {
    final url = useFullUrl ? endpoint : endpoint;
    final response = await PlexNetworking.instance.postMultipart2(
      url,
      query: queryParams,
      headers: headers,
      formData: formData,
      files: files,
    );

    return _handleResponse(response);
  }

  /// Downloads a file from the specified URL
  ///
  /// [url] - The URL from which to download the file
  /// [filename] - The name to give the downloaded file
  /// [onProgressUpdate] - Callback function to track download progress
  ///
  /// Returns a [Future] that completes when the download is finished
  Future<void> downloadFile(String url, {required String filename, required Function(int downloaded, double? percentage, File? file) onProgressUpdate}) {
    return PlexNetworking.instance.downloadFile(url, filename: filename, onProgressUpdate: onProgressUpdate);
  }

  /// Helper method to process the response from PlexNetworking
  PlexApiResult _handleResponse(PlexApiResponse response) {
    if (response is PlexSuccess) {
      return PlexApiResult(true, 200, 'Success', response.response);
    } else if (response is PlexError) {
      return PlexApiResult(false, response.code, response.message, null);
    } else {
      return PlexApiResult(false, 0, 'Unknown error', null);
    }
  }
}
