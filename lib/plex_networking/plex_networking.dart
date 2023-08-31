import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:plex/plex_sp.dart';

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

  String baseUrl() {
    return PlexSp.instance.getString("Url") ?? "https://10.0.62.89:8081/api/v1/";
  }

  setBaseUrl(String? url) {
    PlexSp.instance.setString("Url", url ?? "https://10.0.62.89:8081/api/v1/");
  }

  String _apiUrl() {
    return baseUrl();
  }

  late http.Client _client;

  PlexNetworking._(){
    _client = http.Client();
  }

  ///Call this method to allow bad https certificate and manually verify them.
  ///If you trust your API server and it's certificate you can override the HTTPS system check
  allowBadCertificateForHTTPS() {
    HttpOverrides.global = AppHttpOverrides();
  }

  ///Override this callback to always attach headers in the request i.e. UserId, AuthToken etc.
  Future<Map<String, String>> Function()? addHeaders;

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
      var uri = Uri.parse(_apiUrl() + url);
      if (kDebugMode) print("Started: ${uri.toString()}");
      var data = await _client.get(uri, headers: headers);
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
    if(formData == null) {
      headers["Content-Type"] = "application/json";
    }
    if (addHeaders != null) {
      var constHeaders = await addHeaders!.call();
      headers.addAll(constHeaders);
    }

    try {
      var uri = Uri.parse(_apiUrl() + url);
      if (kDebugMode) print("Started: ${uri.toString()}");

      late http.Response data;
      if(formData != null) {
        data = await _client.post(uri, headers: headers, body: formData);
      } else if (body != null) {
        data = await _client.post(uri, headers: headers, body: jsonEncode(body));
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
}
