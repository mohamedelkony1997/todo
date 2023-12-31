import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/Models/TaskModel.dart';
import 'package:todo/translation/myLocal.dart';
import 'package:todo/views/HomeView.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/views/LoginView.dart';
import 'Models/HomeController.dart';
import 'Models/userController.dart';
import 'notification/NotificationService.dart';

import 'package:permission_handler/permission_handler.dart';

bool updateMode = false;
final TaskController taskController = Get.put(TaskController());
final UserController _userController = Get.put(UserController());

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(TaskAdapter());
  Noti.initialize(flutterLocalNotificationsPlugin);
 await _userController.refreshToken();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: hasToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            builder: (context, child) => ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, child!),
              maxWidth: 1200,
              minWidth: 450,
              defaultScale: true,
              breakpoints: [
                const ResponsiveBreakpoint.resize(450, name: MOBILE),
                const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ],
            ),
            debugShowCheckedModeBanner: false,
            locale: Get.deviceLocale,
            translations: myLocal(),
            initialRoute: snapshot.data == true ? '/home' : '/login',
            defaultTransition: Transition.fadeIn,
            getPages: [
              GetPage(name: '/login', page: () => LoginView()),
              GetPage(name: '/home', page: () => HomeView()),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

Future<bool> hasToken() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getString('token') != null;
}
