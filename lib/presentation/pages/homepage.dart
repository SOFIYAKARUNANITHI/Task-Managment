import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../controllers/datafetchcontroller.dart';

import 'package:intl/intl.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  DataFetchController datasourcecontroller = Get.put(DataFetchController());
  final String routeName = '/profile';
  final fireStore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> taskModel = [];
  final user = FirebaseAuth.instance.currentUser;

  final titletext = TextEditingController();
  final desctext = TextEditingController();
  final deadlinetext = TextEditingController();
  final durationtext = TextEditingController();

  Timestamp deadlinetextformatted = Timestamp.now();
  Timestamp durationtextformatted = Timestamp.now();

  final tasktypetext = TextEditingController();
  var status = '';
  String navigationActionId = 'id_3';

  Color blueAccent = Color(0xFF2661FA);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                bottomsheet('NEW TASK', 'CREATE', taskModel, 0);
              },
              icon: Icon(Icons.add_alarm_rounded, color: blueAccent))
        ],
        backgroundColor: Colors.yellow,
        title: Text(
          user != null ? "${user!.displayName}'s Tasks" ?? '' : '',
          style: TextStyle(color: blueAccent),
        ),
      ),
      backgroundColor: Colors.white,
      body: taskModel.isEmpty
          ? Center(
              child: Text(
                'Create New Tasks',
                style: TextStyle(color: blueAccent),
              ),
            )
          : Container(
              margin: const EdgeInsets.all(10.0),
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 200),
                itemCount: taskModel.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(211, 6, 190, 182),
                          Color.fromARGB(210, 19, 137, 153),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListTile(
                          leading: SizedBox(
                              height: 100.0,
                              width: 70.0, // fixed width and height
                              child: Image.asset('assets/images/todo.png')),

                          contentPadding: const EdgeInsets.all(10),
                          // tileColor: const Color.fromARGB(255, 255, 178, 11),
                          title: Text(
                            taskModel[index]['taskName'],
                            style: const TextStyle(
                                fontFamily: 'times new roman',
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            taskModel[index]['taskDesc'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: 'roboto',
                                fontSize: 15,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Column(
                            children: [
                              GradientText(
                                gradientDirection: GradientDirection.btt,
                                'Dead-Line',
                                style: const TextStyle(
                                  fontSize: 10.0,
                                ),
                                colors: const [
                                  Colors.transparent,
                                  Colors.black,
                                ],
                              ),
                              Text(
                                formatTimestampDeadline(
                                    taskModel[index]['taskDeadline']),
                                style: TextStyle(
                                    fontSize: 30.0, color: Colors.white),
                              ),
                            ],
                          ),
                          //isThreeLine: true,
                        ),
                        Container(
                            padding: const EdgeInsets.only(left: 20, top: 0),
                            child: Row(
                              children: [
                                const Text(
                                  'Task Created ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                const Text(
                                  ':',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                Text(
                                  formatTimestamp(taskModel[index]['taskTime']),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.26,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Are you sure?'),
                                          content: const Text(
                                              'This action will permanently delete this data'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                taskModel.removeAt(index);
                                                updatesave(taskModel);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.delete_outline),
                                    color: Color.fromARGB(255, 255, 63, 49),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                const Text(
                                  'Expected Task Duration',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                const Text(
                                  ':',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                Text(
                                  formatTimestamp(taskModel[index]['taskExp']),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: taskModel[index]['taskStatus']
                                              .toString()
                                              .toLowerCase()
                                              .contains('completed')
                                          ? Colors.red
                                          : Colors.lightGreen,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    child: Text(taskModel[index]['taskStatus']),
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurple,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    child: Text(taskModel[index]['taskTag']),
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 5,
                              ),
                              Checkbox(
                                checkColor:
                                    const Color.fromARGB(255, 0, 207, 107),
                                value: taskModel[index]['taskStatus']
                                        .toString()
                                        .toLowerCase()
                                        .contains('completed')
                                    ? true
                                    : false,
                                fillColor:
                                    MaterialStateProperty.all(Colors.white),
                                onChanged: (bool? value) {
                                  if (value != false) {
                                    taskModel[index]['taskStatus'] =
                                        'Completed';
                                    updatesave(taskModel);
                                  }
                                  setState(() {});
                                },
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color.fromARGB(211, 6, 190, 182),
                                      Color.fromARGB(210, 3, 75, 85),
                                    ],
                                  ),
                                ),
                                height: 25,
                                child: OutlinedButton(
                                  onPressed: () {
                                    bottomsheet(
                                        'MODIFY', 'UPDATE', taskModel, index);
                                  },
                                  style: ButtonStyle(
                                    side: const MaterialStatePropertyAll(
                                      BorderSide(
                                          width: 1.0, color: Colors.white),
                                    ),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0))),
                                  ),
                                  child: const Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    var format = DateFormat('dd-MMM-yyyy HH:mm'); // <- use skeleton here
    return format.format(timestamp.toDate());
  }

  String formatTimestampDeadline(Timestamp timestamp) {
    var format = DateFormat('dd-MMM'); // <- use skeleton here
    return format.format(timestamp.toDate());
  }

  void bottomsheet(String title, String btntext,
      List<Map<String, dynamic>> taskdatamodel, index) {
    var taskmodel =
        taskdatamodel.isEmpty ? <String, dynamic>{} : taskdatamodel[index];

    String dropdownValue = '';
    const List<String> list = <String>[
      'Created',
      'Cancelled',
      'OnHold',
      'Completed'
    ];
    if (btntext.toLowerCase() != 'update') {
      dropdownValue = list.first;
      titletext.text = '';
      durationtext.text = '';
      deadlinetext.text = '';
      tasktypetext.text = '';
      desctext.text = '';
      tasktypetext.text = '';
    } else {
      dropdownValue = taskmodel['taskStatus'];
      titletext.text = taskmodel['taskName'];
      desctext.text = taskmodel['taskDesc'];
      durationtext.text = formatTimestamp(taskmodel['taskExp']);
      deadlinetext.text = formatTimestamp(taskmodel['taskDeadline']);
      durationtextformatted = taskmodel['taskExp'];
      deadlinetextformatted = taskmodel['taskDeadline'];

      tasktypetext.text = taskmodel['taskTag'];
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          Size size = MediaQuery.of(context).size;
          return AlertDialog(
            elevation: 2,
            backgroundColor: Colors.yellow,
            scrollable: true,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: blueAccent,
                                fontSize: 24),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            style: TextStyle(color: blueAccent),
                            controller: titletext,
                            decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueAccent),
                                fillColor: blueAccent,
                                labelText: "Title"),
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            style: TextStyle(color: blueAccent),
                            controller: desctext,
                            decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueAccent),
                                fillColor: blueAccent,
                                labelText: "Description"),
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            style: TextStyle(color: blueAccent),
                            controller: tasktypetext,
                            decoration: InputDecoration(
                                labelStyle: TextStyle(color: blueAccent),
                                fillColor: blueAccent,
                                labelText: "Task Type"),
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            style: TextStyle(color: blueAccent),
                            controller: deadlinetext,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: blueAccent),
                              labelText: "Dead-Line",
                              suffixIcon: const Icon(Icons.calendar_month),
                            ),
                            readOnly: true,
                            onTap: () async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1960),
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((selectedTime) {
                                  // Handle the selected date and time here.
                                  if (selectedTime != null) {
                                    DateTime selectedDateTime = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                    );
                                    print(
                                        selectedDateTime); // You can use the selectedDateTime as needed.
                                    setState(
                                      () {
                                        deadlinetext.text = formatTimestamp(
                                            Timestamp.fromDate(
                                                selectedDateTime));
                                        deadlinetextformatted =
                                            Timestamp.fromDate(
                                                selectedDateTime);
                                      },
                                    );
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            style: TextStyle(color: blueAccent),
                            controller: durationtext,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: blueAccent),
                              labelText: "Expected Duration",
                              suffixIcon: Icon(Icons.calendar_month),
                            ),
                            readOnly: true,
                            onTap: () async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1960),
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((selectedTime) {
                                  // Handle the selected date and time here.
                                  if (selectedTime != null) {
                                    DateTime selectedDateTime = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                    );
                                    print(
                                        selectedDateTime); // You can use the selectedDateTime as needed.
                                    setState(
                                      () {
                                        durationtext.text = formatTimestamp(
                                            Timestamp.fromDate(
                                                selectedDateTime));
                                        durationtextformatted =
                                            Timestamp.fromDate(
                                                selectedDateTime);
                                      },
                                    );
                                  }
                                });
                                //print(date);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Status',
                                    style: TextStyle(color: blueAccent)),
                                DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: Icon(
                                    Icons.arrow_downward,
                                    color: blueAccent,
                                  ),
                                  elevation: 16,
                                  dropdownColor: Colors.amberAccent,
                                  style: TextStyle(color: blueAccent),
                                  underline: Container(
                                    height: 2,
                                    color: blueAccent,
                                  ),
                                  onChanged: (String? value) {
                                    setState(
                                      () {
                                        dropdownValue = value!;
                                        status = value!;
                                      },
                                    );
                                  },
                                  items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            )),
                        SizedBox(height: size.height * 0.02),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: MaterialButton(
                            onPressed: () {
                              if (btntext.toLowerCase() != 'update') {
                                taskdatamodel.add({
                                  'taskStatus': dropdownValue,
                                  'taskName': titletext.text,
                                  'taskDesc': desctext.text,
                                  'taskExp': durationtextformatted,
                                  'taskDeadline': deadlinetextformatted,
                                  'taskTag': tasktypetext.text,
                                  'taskTime': Timestamp.now()
                                });
                              } else {
                                taskmodel['taskStatus'] = dropdownValue;
                                taskmodel['taskName'] = titletext.text;
                                taskmodel['taskDesc'] = desctext.text;
                                taskmodel['taskExp'] = durationtextformatted;
                                taskmodel['taskDeadline'] =
                                    deadlinetextformatted;
                                taskmodel['taskTag'] = tasktypetext.text;

                                taskdatamodel[index] = taskmodel;
                              }

                              updatesave(taskdatamodel);

                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0),
                            child: Container(
                              alignment: Alignment.center,
                              height: 50.0,
                              width: size.width * 0.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80.0),
                                  gradient: const LinearGradient(colors: [
                                    Color.fromARGB(255, 255, 136, 34),
                                    Color.fromARGB(255, 255, 177, 41)
                                  ])),
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                btntext,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }

  void updatesave(taskdatamodel) async {
    await fireStore
        .collection('Taskss')
        .doc(user!.uid)
        .update({'Tasklist': taskdatamodel});
    initload();
    setState(() {});
  }

  Future<void> scheduledNotification(Map<String, dynamic> taskdata) async {
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    Timestamp scheduledate = taskdata['taskDeadline'];
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.fromMillisecondsSinceEpoch(
                tz.local, scheduledate.millisecondsSinceEpoch)
            .subtract(const Duration(minutes: 10)),
        const NotificationDetails(
          android: AndroidNotificationDetails('Channel 1', 'Task Mangangment',
              channelDescription: 'Task Managment and scheduled notify',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void initload() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    final StreamController<String?> selectNotificationStream =
        StreamController<String?>.broadcast();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    await _cancelAllNotifications();
    taskModel = [];
    await fireStore.collection('Taskss').doc(user!.uid).get().then((value) {
      value['Tasklist'].forEach((element) {
        taskModel.add(element);
        scheduledNotification(element);
        print(element);
      });
    });
    setState(() {});
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
