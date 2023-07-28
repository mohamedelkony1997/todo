import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
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
    if (response.statusCode == 200) {
      Get.to(HomeView());
      Fluttertoast.showToast(
          msg: "Login Sucessefully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print('Login success');
    } else {
   
      Fluttertoast.showToast(
          msg: "invalid  credentials",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print('Login failed');
    }
  }
}
