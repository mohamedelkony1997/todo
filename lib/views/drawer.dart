import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:todo/main.dart';
import 'package:uuid/uuid.dart';
import '../Models/HomeController.dart';
import '../Models/TaskModel.dart';

// ignore: must_be_immutable
class MySideMenu extends StatefulWidget {
  String id;
  String title;
  int color;
  int index;
  String descrip;
  String date;
  String time;

  MySideMenu(
      {Key? key,
      required this.color,
      required this.id,
      required this.index,
      required this.time,
      required this.date,
      required this.descrip,
      required this.title})
      : super(key: key);
  @override
  State<MySideMenu> createState() => _MySideMenuState();
}

class _MySideMenuState extends State<MySideMenu> {
  final TaskController taskController = Get.put(TaskController());
  final _formKey2 = GlobalKey<FormState>();
  TextEditingController taskName = TextEditingController();

  TextEditingController dateinput = TextEditingController();
  TextEditingController Timeinputfrom = TextEditingController();
  TextEditingController description = TextEditingController();
  DateTime? _dateTime = DateTime.now();
  List<Task> tasks = [];
  int? selectcolor;

  TimeOfDay? _selectedTime;

  @override
  void initState() {
    taskName.text = (!updateMode) ? taskName.text : widget.title;
    dateinput.text = (!updateMode) ? dateinput.text : widget.date;
    Timeinputfrom.text = (!updateMode) ? Timeinputfrom.text : widget.time;
    description.text = (!updateMode) ? description.text : widget.descrip;
    selectcolor = (!updateMode) ? selectcolor : widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.index);
    return Drawer(
      backgroundColor: Color(0xfff8fbfe),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Form(
          key: _formKey2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (!updateMode) ? 'New Task' : 'Update Task',
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
                height: 80,
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
                    bool isSelected = selectcolor == color.value;
                    return Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: IconButton(
                        icon: Icon(
                          Icons.circle,
                          color: color,
                          size: isSelected ? 60 : 40,
                        ),
                        onPressed: () {
                          setState(() {
                            selectcolor = color.value;
                          });
                        },
                      ),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                  decoration: new InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffabb0ee), width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xfffb9ed3), width: 2),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                    maxLines: 5,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xffe1e2ea)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter date';
                    }
                    return null;
                  },
                  style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffabb0ee), width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xfffb9ed3), width: 2),
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
                          dateinput.text = formattedDate;
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter time';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.access_alarm,
                      color: Color(0XFF0dc4f4),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffabb0ee), width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xfffb9ed3), width: 2),
                    ),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              (!updateMode)
                  ? Padding(
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            minimumSize:
                                MaterialStateProperty.all(Size(150, 50)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () {
                            if (_formKey2.currentState!.validate()) {
                              taskController.addTask(Task(
                                  id: Uuid().v4(),
                                  color: selectcolor,
                                  description: description.text,
                                  title: taskName.text,
                                  date: dateinput.text,
                                  time: Timeinputfrom.text));

                              Navigator.of(context).pop();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text(
                              "Add",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                  blurRadius: 5.0)
                            ],
                            color: Color(0xffe30000),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              minimumSize:
                                  MaterialStateProperty.all(Size(100, 50)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () {
                              taskController.deleteTask(
                                  Task(
                                      title: widget.title,
                                      color: widget.color,
                                      id: widget.id,
                                      time: widget.time,
                                      date: widget.date,
                                      description: widget.descrip),
                                  widget.index);
                              print("widget.id");
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
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
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              minimumSize:
                                  MaterialStateProperty.all(Size(120, 50)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () {
                              if (_formKey2.currentState!.validate()) {
                                taskController.updateTask(Task(
                                    title: taskName.text,
                                    color: selectcolor,
                                    id: widget.id,
                                    time: Timeinputfrom.text,
                                    date: dateinput.text,
                                    description: description.text));
                                Navigator.of(context).pop();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                "Update",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
