import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/Models/HomeController.dart';
import 'package:todo/Models/TaskModel.dart';
import 'package:todo/notification/NotificationService.dart';
import '../main.dart';

import 'drawer.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TaskController taskController = Get.put(TaskController());

  Map data = {
    "index": 0,
    "id": '',
    "title": '',
    "time": "",
    "date": '',
    "description": '',
    "color": 0
  };
  @override
  void initState() {
    Noti.initialize(flutterLocalNotificationsPlugin);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(DateTime.now());
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      endDrawer: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20), topLeft: Radius.circular(20)),
          child: MySideMenu(
            id: data["id"],
            index: data["index"],
            time: data['time'],
            color: data['color'],
            date: data['date'],
            descrip: data['description'],
            title: data['title'],
          )),
      floatingActionButton: CircleAvatar(
        child: IconButton(
          icon: Icon(Icons.add, size: 35, color: Colors.white),
          onPressed: () {
            Noti.showBigTextNotification(
                title: "Elkony",
                scheduledDate: DateTime.now(),
                body: "hello testnotification",
                fln: flutterLocalNotificationsPlugin);
            updateMode = false;
            (updateMode == false)
                ? _scaffoldKey.currentState!.openEndDrawer()
                : null;
          },
        ),
        maxRadius: 30,
        backgroundColor: Color(0xff1a81e8),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xfffff6f4),
              Color.fromARGB(255, 247, 225, 244),
              Color.fromARGB(255, 220, 226, 247),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Spacer(),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "TODO",
                  style: GoogleFonts.cairo(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () async {
                      taskController.logOut();
                    },
                    icon: Icon(Icons.logout)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height / 1.35,
                child: Obx(() => ListView.builder(
                      itemCount: taskController.tasks.length,
                      itemBuilder: (context, index) {
                        final task = taskController.tasks[index];
                        taskController.scheduleNotification(task);
                        Color color = Color(task.color!);
                        return InkWell(
                          onTap: () async {
                            print(task.id);
                            setState(() {
                              data['title'] = task.title;
                              data['id'] = task.id;
                              data['index'] = index;
                              data['time'] = task.time;
                              data['description'] = task.description;
                              data['color'] = task.color;
                              data['date'] = task.date;
                            });
                            updateMode = true;
                            (updateMode == true)
                                ? _scaffoldKey.currentState!.openEndDrawer()
                                : null;
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              //set border radius more than 50% of height and width to make circle
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(children: [
                                Icon(
                                  Icons.circle,
                                  color: color,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${task.title}",
                                  style: GoogleFonts.cairo(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Text(
                                      "${task.date}",
                                      style: GoogleFonts.cairo(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      "${task.time}",
                                      style: GoogleFonts.cairo(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                            ),
                          ),
                        );
                      },
                    )),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
