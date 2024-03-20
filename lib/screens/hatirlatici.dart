import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/pets.dart';
import 'package:flutter_application_2/screens/add_task_bar.dart';
import 'package:flutter_application_2/screens/button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

class Hatirlatici extends StatefulWidget {
  final Pet pet;

  const Hatirlatici({Key? key, required this.pet}) : super(key: key);

  @override
  State<Hatirlatici> createState() => _HatirlaticiState();
}

class _HatirlaticiState extends State<Hatirlatici> {
  DateTime _selectedDate = DateTime.now();
  List<String> reminderList = [];
  CollectionReference hatirlaticiCollection =
      FirebaseFirestore.instance.collection('hatirlatici');

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await hatirlaticiCollection.get();
      List<String> tempList = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Combine "starttime" and "endtime" to get the full time range
        String timeRange = "${data['startime']} - ${data['endtime']}";

        String reminder = "${data['title']} - ${data['note']} - $timeRange";
        tempList.add(reminder);
      }

      setState(() {
        reminderList = tempList;
      });
    } catch (e) {
      print("Firestore veri çekme hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat("EEE, d MMM yyyy").format(DateTime.now()),
                          style: GoogleFonts.balsamiqSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Bugün",
                          style: GoogleFonts.balsamiqSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyButton(
                    label: "+Hatırlatıcı ekle",
                    onTap: () async {
                      await Get.to(() => const AddTaskPage());
                    },
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      child: DatePicker(
                        DateTime.now(),
                        initialSelectedDate: DateTime.now(),
                        selectionColor: Colors.lightGreen,
                        selectedTextColor: Colors.white,
                        dateTextStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        onDateChange: (date) {
                          _selectedDate = date;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (String reminder in reminderList)
                    Container(
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.yellow, // Set the background color here
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 5, 109, 95),
                            offset: Offset(4.0, 4.0),
                            blurRadius: 5.0,
                            spreadRadius: 0.2,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reminder.split(" - ")[0],
                            style: GoogleFonts.balsamiqSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _selectedDate.toString(),
                            style: GoogleFonts.balsamiqSans(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Not: ${reminder.split(" - ")[1]}",
                            style: GoogleFonts.balsamiqSans(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Saat: ${reminder.split(" - ").length > 2 ? reminder.split(" - ")[2] : 'N/A'}",
                            style: GoogleFonts.balsamiqSans(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
