import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import 'drawer.dart';

class HomeView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      endDrawer: ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20), topLeft: Radius.circular(20)),child: MySideMenu()),
      floatingActionButton: CircleAvatar(
        child: IconButton(
          icon: Icon(Icons.add, size: 35, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState!.openEndDrawer();
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
                IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height / 1.35,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    List<String> hexColors = [
                      "#ff008d",
                      "#0dc4f4",
                      "#cf28a9",
                      "#3d457f",
                      "#00cf1c",
                      "#ffee00"
                    ];

                    Color color = Color(int.parse(
                            hexColors[index % hexColors.length].substring(1, 7),
                            radix: 16) +
                        0xFF000000);

                    return Card(
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
                            "Shopping list, food for the week ...",
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
                                "18/12",
                                style: GoogleFonts.cairo(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "10:00",
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
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
