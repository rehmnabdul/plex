import 'dart:convert';
import 'dart:io';

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
    response = jsonDecode(body!);
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
  allowBadCertificateForHTTPS() {
    HttpOverrides.global = AppHttpOverrides();
  }

  ///Override this callback to always attach headers in the request i.e. UserId, AuthToken etc.
  Future<Map<String, String>> Function()? addHeaders;

  _isValidUrl(String url) {
    try{
      return Uri.parse(url).scheme.length > 0;
    } catch(e){
      return false;
    }
  }

  Future<PlexApiResponse> get(String url, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    if (query != null && query.isNotEmpty) {
      url += "?";
      query.forEach((key, value) {
        url += "$key=$value&";
      });
      url = url.substring(0, url.length - 1);
    }

    headers ??= <String, String>{};
    headers["Content-Type"] = "application/json";
    if (addHeaders != null) {
      var constHeaders = await addHeaders!.call();
      headers.addAll(constHeaders);
    }

    try {
      var uri = Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url);
      if (kDebugMode) print("Started: ${uri.toString()}");
      var data = await http.get(uri, headers: headers);
      if (kDebugMode) print("Completed: ${data.statusCode}: ${uri.toString()}");
      if (data.statusCode == 200) {
        return PlexSuccess(data.body);
      } else {
        if (data.body.isEmpty) {
          return PlexError(data.statusCode, data.reasonPhrase ?? data.body);
        }
        return PlexError(data.statusCode, data.body);
      }
    } catch (e) {
      return PlexError(400, e.toString());
    }
  }

  Future<PlexApiResponse> post(String url, {Map<String, dynamic>? query, Map<String, String>? headers, Map<String, dynamic>? formData, dynamic body}) async {
    if (query?.isNotEmpty == true) {
      url += "?";
      query?.forEach((key, value) {
        url += "$key=$value&";
      });
      url = url.substring(0, url.length - 1);
    }

    headers ??= <String, String>{};
    if (formData == null) {
      headers["Content-Type"] = "application/json";
    }
    if (addHeaders != null) {
      var constHeaders = await addHeaders!.call();
      headers.addAll(constHeaders);
    }

    try {
      var uri = Uri.parse(_isValidUrl(url) ? url : _apiUrl() + url);
      if (kDebugMode) print("Started: ${uri.toString()}");

      late http.Response data;
      if (formData != null) {
        data = await http.post(uri, headers: headers, body: formData);
      } else if (body != null) {
        data = await http.post(uri, headers: headers, body: jsonEncode(body));
      } else {
        data = await http.post(uri, headers: headers, body: null);
      }

      if (kDebugMode) print("Completed: ${data.statusCode}: ${uri.toString()}");
      if (data.statusCode == 200) {
        return PlexSuccess(data.body);
      } else {
        if (data.body.isEmpty) {
          return PlexError(data.statusCode, data.reasonPhrase ?? data.body);
        }
        return PlexError(data.statusCode, data.body);
      }
    } catch (e) {
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
