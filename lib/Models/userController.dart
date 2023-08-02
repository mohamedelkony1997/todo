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
    print(response.statusCode);
     var extractedlogin = json.decode(response.body);
    if (response.statusCode == 200) {
      Get.to(HomeView());
      var extractedlogin = json.decode(response.body);
      print(extractedlogin);
      Fluttertoast.showToast(
          msg: "${extractedlogin["message"]}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("token", extractedlogin["data"]["token"]);

      print(extractedlogin["data"]["token"]);
    }
    else if (response.statusCode == 400 ) {
      Fluttertoast.showToast(
          msg: "${extractedlogin["message"]}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print('Login failed: ${extractedlogin["message"]}');
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
    print(response.statusCode);
    var extractedToken = json.decode(response.body);
    print(extractedToken);
    if (response.statusCode == 200) {
      preferences.setString('token', extractedToken['data']['token']);
      print('Token refreshed: ${extractedToken['data']['token']}');
    } else {
      print('Token refresh failed');
    }
  }
}
