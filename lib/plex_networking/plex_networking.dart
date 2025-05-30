import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

  PlexSuccess(String? body) {
    if (body == null) response = null;
    try {
      response = jsonDecode(body!);
    } catch (e) {
      response = body!.toString();
    }
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

  final _noNetwork = PlexError(5001, 'Network not available');
  final _connectionFailed = PlexError(5002, 'Network Available But Unable To Connect With Server');

  ///Override this callback to always attach headers in the request i.e. UserId, AuthToken etc.
  Future<Map<String, String>> Function()? addHeaders;

  _isValidUrl(String url) {
    try {
      return Uri.parse(url).scheme.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<PlexApiResponse> get(String url, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    if (await isNetworkAvailable() == false) {
      return _noNetwork;
    }

    if (query != null && query.isNotEmpty) {
      url += "?";
      query.forEach((key, value) {
        url += "$key=$value&";
      });
      url = url.substring(0, url.length - 1);
    }

    var currentHeaders = <String, String>{};

    if (addHeaders != null) {
      var constHeaders = await addHeaders!.call();
      currentHeaders.addAll(constHeaders);
    }

    if (headers != null) {
      currentHeaders.addAll(headers);
    }

    if (!currentHeaders.containsKey("Content-Type")) {
      currentHeaders["Content-Type"] = "application/json";
    }

    try {
      var startTime = DateTime.now();
      var uri = Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url);
      if (kDebugMode) print("Started: ${uri.toString()}");

      var data = await http.get(uri, headers: currentHeaders).timeout(Duration(seconds: 120), onTimeout: () {
        print("Timeout");
        return http.Response('Error', 408);
      });
      var diffInMillis = DateTime.now().difference(startTime).inMilliseconds;
      if (kDebugMode) print("Completed: ${data.statusCode}: ${uri.toString()} in ${diffInMillis}ms");
      if (data.statusCode == 200) {
        return PlexSuccess(data.body);
      } else {
        if (data.body.isEmpty) {
          return PlexError(data.statusCode, data.reasonPhrase ?? data.body);
        }
        return PlexError(data.statusCode, data.body);
      }
    } catch (e) {
      if (e is SocketException) {
        return _connectionFailed;
      }
      if (kDebugMode) print("Error: ${e.toString()}");
      return PlexError(400, e.toString());
    }
  }

  Future<PlexApiResponse> post(String url, {Map<String, dynamic>? query, Map<String, String>? headers, Map<String, dynamic>? formData, dynamic body}) async {
    if (await isNetworkAvailable() == false) {
      return _noNetwork;
    }

    if (query?.isNotEmpty == true) {
      url += "?";
      query?.forEach((key, value) {
        url += "$key=$value&";
      });
      url = url.substring(0, url.length - 1);
    }

    var currentHeaders = <String, String>{};

    if (addHeaders != null) {
      var constHeaders = await addHeaders!.call();
      currentHeaders.addAll(constHeaders);
    }

    if (headers != null) {
      currentHeaders.addAll(headers);
    }

    if (formData == null && !currentHeaders.containsKey("Content-Type")) {
      currentHeaders["Content-Type"] = "application/json";
    }

    try {
      var startTime = DateTime.now();
      var uri = Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url);
      if (kDebugMode) print("Started: ${uri.toString()}");

      late http.Response data;
      if (formData != null) {
        data = await http.post(uri, headers: currentHeaders, body: formData);
      } else if (body != null) {
        data = await http.post(uri, headers: currentHeaders, body: jsonEncode(body));
      } else {
        data = await http.post(uri, headers: currentHeaders, body: null);
      }

      var diffInMillis = DateTime.now().difference(startTime).inMilliseconds;
      if (kDebugMode) print("Completed: ${data.statusCode}: ${uri.toString()} in ${diffInMillis}ms");
      if (data.statusCode == 200) {
        return PlexSuccess(data.body);
      } else {
        if (data.body.isEmpty) {
          return PlexError(data.statusCode, data.reasonPhrase ?? data.body);
        }
        return PlexError(data.statusCode, data.body);
      }
    } catch (e) {
      if (e is SocketException) {
        return _connectionFailed;
      }
      if (kDebugMode) print("Error: ${e.toString()}");
      return PlexError(400, e.toString());
    }
  }

  Future<PlexApiResponse> put(String url, {Map<String, dynamic>? query, Map<String, String>? headers, Map<String, dynamic>? formData, dynamic body}) async {
    if (await isNetworkAvailable() == false) {
      return _noNetwork;
    }

    if (query?.isNotEmpty == true) {
      url += "?";
      query?.forEach((key, value) {
        url += "$key=$value&";
      });
      url = url.substring(0, url.length - 1);
    }

    var currentHeaders = <String, String>{};

    if (addHeaders != null) {
      var constHeaders = await addHeaders!.call();
      currentHeaders.addAll(constHeaders);
    }

    if (headers != null) {
      currentHeaders.addAll(headers);
    }

    if (formData == null && !currentHeaders.containsKey("Content-Type")) {
      currentHeaders["Content-Type"] = "application/json";
    }

    try {
      var startTime = DateTime.now();
      var uri = Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url);
      if (kDebugMode) print("Started: ${uri.toString()}");

      late http.Response data;
      if (formData != null) {
        data = await http.put(uri, headers: currentHeaders, body: formData);
      } else if (body != null) {
        data = await http.put(uri, headers: currentHeaders, body: jsonEncode(body));
      } else {
        data = await http.put(uri, headers: currentHeaders, body: null);
      }

      var diffInMillis = DateTime.now().difference(startTime).inMilliseconds;
      if (kDebugMode) print("Completed: ${data.statusCode}: ${uri.toString()} in ${diffInMillis}ms");
      if (data.statusCode == 200) {
        return PlexSuccess(data.body);
      } else {
        if (data.body.isEmpty) {
          return PlexError(data.statusCode, data.reasonPhrase ?? data.body);
        }
        return PlexError(data.statusCode, data.body);
      }
    } catch (e) {
      if (e is SocketException) {
        return _connectionFailed;
      }
      if (kDebugMode) print("Error: ${e.toString()}");
      return PlexError(400, e.toString());
    }
  }

  Future<PlexApiResponse> postMultipart(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    required Map<String, String> formData,
    required Map<String, File> files,
  }) async {
    if (await isNetworkAvailable() == false) {
      return _noNetwork;
    }

    if (query?.isNotEmpty == true) {
      url += "?";
      query?.forEach((key, value) {
        url += "${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}&";
      });
      url = url.substring(0, url.length - 1);
    }

    var currentHeaders = <String, String>{};

    if (addHeaders != null) {
      var constHeaders = await addHeaders!.call();
      currentHeaders.addAll(constHeaders);
    }

    if (headers != null) {
      currentHeaders.addAll(headers);
    }

    if (!currentHeaders.containsKey("Content-Type")) {
      currentHeaders["Content-Type"] = "application/json";
    }

    try {
      var startTime = DateTime.now();
      var uri = Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url);
      if (kDebugMode) print("Started: ${uri.toString()}");

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

      var data = await request.send();

      var diffInMillis = DateTime.now().difference(startTime).inMilliseconds;
      if (kDebugMode) print("Completed: ${data.statusCode}: ${uri.toString()} in ${diffInMillis}ms");
      if (data.statusCode == 200) {
        var responseBody = await data.stream.transform(utf8.decoder).join();
        return PlexSuccess(responseBody);
      } else {
        var responseBody = await data.stream.transform(utf8.decoder).join();
        if (responseBody.isEmpty) {
          return PlexError(data.statusCode, data.reasonPhrase ?? responseBody);
        }
        return PlexError(data.statusCode, responseBody);
      }
    } catch (e) {
      if (e is SocketException) {
        return _connectionFailed;
      }
      if (kDebugMode) print("Error: ${e.toString()}");
      return PlexError(400, e.toString());
    }
  }

  Future<PlexApiResponse> postMultipart2(
      String url, {
        Map<String, dynamic>? query,
        Map<String, String>? headers,
        required Map<String, String> formData,
        required Map<String, File> files,
      }) async {
    if (await isNetworkAvailable() == false) {
      return _noNetwork;
    }

    /// Construct query parameters if present
    if (query?.isNotEmpty == true) {
      url += "?${query!.entries.map((e) => "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}").join("&")}";
    }

    /// Prepare headers
    var currentHeaders = <String, String>{};

    if (addHeaders != null) {
      var constHeaders = await addHeaders!.call();
      currentHeaders.addAll(constHeaders);
    }

    if (headers != null) {
      currentHeaders.addAll(headers);
    }

    // ✅ Do not manually set Content-Type for multipart requests
    if (kDebugMode) print("Headers: $currentHeaders");

    try {
      var uri = Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url);
      if (kDebugMode) print("Started: ${uri.toString()}");

      /// Prepare Multipart Request
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(currentHeaders);
      request.fields.addAll(formData);

      /// Attach Files
      for (var entry in files.entries) {
        var multipartFile = await http.MultipartFile.fromPath(entry.key, entry.value.path);
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();


      var responseBody = await streamedResponse.stream.transform(utf8.decoder).join();

      if (kDebugMode) print("Completed: ${streamedResponse.statusCode}: ${responseBody.toString()}");

      /// Handle JSON & Text Responses Correctly
      if (streamedResponse.statusCode == 200) {
        try {
          return PlexSuccess(responseBody); ///  Return JSON if valid
        } catch (e) {
          return PlexSuccess(responseBody); ///  Otherwise, return as plain text
        }
      } else {
        return PlexError(
          streamedResponse.statusCode,
          responseBody.isEmpty ? streamedResponse.reasonPhrase ?? "Unknown error" : responseBody,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return _connectionFailed;
      }
      if (kDebugMode) print("Error: ${e.toString()}");
      return PlexError(400, e.toString());
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
      return _noNetwork;
    }

    var httpClient = http.Client();
    var request = http.Request('GET', Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url));
    var response = httpClient.send(request);
    String dir = (await getApplicationDocumentsDirectory()).path;

    List<List<int>> chunks = List.empty(growable: true);
    int downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen(cancelOnError: true, (List<int> chunk) {
        debugPrint('downloadPercentage: ${r.contentLength != null ? (downloaded / r.contentLength! * 100) : downloaded}');
        onProgressUpdate(downloaded, r.contentLength != null ? (downloaded / r.contentLength! * 100) : null, null);
        chunks.add(chunk);
        downloaded += chunk.length;
      }, onDone: () async {
        debugPrint('downloadPercentage: ${r.contentLength != null ? (downloaded / r.contentLength! * 100) : downloaded}');
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
