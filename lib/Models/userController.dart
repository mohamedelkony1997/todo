import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/views/HomeView.dart';
import 'User.dart';

class UserController {
  static const String baseUrl =
      'https://phpstack-561490-3524079.cloudwaysapps.com/api-start-point/public/api/auth/login';

  Future<void> login(User user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        "email": user.email,
        "password": user.password,
      },
    );

  

    if (response.statusCode == 302) {
      Fluttertoast.showToast(
          msg: "An error occurred. Please try again later.'",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      final redirectUrl = response.headers['location'];

      final redirectResponse = await http.post(
        Uri.parse(redirectUrl!),
        body: {
          "email": user.email,
          "password": user.password,
        },
      );
    } else if (response.statusCode == 200) {
      var extractedlogin = json.decode(response.body);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("token", extractedlogin["data"]["token"]);
      Get.to(HomeView());
    } else if (response.statusCode == 400) {
      var extractedlogin = json.decode(response.body);
      Fluttertoast.showToast(
          msg: "${extractedlogin["message"]}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    
    } else {
      Fluttertoast.showToast(
          msg: "An error occurred. Please try again later.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> refreshToken() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    final response = await http.post(
      Uri.parse(
          'https://phpstack-561490-3524079.cloudwaysapps.com/api-start-point/public/api/auth/refresh-token'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    var extractedToken = json.decode(response.body);

    if (response.statusCode == 200) {
      preferences.setString('token', extractedToken['data']['token']);
    } else {
      Fluttertoast.showToast(
          msg: "An error occurred. Please try again later.'",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
