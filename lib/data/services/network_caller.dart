import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/models/auth_utility.dart';
import 'package:flutter_pdf_library/data/models/network_response.dart';
import 'package:flutter_pdf_library/main.dart';
import 'package:flutter_pdf_library/presentation/screens/auth/admin_login_ui/admin_login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class NetworkCaller {

  Future<NetworkResponse> getRequest(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'access_token': AuthUtility.userInfo.accessToken.toString(),
          HttpHeaders.authorizationHeader:
              'Bearer ${AuthUtility.userInfo.accessToken.toString()}',
        },
      );
      log(response.statusCode.toString());
      log(response.body);
      if (response.statusCode == 200) {
        return NetworkResponse(
          true,
          response.statusCode,
          jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        if (kDebugMode) {
          print('error login');
        }
      } else {
        return NetworkResponse(false, response.statusCode, null);
      }
    } catch (e) {
      log(e.toString());
    }
    return NetworkResponse(false, -1, null);
  }



  Future<NetworkResponse> postRequest(String url, Map<String, dynamic> body,
      {bool isLogin = false}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${AuthUtility.userInfo.accessToken.toString()}',
        },
        body: jsonEncode(body),
      );
      log(response.statusCode.toString());
      log(response.body);
      if (response.statusCode == 200) {
        return NetworkResponse(
          true,
          response.statusCode,
          jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        if (isLogin) {
          print('Login failed');
        }
      } else {
        return NetworkResponse(false, response.statusCode, null);
      }
    } catch (e) {
      log(e.toString());
    }
    return NetworkResponse(false, -1, null);
  }

  Future<NetworkResponse> uploadBookData({
    required String apiUrl,
    required String name,
    required int authorId,
    required int noOfPages,
    required int publisherId,
    required int categoryId,
    required int publishYear,
    required File imageFile,
    required File pdf,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers['Authorization'] =
          'Bearer ${AuthUtility.userInfo.accessToken.toString()}';

      // Add form fields
      request.fields['name'] = name;
      request.fields['author_id'] = authorId.toString();
      request.fields['no_of_pages'] = noOfPages.toString();
      request.fields['publisher_id'] = publisherId.toString();
      request.fields['category_id'] = categoryId.toString();
      request.fields['publish_year'] = publishYear.toString();

      // Add the image file
      final imageMimeType = lookupMimeType(imageFile.path);
      final imageStream =
          http.ByteStream.fromBytes(await imageFile.readAsBytes());
      request.files.add(http.MultipartFile(
        'image',
        imageStream,
        imageFile.lengthSync(),
        contentType: MediaType.parse(imageMimeType!),
      ));

      // Add the PDF file
      final pdfMimeType = lookupMimeType(pdf.path);
      final pdfStream = http.ByteStream.fromBytes(await pdf.readAsBytes());
      request.files.add(http.MultipartFile(
        'pdf',
        pdfStream,
        pdf.lengthSync(),
        contentType: MediaType.parse(pdfMimeType!),
      ));

      // Set authorization header

      final response = await request.send();
      final statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        final responseString = await response.stream.bytesToString();
        final responseData = json.decode(responseString);
        print('Request success with status $statusCode');
        return NetworkResponse(true, statusCode, responseData);
      } else {
        print('Request failed with status $statusCode');
        return NetworkResponse(false, statusCode, null);
      }
    } catch (e) {
      print('Error sending request: $e');
      return NetworkResponse(false, -1, null);
    }
  }

  Future<void> gotoLogin() async {
    await AuthUtility.clearUserInfo();
    Navigator.pushAndRemoveUntil(
        LibraryDashboard.globalKey.currentContext!,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }
}
