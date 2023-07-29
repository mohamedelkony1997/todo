import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/TaskModel.dart';

class MySideMenu extends StatefulWidget {
  @override
  State<MySideMenu> createState() => _MySideMenuState();
}

class _MySideMenuState extends State<MySideMenu> {
  TextEditingController taskName = TextEditingController();

  TextEditingController dateinput = TextEditingController();
  TextEditingController Timeinputfrom = TextEditingController();
  TextEditingController description = TextEditingController();
  DateTime? _dateTime = DateTime.now();

  Color? selectcolor;
  List<Map<String, dynamic>> tasks = [];
  final _toDoLists = Hive.box("TODO");
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xfff8fbfe),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Task',
              style: GoogleFonts.cairo(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                'Color',
                style: GoogleFonts.cairo(
                  color: const Color.fromARGB(255, 213, 209, 209),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              width: 400,
              height: 50,
              child: ListView.builder(
                itemCount: 6,
                scrollDirection: Axis.horizontal,
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
                  return IconButton(
                    icon: Icon(
                      Icons.circle,
                      color: color,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        selectcolor = color;
                      });
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                'Name',
                style: GoogleFonts.cairo(
                  color: const Color.fromARGB(255, 213, 209, 209),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                controller: taskName,
                decoration: new InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffabb0ee), width: 2),
                      //  when the TextFormField in unfocused
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xfffb9ed3), width: 2),
                      //  when the TextFormField in focused
                    ),
                    border: UnderlineInputBorder()),
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                'Description',
                style: GoogleFonts.cairo(
                  color: const Color.fromARGB(255, 213, 209, 209),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                height: 120,
                child: TextFormField(
                  controller: description,
                  maxLines: 5,
                  style: TextStyle(fontSize: 12), // Set font size to 12
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color:
                              Color(0xffe1e2ea)), // Set border thickness to 0.5
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    // Set content padding to 8 vertical, 12 horizontal
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                'Date',
                style: GoogleFonts.cairo(
                  color: const Color.fromARGB(255, 213, 209, 209),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                showCursor: true,
                readOnly: true,
                controller: dateinput,
                style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffabb0ee), width: 2),
                    //  when the TextFormField in unfocused
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfffb9ed3), width: 2),
                    //  when the TextFormField in focused
                  ),
                  border: UnderlineInputBorder(),
                  prefixIcon: InkWell(
                    child: Icon(
                      Icons.calendar_month,
                      color: Color(0XFF0dc4f4),
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2025));
                      String formattedDate =
                          DateFormat('MM-dd-yyyy').format(_dateTime!);
                      setState(() {
                        dateinput.text =
                            formattedDate; //set output date to TextField value.  ;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                'Time',
                style: GoogleFonts.cairo(
                  color: const Color.fromARGB(255, 213, 209, 209),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextFormField(
                readOnly: true,
                onTap: () async {
                  _selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (_selectedTime != null) {
                    setState(() {
                      String formattedTime = _selectedTime!.format(context);

                      Timeinputfrom.text = formattedTime;
                    });
                  }
                },
                controller: Timeinputfrom,
                decoration: InputDecoration(
                  // ignore: prefer_const_constructors
                  prefixIcon: Icon(
                    Icons.access_alarm,
                    color: Color(0XFF0dc4f4),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffabb0ee), width: 2),
                    //  when the TextFormField in unfocused
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xfffb9ed3), width: 2),
                    //  when the TextFormField in focused
                  ),
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 5.0)
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    colors: [
                      Color(0xff254dde),
                      Color(0xff09d3f7),
                    ],
                  ),
                  color: Color(0xff00FFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(Size(150, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    // elevation: MaterialStateProperty.all(3),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createTask(Map<String, dynamic> newTask) async {
    _toDoLists.add(newTask);
  }
}
