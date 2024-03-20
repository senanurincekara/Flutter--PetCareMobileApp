import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/pets.dart';
import 'package:flutter_application_2/pages/detailpets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  CollectionReference petsCollection =
      FirebaseFirestore.instance.collection('Pets');

  CollectionReference hatirlaticiCollection =
      FirebaseFirestore.instance.collection('hatirlatici');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "BİLDİRİMLER ",
              style: GoogleFonts.balsamiqSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 350,
              height: 250,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 249, 224, 149),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.black,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 5, 109, 95),
                    offset: Offset(4.0, 4.0),
                    blurRadius: 5.0,
                    spreadRadius: 0.2,
                  ),
                ],
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: hatirlaticiCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Bir hata oluştu: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  List<Widget> hatirlaticiWidgets = [];
                  snapshot.data!.docs.forEach((document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    hatirlaticiWidgets.add(
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data['title']}",
                                  style: GoogleFonts.balsamiqSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  "${data['note']}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await hatirlaticiCollection
                                    .doc(document.id)
                                    .delete()
                                    .then((value) {
                                  print("Hatırlatıcı silindi");
                                }).catchError((error) {
                                  print(
                                      "Hatırlatıcı silinirken hata oluştu: $error");
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  });

                  return ListView(
                    physics:
                        BouncingScrollPhysics(), // veya ClampingScrollPhysics()
                    children: hatirlaticiWidgets,
                  );
                },
              ),
            ),

            SizedBox(height: 20),
            Text(
              "EVCİL HAYVANLARIM ",
              style: GoogleFonts.balsamiqSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // İki Container arasına boşluk ekleyebilirsiniz.
            Container(
              width: 350,
              height: 250,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 249, 224, 149),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 5, 109, 95),
                        offset: Offset(4.0, 4.0),
                        blurRadius: 5.0,
                        spreadRadius: 0.2),
                  ]),
              child: StreamBuilder<QuerySnapshot>(
                stream: petsCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Bir hata oluştu: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  List<Pet> pets = [];
                  snapshot.data!.docs.forEach((document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    pets.add(Pet(
                      type: data['type'],
                      name: data['name'],
                      gender: data['gender'],
                      age: data['age'],
                      birthDate: data['birthDate'],
                    ));
                  });

                  return ListView.builder(
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      Pet pet = pets[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPets(pet: pet),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${pet.type} - ${pet.name}",
                                style: GoogleFonts.balsamiqSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await petsCollection
                                      .where('name', isEqualTo: pet.name)
                                      .get()
                                      .then((querySnapshot) {
                                    querySnapshot.docs.first.reference.delete();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
