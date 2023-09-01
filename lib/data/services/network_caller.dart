import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/services/auth_utility.dart';
import 'package:flutter_pdf_library/data/services/network_response.dart';
import 'package:http/http.dart';



class NetworkCaller {

  // Future<NetworkResponse> getRequest(String url) async {
  //   try {
  //     Response response = await get(Uri.parse(url),
  //         headers: {'token': AuthUtility.userInfo.accessToken.toString()});
  //     log(response.statusCode.toString());
  //     log(response.body);
  //     if (response.statusCode == 200) {
  //       return NetworkResponse(
  //           true, response.statusCode, jsonDecode(response.body));
  //     } else if (response.statusCode == 401) {
  //       print("error login");
  //     } else {
  //       return NetworkResponse(false, response.statusCode, null);
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   return NetworkResponse(false, -1, null);
  // }

  Future<NetworkResponse> postRequest(String url, Map<String, dynamic> body,
      {bool isLogin = false}) async {
    try {
      Response response = await post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'token': AuthUtility.userInfo.accessToken.toString()
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




  // Future<void> gotoLogin() async {
  //   await AuthUtility.clearUserInfo();
  //   Navigator.pushAndRemoveUntil(
  //       TaskManagerApp.globalKey.currentContext!,
  //       MaterialPageRoute(builder: (context) => const LoginScreen()),
  //           (route) => false);
  // }
}
