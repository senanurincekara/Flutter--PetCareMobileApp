import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime today = DateTime.now();
  String? selectedValue;
  TextEditingController weightController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();
  TextEditingController boyunController = TextEditingController();
  TextEditingController gController = TextEditingController();
  TextEditingController vucutuzunlukcontroller = TextEditingController();
  TextEditingController vucutyukseklikController = TextEditingController();
  final _selectedList = ["Az", "Normal", "Çok"];
  String? _selectedvalue = "Az";

  final _selectedList_d = ["Az", "Normal", "Çok"];
  String? _selectedvalue_d = "Az";

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      // Tarih seçildiğinde verileri otomatik olarak çek
      _fetchPetInfo();
    });
  }

  Future<void> _fetchPetInfo() async {
    if (selectedValue != null) {
      var petInfoQuery = await FirebaseFirestore.instance
          .collection("PetInfo")
          .where('Date', isEqualTo: today.toLocal().toString().split(' ')[0])
          .where('petid', isEqualTo: selectedValue)
          .get();

      if (petInfoQuery.docs.isNotEmpty) {
        var petInfoData = petInfoQuery.docs.first.data();
        weightController.text =
            petInfoData['vucutkg'].toString(); // Convert to String
        temperatureController.text = petInfoData['vucutsk'].toString();
        boyunController.text = petInfoData['b_uzunluk'].toString();
        gController.text = petInfoData['g_uzunluk'].toString();

        vucutuzunlukcontroller.text = petInfoData['v_uzunluk'].toString();

        vucutyukseklikController.text = petInfoData['v_yukseklik'].toString();

        _selectedvalue = petInfoData['i_durumu'];
        _selectedvalue_d = petInfoData['d_durumu'];
      }
    }
  }

  Future<void> _savePetInfo(String petName) async {
    // Fetch existing pet info from Firestore
    var petInfoQuery = await FirebaseFirestore.instance
        .collection("PetInfo")
        .where('Date', isEqualTo: today.toLocal().toString().split(' ')[0])
        .where('petid', isEqualTo: selectedValue)
        .get();

    // Check if a record exists for the selected pet on the given date
    if (petInfoQuery.docs.isNotEmpty) {
      // If the record exists, update the existing record
      await petInfoQuery.docs.first.reference.update({
        'b_uzunluk': boyunController.text,
        'd_durumu': _selectedvalue_d,
        'g_uzunluk': gController.text,
        'i_durumu': _selectedvalue,
        'petname': petName,
        'v_uzunluk': vucutuzunlukcontroller.text,
        'v_yukseklik': vucutyukseklikController.text,
        'vucutkg': weightController.text,
        'vucutsk': temperatureController.text,
      });
    } else {
      // If the record doesn't exist, add a new record
      await FirebaseFirestore.instance.collection("PetInfo").add({
        'Date': today.toLocal().toString().split(' ')[0],
        'b_uzunluk': boyunController.text,
        'd_durumu': _selectedvalue_d,
        'g_uzunluk': gController.text,
        'i_durumu': _selectedvalue,
        'petid': selectedValue,
        'petname': petName,
        'v_uzunluk': vucutuzunlukcontroller.text,
        'v_yukseklik': vucutyukseklikController.text,
        'vucutkg': weightController.text,
        'vucutsk': int.parse(temperatureController.text),
      });
    }

    // Kayıt yapıldıktan sonra TextField'ları temizle
    // weightController.clear();
    // temperatureController.clear();
    // boyunController.clear();
    // gController.clear();
    // vucutuzunlukcontroller.clear();
    // vucutyukseklikController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Seçilen gün --> " + today.toString().split(" ")[0]),
            Container(
              child: TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle: HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                lastDay: DateTime.utc(2030, 3, 14),
                firstDay: DateTime.utc(2010, 10, 16),
                onDaySelected: _onDaySelected,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "EVCİL HAYVANIM :",
                    style: GoogleFonts.balsamiqSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 20, 20, 20)),
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Pets")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Some error occured ${snapshot.error}"),
                        );
                      }
                      List<DropdownMenuItem> programItems = [];
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        final selectProgram =
                            snapshot.data?.docs.reversed.toList();
                        if (selectProgram != null) {
                          for (var program in selectProgram) {
                            programItems.add(
                              DropdownMenuItem(
                                value: program.id,
                                child: Text(
                                  program['name'],
                                ),
                              ),
                            );
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                DropdownButton(
                                  underline: const SizedBox(),
                                  isExpanded: true,
                                  hint: const Text(
                                    "Select the Items",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  value: selectedValue,
                                  items: programItems,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value;
                                    });
                                    // Evcil hayvan seçildiğinde verileri otomatik çek
                                    _fetchPetInfo();
                                  },
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: weightController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Vücut Ağırlığı',
                                          suffixText: 'kg',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: temperatureController,
                                        decoration: InputDecoration(
                                          labelText: 'Vücut Sıcaklığı',
                                          suffixText: '°C',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: boyunController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Boyun Çevresi Uzunluğu',
                                          suffixText: 'cm',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: gController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Göğüs Çevresi Uzunluğu',
                                          suffixText: 'cm',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: vucutuzunlukcontroller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Vücut Uzunluğu',
                                          suffixText: 'cm',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: vucutyukseklikController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Vücut Yüksekliği',
                                          suffixText: 'cm',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 13),
                                DropdownButtonFormField(
                                  value: _selectedvalue,
                                  items: _selectedList
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e),
                                            value: e,
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedvalue = val as String;
                                    });
                                  },
                                  dropdownColor: Colors.deepPurple.shade50,
                                  decoration: InputDecoration(
                                    labelText: "İdrar Durumu",
                                    labelStyle: TextStyle(
                                      fontSize: 25,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 13),
                                DropdownButtonFormField(
                                  value: _selectedvalue_d,
                                  items: _selectedList_d
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e),
                                            value: e,
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedvalue_d = val as String;
                                    });
                                  },
                                  dropdownColor: Colors.deepPurple.shade50,
                                  decoration: InputDecoration(
                                    labelText: "Dışkı Durumu",
                                    labelStyle: TextStyle(
                                      fontSize: 25,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (selectedValue != null) {
                                      _savePetInfo(
                                        snapshot.data?.docs.firstWhere(
                                          (element) =>
                                              element.id == selectedValue,
                                        )['name'],
                                      );
                                    }
                                  },
                                  child: Text("Bilgileri Kaydet"),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
