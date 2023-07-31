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

    var extractedlogin = json.decode(response.body);
    print(extractedlogin);
    if (response.statusCode == 200) {
      Get.to(HomeView());

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
        
      print( extractedlogin["data"]["token"]);
    } else {
      Fluttertoast.showToast(
          msg: "${extractedlogin["message"]}",
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
