import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:plex/plex_database/plex_database.dart';
import 'package:plex/plex_networking/plex_cache.dart';
import 'package:plex/plex_networking/plex_interceptor.dart';
import 'package:plex/plex_utils/plex_logger.dart';

/// Token to cancel an in-flight HTTP request.
class PlexCancelToken {
  bool _cancelled = false;

  bool get isCancelled => _cancelled;

  void cancel() => _cancelled = true;
}

/// Sealed hierarchy for network errors. Enables pattern matching.
sealed class PlexNetworkError<T> extends PlexApiResponse<T> {}

class PlexNetworkTimeout<T> extends PlexNetworkError<T> {}

class PlexNetworkNoConnectivity<T> extends PlexNetworkError<T> {}

class PlexNetworkCancelled<T> extends PlexNetworkError<T> {}

class PlexNetworkServerError<T> extends PlexNetworkError<T> {
  final int statusCode;
  final dynamic body;

  PlexNetworkServerError(this.statusCode, this.body);
}

class PlexNetworkParseError<T> extends PlexNetworkError<T> {
  final String cause;
  final dynamic raw;

  PlexNetworkParseError(this.cause, this.raw);
}

class PlexApiResult {
  final bool success;
  final int code;
  final String message;
  bool isLastPage;
  final dynamic data;

  PlexApiResult(this.success, this.code, this.message, this.data, {this.isLastPage = false});
}

class PlexApiResponse<T> {}

class PlexSuccess<T> extends PlexApiResponse<T> {
  late dynamic response;

  /// Optional typed response, populated by getTyped/postTyped.
  T? typedResponse;

  PlexSuccess(String? body) {
    if (body == null) response = null;
    try {
      response = jsonDecode(body!);
    } catch (e) {
      response = body!.toString();
    }
  }

  /// Creates a typed success with a parsed object.
  PlexSuccess.typed(T value) : typedResponse = value {
    response = value;
  }
}

class PlexError<T> extends PlexApiResponse<T> {
  int code;
  String message;

  PlexError(this.code, this.message);
}

class AppHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class PlexNetworking {
  static PlexNetworking instance = PlexNetworking._();

  String _apiUrl() {
    if (_basePath == null) throw Exception("Server Base Url is not provided");
    return _basePath!;
  }

  ///Optional [basePath]
  ///If you not set base path it will suppose you enter complete [url] in [get][post] & [download] function parameter
  void setBasePath(String? basePath) {
    _basePath = basePath;
  }

  String? _basePath;

  /// Default timeout for HTTP requests. Applied when no per-request timeout is provided.
  Duration defaultTimeout = const Duration(seconds: 30);

  final List<PlexInterceptor> _interceptors = [];

  /// Add an interceptor to the pipeline. Runs in order of addition.
  void addInterceptor(PlexInterceptor interceptor) => _interceptors.add(interceptor);

  /// Remove an interceptor.
  void removeInterceptor(PlexInterceptor interceptor) => _interceptors.remove(interceptor);

  PlexCacheLayer? _cacheLayer;

  /// Enable response caching for GET requests.
  Future<void> enableCache(PlexCacheConfig config, PlexDb db) async {
    _cacheLayer = PlexCacheLayer(config, db);
  }

  /// Clear the HTTP cache. If [urlPattern] is provided, only matching entries are cleared.
  Future<void> clearCache({String? urlPattern}) async {
    await _cacheLayer?.clear(urlPattern: urlPattern);
  }

  Future<Map<String, String>> _runRequestInterceptors(String url, Map<String, String> headers) async {
    var current = headers;
    for (final interceptor in _interceptors) {
      current = await interceptor.onRequest(url, current);
    }
    return current;
  }

  Future<PlexApiResponse> _runResponseInterceptors(PlexApiResponse response) async {
    var current = response;
    for (final interceptor in _interceptors) {
      current = await interceptor.onResponse(current);
    }
    return current;
  }

  Future<PlexApiResponse> _runErrorInterceptors(Object error, StackTrace stack) async {
    PlexApiResponse result = PlexError(400, error.toString());
    for (final interceptor in _interceptors) {
      result = await interceptor.onError(error, stack);
    }
    return result;
  }

  PlexRetryInterceptor? get _retryInterceptor {
    for (final i in _interceptors) {
      if (i is PlexRetryInterceptor) return i;
    }
    return null;
  }

  PlexNetworking._();

  ///Call this method to allow bad https certificate and manually verify them.
  ///If you trust your API server and it's certificate you can override the HTTPS system check
  allowBadCertificateForHTTPS({HttpOverrides? customOverrides}) {
    HttpOverrides.global = customOverrides ?? AppHttpOverrides();
  }

  Future<bool> isNetworkAvailable() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult[0] == ConnectivityResult.mobile || connectivityResult[0] == ConnectivityResult.wifi || connectivityResult[0] == ConnectivityResult.ethernet || connectivityResult[0] == ConnectivityResult.bluetooth || connectivityResult[0] == ConnectivityResult.vpn) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return true;
    }
  }

  ///Override this callback to always attach headers in the request i.e. UserId, AuthToken etc.
  Future<Map<String, String>> Function()? addHeaders;

  _isValidUrl(String url) {
    try {
      return Uri.parse(url).scheme.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<PlexApiResponse> get(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    if (await isNetworkAvailable() == false) {
      return PlexNetworkNoConnectivity();
    }

    final baseUrl = url;
    if (query != null && query.isNotEmpty) {
      url += "?";
      query.forEach((key, value) {
        url += "$key=$value&";
      });
      url = url.substring(0, url.length - 1);
    }

    if (_cacheLayer != null) {
      final cachedBody = await _cacheLayer!.get(baseUrl, query);
      if (cachedBody != null) {
        return _runResponseInterceptors(PlexSuccess(cachedBody));
      }
    }

    var currentHeaders = <String, String>{};
    if (addHeaders != null) {
      currentHeaders.addAll(await addHeaders!());
    }
    if (headers != null) {
      currentHeaders.addAll(headers);
    }
    if (!currentHeaders.containsKey("Content-Type")) {
      currentHeaders["Content-Type"] = "application/json";
    }
    currentHeaders = await _runRequestInterceptors(url, currentHeaders);

    final retry = _retryInterceptor;
    final maxAttempts = retry?.maxAttempts ?? 1;
    var lastResponse = PlexNetworkNoConnectivity() as PlexApiResponse;
    final requestTimeout = timeout ?? defaultTimeout;

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      if (cancelToken?.isCancelled == true) {
        lastResponse = PlexNetworkCancelled();
        break;
      }
      try {
        var startTime = DateTime.now();
        var uri = Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url);
        PlexLogger.d('Networking', 'Started: ${uri.toString()}');

        var data = await http.get(uri, headers: currentHeaders).timeout(requestTimeout);
        if (cancelToken?.isCancelled == true) {
          lastResponse = PlexNetworkCancelled();
          break;
        }
        var diffInMillis = DateTime.now().difference(startTime).inMilliseconds;
        PlexLogger.d('Networking', 'Completed: ${data.statusCode}: ${uri.toString()} in ${diffInMillis}ms');

        if (data.statusCode == 200) {
          await _cacheLayer?.put(baseUrl, query, data.body);
          lastResponse = PlexSuccess(data.body);
        } else {
          lastResponse = PlexNetworkServerError(
            data.statusCode,
            data.body.isEmpty ? (data.reasonPhrase ?? data.body) : data.body,
          );
        }

        final statusCode = lastResponse is PlexNetworkServerError ? lastResponse.statusCode : 0;
        final shouldRetry = lastResponse is PlexNetworkServerError && retry != null && retry.retryOnStatusCodes.contains(statusCode) && attempt < maxAttempts - 1;
        if (!shouldRetry) break;
      } catch (e, stack) {
        if (e is TimeoutException) {
          lastResponse = PlexNetworkTimeout();
        } else if (e is SocketException) {
          lastResponse = PlexNetworkNoConnectivity();
        } else {
          PlexLogger.e('Networking', 'Request failed', error: e);
          lastResponse = await _runErrorInterceptors(e, stack);
        }
        break;
      }
    }

    return _runResponseInterceptors(lastResponse);
  }

  /// GET with type-safe response parsing.
  Future<PlexApiResponse<T>> getTyped<T>(
    String url, {
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    final raw = await get(url, query: query, headers: headers, timeout: timeout, cancelToken: cancelToken);
    if (raw is PlexSuccess) {
      try {
        return PlexSuccess<T>.typed(fromJson(raw.response as Map<String, dynamic>));
      } catch (e) {
        return PlexNetworkParseError<T>(e.toString(), raw.response);
      }
    }
    return raw as PlexApiResponse<T>;
  }

  Future<PlexApiResponse> post(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Map<String, dynamic>? formData,
    dynamic body,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    if (await isNetworkAvailable() == false) return PlexNetworkNoConnectivity();

    if (query?.isNotEmpty == true) {
      url += "?";
      query?.forEach((key, value) {
        url += "$key=$value&";
      });
      url = url.substring(0, url.length - 1);
    }

    var currentHeaders = <String, String>{};
    if (addHeaders != null) currentHeaders.addAll(await addHeaders!());
    if (headers != null) currentHeaders.addAll(headers);
    if (formData == null && !currentHeaders.containsKey("Content-Type")) {
      currentHeaders["Content-Type"] = "application/json";
    }
    currentHeaders = await _runRequestInterceptors(url, currentHeaders);

    final retry = _retryInterceptor;
    final maxAttempts = retry?.maxAttempts ?? 1;
    PlexApiResponse lastResponse = PlexNetworkNoConnectivity();
    final requestTimeout = timeout ?? defaultTimeout;

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      if (cancelToken?.isCancelled == true) {
        lastResponse = PlexNetworkCancelled();
        break;
      }
      try {
        var startTime = DateTime.now();
        var uri = Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url);
        PlexLogger.d('Networking', 'Started: ${uri.toString()}');

        late http.Response data;
        if (formData != null) {
          data = await http.post(uri, headers: currentHeaders, body: formData).timeout(requestTimeout);
        } else if (body != null) {
          data = await http.post(uri, headers: currentHeaders, body: jsonEncode(body)).timeout(requestTimeout);
        } else {
          data = await http.post(uri, headers: currentHeaders, body: null).timeout(requestTimeout);
        }
        if (cancelToken?.isCancelled == true) {
          lastResponse = PlexNetworkCancelled();
          break;
        }

        var diffInMillis = DateTime.now().difference(startTime).inMilliseconds;
        PlexLogger.d('Networking', 'Completed: ${data.statusCode}: ${uri.toString()} in ${diffInMillis}ms');
        if (data.statusCode == 200) {
          lastResponse = PlexSuccess(data.body);
        } else {
          lastResponse = PlexNetworkServerError(
            data.statusCode,
            data.body.isEmpty ? (data.reasonPhrase ?? data.body) : data.body,
          );
        }

        final statusCode = lastResponse is PlexNetworkServerError ? lastResponse.statusCode : 0;
        final shouldRetry = lastResponse is PlexNetworkServerError && retry != null && retry.retryOnStatusCodes.contains(statusCode) && attempt < maxAttempts - 1;
        if (!shouldRetry) break;
      } catch (e, stack) {
        if (e is TimeoutException) {
          lastResponse = PlexNetworkTimeout();
        } else if (e is SocketException) {
          lastResponse = PlexNetworkNoConnectivity();
        } else {
          PlexLogger.e('Networking', 'Request failed', error: e);
          lastResponse = await _runErrorInterceptors(e, stack);
        }
        break;
      }
    }
    return _runResponseInterceptors(lastResponse);
  }

  /// POST with type-safe response parsing.
  Future<PlexApiResponse<T>> postTyped<T>(
    String url, {
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Map<String, dynamic>? formData,
    dynamic body,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    final raw = await post(url, query: query, headers: headers, formData: formData, body: body, timeout: timeout, cancelToken: cancelToken);
    if (raw is PlexSuccess) {
      try {
        return PlexSuccess<T>.typed(fromJson(raw.response as Map<String, dynamic>));
      } catch (e) {
        return PlexNetworkParseError<T>(e.toString(), raw.response);
      }
    }
    return raw as PlexApiResponse<T>;
  }

  Future<PlexApiResponse> put(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Map<String, dynamic>? formData,
    dynamic body,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    if (await isNetworkAvailable() == false) return PlexNetworkNoConnectivity();

    if (query?.isNotEmpty == true) {
      url += "?";
      query?.forEach((key, value) {
        url += "$key=$value&";
      });
      url = url.substring(0, url.length - 1);
    }

    var currentHeaders = <String, String>{};
    if (addHeaders != null) currentHeaders.addAll(await addHeaders!());
    if (headers != null) currentHeaders.addAll(headers);
    if (formData == null && !currentHeaders.containsKey("Content-Type")) {
      currentHeaders["Content-Type"] = "application/json";
    }
    currentHeaders = await _runRequestInterceptors(url, currentHeaders);

    final retry = _retryInterceptor;
    final maxAttempts = retry?.maxAttempts ?? 1;
    PlexApiResponse lastResponse = PlexNetworkNoConnectivity();
    final requestTimeout = timeout ?? defaultTimeout;

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      if (cancelToken?.isCancelled == true) {
        lastResponse = PlexNetworkCancelled();
        break;
      }
      try {
        var startTime = DateTime.now();
        var uri = Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url);
        PlexLogger.d('Networking', 'Started: ${uri.toString()}');

        late http.Response data;
        if (formData != null) {
          data = await http.put(uri, headers: currentHeaders, body: formData).timeout(requestTimeout);
        } else if (body != null) {
          data = await http.put(uri, headers: currentHeaders, body: jsonEncode(body)).timeout(requestTimeout);
        } else {
          data = await http.put(uri, headers: currentHeaders, body: null).timeout(requestTimeout);
        }
        if (cancelToken?.isCancelled == true) {
          lastResponse = PlexNetworkCancelled();
          break;
        }

        var diffInMillis = DateTime.now().difference(startTime).inMilliseconds;
        PlexLogger.d('Networking', 'Completed: ${data.statusCode}: ${uri.toString()} in ${diffInMillis}ms');
        if (data.statusCode == 200) {
          lastResponse = PlexSuccess(data.body);
        } else {
          lastResponse = PlexNetworkServerError(
            data.statusCode,
            data.body.isEmpty ? (data.reasonPhrase ?? data.body) : data.body,
          );
        }

        final statusCode = lastResponse is PlexNetworkServerError ? lastResponse.statusCode : 0;
        final shouldRetry = lastResponse is PlexNetworkServerError && retry != null && retry.retryOnStatusCodes.contains(statusCode) && attempt < maxAttempts - 1;
        if (!shouldRetry) break;
      } catch (e, stack) {
        if (e is TimeoutException) {
          lastResponse = PlexNetworkTimeout();
        } else if (e is SocketException) {
          lastResponse = PlexNetworkNoConnectivity();
        } else {
          PlexLogger.e('Networking', 'Request failed', error: e);
          lastResponse = await _runErrorInterceptors(e, stack);
        }
        break;
      }
    }
    return _runResponseInterceptors(lastResponse);
  }

  Future<PlexApiResponse> delete(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    dynamic body,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    if (await isNetworkAvailable() == false) return PlexNetworkNoConnectivity();

    if (query?.isNotEmpty == true) {
      url += "?";
      query?.forEach((key, value) {
        url += "$key=$value&";
      });
      url = url.substring(0, url.length - 1);
    }

    var currentHeaders = <String, String>{};
    if (addHeaders != null) currentHeaders.addAll(await addHeaders!());
    if (headers != null) currentHeaders.addAll(headers);
    if (!currentHeaders.containsKey("Content-Type")) {
      currentHeaders["Content-Type"] = "application/json";
    }
    currentHeaders = await _runRequestInterceptors(url, currentHeaders);

    final retry = _retryInterceptor;
    final maxAttempts = retry?.maxAttempts ?? 1;
    PlexApiResponse lastResponse = PlexNetworkNoConnectivity();
    final requestTimeout = timeout ?? defaultTimeout;

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      if (cancelToken?.isCancelled == true) {
        lastResponse = PlexNetworkCancelled();
        break;
      }
      try {
        var startTime = DateTime.now();
        var uri = Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url);
        PlexLogger.d('Networking', 'DELETE Started: ${uri.toString()}');

        late http.Response data;
        if (body != null) {
          data = await http.delete(uri, headers: currentHeaders, body: jsonEncode(body)).timeout(requestTimeout);
        } else {
          data = await http.delete(uri, headers: currentHeaders).timeout(requestTimeout);
        }
        if (cancelToken?.isCancelled == true) {
          lastResponse = PlexNetworkCancelled();
          break;
        }

        var diffInMillis = DateTime.now().difference(startTime).inMilliseconds;
        PlexLogger.d('Networking', 'DELETE Completed: ${data.statusCode}: ${uri.toString()} in ${diffInMillis}ms');

        if (data.statusCode >= 200 && data.statusCode < 300) {
          lastResponse = PlexSuccess(data.body);
        } else {
          lastResponse = PlexNetworkServerError(
            data.statusCode,
            data.body.isEmpty ? (data.reasonPhrase ?? data.body) : data.body,
          );
        }

        final statusCode = lastResponse is PlexNetworkServerError ? lastResponse.statusCode : 0;
        final shouldRetry = lastResponse is PlexNetworkServerError &&
            retry != null &&
            retry.retryOnStatusCodes.contains(statusCode) &&
            attempt < maxAttempts - 1;
        if (!shouldRetry) break;
      } catch (e, stack) {
        if (e is TimeoutException) {
          lastResponse = PlexNetworkTimeout();
        } else if (e is SocketException) {
          lastResponse = PlexNetworkNoConnectivity();
        } else {
          PlexLogger.e('Networking', 'DELETE failed', error: e);
          lastResponse = await _runErrorInterceptors(e, stack);
        }
        break;
      }
    }
    return _runResponseInterceptors(lastResponse);
  }

  Future<PlexApiResponse> postMultipart(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required Map<String, String> formData,
    required Map<String, File> files,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    if (await isNetworkAvailable() == false) return PlexNetworkNoConnectivity();

    if (query?.isNotEmpty == true) {
      url += "?";
      query?.forEach((key, value) {
        url += "${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}&";
      });
      url = url.substring(0, url.length - 1);
    }

    var currentHeaders = <String, String>{};
    if (addHeaders != null) currentHeaders.addAll(await addHeaders!());
    if (headers != null) currentHeaders.addAll(headers);
    if (!currentHeaders.containsKey("Content-Type")) {
      currentHeaders["Content-Type"] = "application/json";
    }
    currentHeaders = await _runRequestInterceptors(url, currentHeaders);
    final requestTimeout = timeout ?? defaultTimeout;

    if (cancelToken?.isCancelled == true) return _runResponseInterceptors(PlexNetworkCancelled());

    try {
      var startTime = DateTime.now();
      var uri = Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url);
      PlexLogger.d('Networking', 'Started: ${uri.toString()}');

      var multipartFiles = List<http.MultipartFile>.empty(growable: true);
      var filesKeys = files.keys.toList();
      for (var i = 0; i < filesKeys.length; i++) {
        var multipart = await http.MultipartFile.fromPath(filesKeys[i], files[filesKeys[i]]!.path);
        multipartFiles.add(multipart);
      }

      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(currentHeaders);
      request.fields.addAll(formData);
      request.files.addAll(multipartFiles);

      var data = await request.send().timeout(requestTimeout);
      if (cancelToken?.isCancelled == true) return _runResponseInterceptors(PlexNetworkCancelled());

      var diffInMillis = DateTime.now().difference(startTime).inMilliseconds;
      PlexLogger.d('Networking', 'Completed: ${data.statusCode}: ${uri.toString()} in ${diffInMillis}ms');
      PlexApiResponse lastResponse;
      if (data.statusCode == 200) {
        var responseBody = await data.stream.transform(utf8.decoder).join();
        lastResponse = PlexSuccess(responseBody);
      } else {
        var responseBody = await data.stream.transform(utf8.decoder).join();
        lastResponse = PlexNetworkServerError(
          data.statusCode,
          responseBody.isEmpty ? (data.reasonPhrase ?? responseBody) : responseBody,
        );
      }
      return _runResponseInterceptors(lastResponse);
    } catch (e, stack) {
      if (e is TimeoutException) {
        return _runResponseInterceptors(PlexNetworkTimeout());
      }
      if (e is SocketException) {
        return _runResponseInterceptors(PlexNetworkNoConnectivity());
      }
      PlexLogger.e('Networking', 'Request failed', error: e);
      return _runResponseInterceptors(await _runErrorInterceptors(e, stack));
    }
  }

  Future<PlexApiResponse> postMultipart2(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required Map<String, String> formData,
    required Map<String, File> files,
    Duration? timeout,
    PlexCancelToken? cancelToken,
  }) async {
    if (await isNetworkAvailable() == false) return PlexNetworkNoConnectivity();

    if (query?.isNotEmpty == true) {
      url += "?${query!.entries.map((e) => "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}").join("&")}";
    }

    var currentHeaders = <String, String>{};
    if (addHeaders != null) currentHeaders.addAll(await addHeaders!());
    if (headers != null) currentHeaders.addAll(headers);
    PlexLogger.d('Networking', 'Headers: $currentHeaders');
    currentHeaders = await _runRequestInterceptors(url, currentHeaders);
    final requestTimeout = timeout ?? defaultTimeout;

    if (cancelToken?.isCancelled == true) return _runResponseInterceptors(PlexNetworkCancelled());

    try {
      var uri = Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url);
      PlexLogger.d('Networking', 'Started: ${uri.toString()}');

      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(currentHeaders);
      request.fields.addAll(formData);
      for (var entry in files.entries) {
        var multipartFile = await http.MultipartFile.fromPath(entry.key, entry.value.path);
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send().timeout(requestTimeout);
      if (cancelToken?.isCancelled == true) return _runResponseInterceptors(PlexNetworkCancelled());

      var responseBody = await streamedResponse.stream.transform(utf8.decoder).join();

      PlexLogger.d('Networking', 'Completed: ${streamedResponse.statusCode}: ${responseBody.toString()}');

      PlexApiResponse lastResponse;
      if (streamedResponse.statusCode == 200) {
        lastResponse = PlexSuccess(responseBody);
      } else {
        lastResponse = PlexNetworkServerError(
          streamedResponse.statusCode,
          responseBody.isEmpty ? streamedResponse.reasonPhrase ?? "Unknown error" : responseBody,
        );
      }
      return _runResponseInterceptors(lastResponse);
    } catch (e, stack) {
      if (e is TimeoutException) {
        return _runResponseInterceptors(PlexNetworkTimeout());
      }
      if (e is SocketException) {
        return _runResponseInterceptors(PlexNetworkNoConnectivity());
      }
      PlexLogger.e('Networking', 'Request failed', error: e);
      return _runResponseInterceptors(await _runErrorInterceptors(e, stack));
    }
  }

  ///[url] will be used as download url for the file
  ///
  ///[filename] will be used as file name for saving the file in app documents directory
  ///
  ///[onProgressUpdate] will be used as callback function
  ///
  ///[onProgressUpdate.downloaded] will return downloaded bytes
  ///
  ///[onProgressUpdate.downloaded] will return -1 bytes if there is an error while downloading
  ///
  ///[onProgressUpdate.percentage] will return download percentage if available else it will return null
  ///
  ///[onProgressUpdate.file] will return download file
  Future downloadFile(String url, {required String filename, required Function(int downloaded, double? percentage, File? file) onProgressUpdate}) async {
    if (await isNetworkAvailable() == false) {
      return PlexNetworkNoConnectivity();
    }

    var httpClient = http.Client();
    var request = http.Request('GET', Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url));
    var response = httpClient.send(request);
    String dir = (await getApplicationDocumentsDirectory()).path;

    List<List<int>> chunks = List.empty(growable: true);
    int downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen(cancelOnError: true, (List<int> chunk) {
        PlexLogger.d('Networking', 'downloadPercentage: ${r.contentLength != null ? (downloaded / r.contentLength! * 100) : downloaded}');
        onProgressUpdate(downloaded, r.contentLength != null ? (downloaded / r.contentLength! * 100) : null, null);
        chunks.add(chunk);
        downloaded += chunk.length;
      }, onDone: () async {
        PlexLogger.d('Networking', 'downloadPercentage: ${r.contentLength != null ? (downloaded / r.contentLength! * 100) : downloaded}');
        onProgressUpdate(downloaded, r.contentLength != null ? (downloaded / r.contentLength! * 100) : null, null);

        // Save the file
        File file = File('$dir/$filename');
        final Uint8List bytes = Uint8List(downloaded);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await file.writeAsBytes(bytes);

        onProgressUpdate(downloaded, r.contentLength != null ? (downloaded / r.contentLength! * 100) : null, file);
      }, onError: (error) {
        onProgressUpdate(-1, null, null);
      });
    });
  }
}
