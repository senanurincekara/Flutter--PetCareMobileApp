// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class GraphPage extends StatefulWidget {
//   const GraphPage({super.key});

//   @override
//   State<GraphPage> createState() => _GraphPageState();
// }

// class _GraphPageState extends State<GraphPage> {
//   DateTime today = DateTime.now();
//   String? selectedValue;

//   void _onDaySelected(DateTime day, DateTime focusedDay) {
//     setState(() {
//       today = day;
//       // Tarih seçildiğinde verileri otomatik olarak çek
//       // _fetchPetInfo();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "GRAFİKLER:",
//                     style: GoogleFonts.balsamiqSans(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color.fromARGB(255, 20, 20, 20)),
//                   ),
//                   SizedBox(height: 10),
//                   StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection("Pets")
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasError) {
//                         return Center(
//                           child: Text("Some error occured ${snapshot.error}"),
//                         );
//                       }
//                       List<DropdownMenuItem> programItems = [];
//                       if (!snapshot.hasData) {
//                         return const CircularProgressIndicator();
//                       } else {
//                         final selectProgram =
//                             snapshot.data?.docs.reversed.toList();
//                         if (selectProgram != null) {
//                           for (var program in selectProgram) {
//                             programItems.add(
//                               DropdownMenuItem(
//                                 value: program.id,
//                                 child: Text(
//                                   program['name'],
//                                 ),
//                               ),
//                             );
//                           }
//                         }
//                         return Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Container(
//                             padding: const EdgeInsets.only(right: 15, left: 15),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey, width: 1),
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: Column(
//                               children: [
//                                 DropdownButton(
//                                   underline: const SizedBox(),
//                                   isExpanded: true,
//                                   hint: const Text(
//                                     "Evcil Hayvanım",
//                                     style: TextStyle(fontSize: 20),
//                                   ),
//                                   value: selectedValue,
//                                   items: programItems,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       selectedValue = value;
//                                     });
//                                     // Evcil hayvan seçildiğinde verileri otomatik çek
//                                     // _fetchPetInfo();
//                                   },
//                                 ),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text("Vücut Ağırlığı"),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text("Vücut Sıcaklığı"),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text("Boyun Çevresi Uzunluğu"),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text("Göğüs Çevresi Uzunluğu"),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text("Vücut Uzunluğu"),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text("Vücut Yüksekliği"),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 13),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text("İdrar Durumu"),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 13),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text("Dışkı Durumu"),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  DateTime today = DateTime.now();
  String? selectedValue;

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      // Tarih seçildiğinde verileri otomatik olarak çek
      // _fetchPetInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "GRAFİKLER:",
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
                                    "Evcil Hayvanım",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  value: selectedValue,
                                  items: programItems,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value;
                                    });
                                    // Evcil hayvan seçildiğinde verileri otomatik çek
                                    // _fetchPetInfo();
                                  },
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Vücut Ağırlığı"),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Vücut Sıcaklığı"),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Boyun Çevresi Uzunluğu"),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Göğüs Çevresi Uzunluğu"),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Vücut Uzunluğu"),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Vücut Yüksekliği"),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 13),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("İdrar Durumu"),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 13),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Dışkı Durumu"),
                                    ),
                                  ],
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
