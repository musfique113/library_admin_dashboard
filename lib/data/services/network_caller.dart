import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/models/auth_utility.dart';
import 'package:flutter_pdf_library/data/models/network_response.dart';
import 'package:flutter_pdf_library/main.dart';
import 'package:flutter_pdf_library/presentation/screens/admin_login_ui/admin_login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class NetworkCaller {
  Future<NetworkResponse> getRequest(String url) async {
    try {
      Response response = await get(Uri.parse(url),
          headers: {
        'access_token': AuthUtility.userInfo.accessToken.toString(),
            HttpHeaders.authorizationHeader: 'Bearer ${AuthUtility.userInfo.accessToken.toString()}'
      });
      log(response.statusCode.toString());
      log(response.body);
      if (response.statusCode == 200) {
        return NetworkResponse(
            true, response.statusCode, jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        print("error login");
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
      Response response = await post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          //'access_token': AuthUtility.userInfo.accessToken.toString(),
          HttpHeaders.authorizationHeader: 'Bearer ${AuthUtility.userInfo.accessToken.toString()}'

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


  //
  // Future<NetworkResponse> postMultipartRequest(
  //     String url, Map<String, dynamic> body, File pdfFile, File imageFile,
  //     {bool isLogin = false}) async {
  //   try {
  //     final request = http.MultipartRequest('POST', Uri.parse(url))
  //       ..headers.addAll({
  //         HttpHeaders.authorizationHeader:
  //         'Bearer ${AuthUtility.userInfo.accessToken.toString()}',
  //       });
  //
  //     // Add text fields to the request
  //     request.fields['name'] = body['name'];
  //     request.fields['author_id'] = body['author_id'].toString();
  //     request.fields['no_of_pages'] = body['no_of_pages'].toString();
  //     request.fields['publisher_id'] = body['publisher_id'].toString();
  //     request.fields['category_id'] = body['category_id'].toString();
  //     request.fields['publish_year'] = body['publish_year'].toString();
  //
  //     // Add the PDF file
  //     if (pdfFile != null) {
  //       request.files.add(http.MultipartFile(
  //         'pdf',
  //         pdfFile.readAsBytes().asStream(),
  //         pdfFile.lengthSync(),
  //         filename: 'your_pdf_file.pdf',
  //         contentType: MediaType('application', 'pdf'),
  //       ));
  //     }
  //
  //     // Add the image file
  //     if (imageFile != null) {
  //       request.files.add(http.MultipartFile(
  //         'image',
  //         imageFile.readAsBytes().asStream(),
  //         imageFile.lengthSync(),
  //         filename: 'your_image_file.jpg',
  //         // Change the filename and content type as needed
  //         contentType:
  //         MediaType('image', 'jpeg'), // Change the content type as needed
  //       ));
  //     }
  //
  //     final response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       final responseBody = await response.stream.bytesToString();
  //       return NetworkResponse(
  //         true,
  //         response.statusCode,
  //         jsonDecode(responseBody),
  //       );
  //     } else if (response.statusCode == 401) {
  //       if (isLogin) {
  //         print('Login failed');
  //       }
  //     } else {
  //       return NetworkResponse(false, response.statusCode, null);
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   return NetworkResponse(false, -1, null);
  // }

  Future<void> gotoLogin() async {
    await AuthUtility.clearUserInfo();
    Navigator.pushAndRemoveUntil(
        LibraryDashboard.globalKey.currentContext!,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }
}
