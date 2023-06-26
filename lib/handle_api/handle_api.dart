import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../until/global.dart';

class HttpHelper {
  /// object
  static Future<Map<String, dynamic>?> invokeHttp(dynamic url, RequestType type,
      {Map<String, String>? headers, dynamic body,Encoding? encoding}) async {
    http.Response response;
    Map<String, dynamic>? responseBody;
    try {
      response = await _invoke(url, type,
          headers: getHeaders(headers),
          body: body,
          encoding: Encoding.getByName("utf-8")
      );
    } catch (error) {
      rethrow;
    }
    if (response.body.isEmpty) return null;
    responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    return responseBody;
  }

  static Future<http.Response> _invoke(dynamic url, RequestType type,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) async {
    http.Response response;

    try {
      switch (type) {
        case RequestType.get:
          response = await http.get(url, headers: headers);
          break;
        case RequestType.post:
          response = await http.post(url,
              headers: headers, body: body, encoding: encoding);
          break;
        case RequestType.put:
          response = await http.put(url,
              headers: headers, body: body, encoding: encoding);
          break;
        case RequestType.delete:
          response = await http.delete(url, headers: headers);
          break;
      }
      // check for any errors
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
      }
      return response;
    } on http.ClientException {
      // handle any 404's
      rethrow;

      // handle no internet connection
    } on SocketException catch (e) {
      throw Exception(e.osError?.message);
    } catch (error) {
      rethrow;
    }
  }

  /// upload single file
  static Future<Map<String, dynamic>?> invokeSingleFile(
      dynamic url, RequestType type, String filePaths,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) async {
    http.Response response;
    Map<String, dynamic> responseBody;

    try {
      http.MultipartFile files;

      http.MultipartFile multipartFile =
      await http.MultipartFile.fromPath('avt', filePaths);
      files = multipartFile;

      response = await _invokeSingleFile(url, type, files,
          headers: getHeadersUploadFile(headers),
          body: body,
          encoding: Encoding.getByName("utf-8"));
    } catch (error) {
      rethrow;
    }
    if (response.body.isEmpty) return null;
    responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    return responseBody;
  }

  /// Invoke the `http` request, returning the [http.Response] unparsed.
  /// upload single file
  static Future<http.Response> _invokeSingleFile(
      dynamic url, RequestType type, http.MultipartFile filePaths,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) async {
    http.Response response;

    try {
      http.MultipartRequest request =
      http.MultipartRequest(type.name.toUpperCase(), url);
      if (headers != null) {
        request.headers.addAll(headers);
      }
      request.files.add(filePaths);
      http.StreamedResponse streamedResponse = await request.send();
      response = await http.Response.fromStream(streamedResponse);

      // check for any errors
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        debugPrint("API completed: $body");
      }
      return response;
    } on http.ClientException {
      // handle any 404's
      rethrow;

      // handle no internet connection
    } on SocketException catch (e) {
      throw Exception(e.osError?.message);
    } catch (error) {
      rethrow;
    }
  }

  static Map<String, String> getHeaders(Map<String, String>? headers) {
    Map<String, String>? customizeHeaders;
    if (headers != null) {
      customizeHeaders = headers;
    } else {
      customizeHeaders = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${Global.mToken}"
      };
    }
    return customizeHeaders;
  }

  /// upload media
  static Map<String, String> getHeadersUploadFile(
      Map<String, String>? headers) {
    Map<String, String>? customizeHeaders;
    if (headers != null) {
      customizeHeaders = headers;
    } else {
      customizeHeaders = {
        "Accept": "*/*",
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer ${Global.mToken}"
      };
    }
    return customizeHeaders;
  }
}
enum RequestType {get, post, put, delete }