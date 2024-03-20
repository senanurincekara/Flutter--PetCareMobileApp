import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/button.dart';
import 'package:flutter_application_2/screens/input_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  get task => null;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a")
      .format(DateTime.now().add(const Duration(minutes: 2)))
      .toString();
  String _endTime = DateFormat("hh:mm a")
      .format(DateTime.now().add(const Duration(minutes: 10)))
      .toString();

  int _selectedRemind = 0;
  List<int> remindList = [0, 5, 10, 15, 20, 25, 30];

  String _selectedRepeat = "Hiç";
  List<String> repeatList = ["Hiç", "Günlük", "Haftalık", "Her Ay"];
  List<String> addedNotes = []; // Yeni eklenecek notları tutmak için liste

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "HATIRLATICI EKLE",
                style: GoogleFonts.balsamiqSans(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700]),
              ),
              MyInputField(
                  title: "BAŞLIK",
                  hint: "Başlık giriniz ",
                  controller: _titleController),
              MyInputField(
                title: "NOT ",
                hint: "Notunuzu giriniz ",
                controller: _noteController,
              ),
              MyInputField(
                  title: "TARİH",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    icon: Icon(Icons.calendar_today_outlined),
                    onPressed: () {
                      _getDateFromUser();
                    },
                  )),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Başlangıç Zamanı",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () => {
                          _getTimeFromUser(isStartTime: true),
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: MyInputField(
                      title: "Bitiş Zamanı",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () => {
                          _getTimeFromUser(isStartTime: false),
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: "Hatırlat ",
                hint: "$_selectedRemind dakika erken",
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.blueGrey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  padding: const EdgeInsets.only(right: 5),
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(
                        "$value dakika erken",
                      ),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: "Tekrar Et",
                hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  padding: const EdgeInsets.only(right: 5),
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyButton(
                    label: "Ekle",
                    onTap: () => _validateData(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData() async {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      // Eklenen notları listeye ekle
      String addedNote = "${_titleController.text} - ${_noteController.text}";

      // Save to Firestore
      await _firestore.collection('hatirlatici').add({
        'datetime': DateFormat.yMd().format(_selectedDate),
        'startime': _startTime,
        'endtime': _endTime,
        'hatirlat': '$_selectedRemind',
        'tekrar': _selectedRepeat,
        'title': _titleController.text,
        'note': _noteController.text,
      });

      // You can still keep the local list if needed
      setState(() {
        addedNotes.add(addedNote);
      });

      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Gerekli",
        "Lütfen boş alan bırakmayınız !",
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 35,
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        colorText: Colors.red,
      );
    }
  }

  _saveToTxtFile() async {
    try {
      String data =
          "${_titleController.text},${_noteController.text},${DateFormat.yMd().format(_selectedDate)},"
          "$_startTime,$_endTime,$_selectedRemind,$_selectedRepeat";

      Directory? directory = await getExternalStorageDirectory();

      if (directory != null) {
        final File file = File('${directory.path}/hatirlatici.txt');
        await file.writeAsString('$data\n', mode: FileMode.append);

        print("Data saved to file successfully");
        print("File path: ${file.path}");
      } else {
        print("Error: External storage directory is null");
      }
    } catch (e, stackTrace) {
      print("Error saving to file: $e");
      print("Stack Trace: $stackTrace");
    }
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 4)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 8)),
    );
    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
        print(_selectedDate);
      });
    } else {
      Get.snackbar(
        "Error Occured!",
        "Date is not selected",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickTime = await _showTimePicker();

    if (pickTime != null) {
      // ignore: use_build_context_synchronously
      String formatedTime = pickTime.format(context);

      setState(() {
        if (isStartTime) {
          _startTime = formatedTime;
        } else {
          _endTime = formatedTime;
        }
      });
    } else {
      Get.snackbar(
        "Error Occured!",
        "Time is not selected",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
