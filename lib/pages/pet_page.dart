import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_2/models/pets.dart';
import 'detailpets.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetPage extends StatefulWidget {
  const PetPage({Key? key}) : super(key: key);

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  _MyFormState() {
    _selectedgender = _selectedGenderList[0];
  }

  String selectedType = "Dog";
  final _selectedGenderList = ["Disi", "Erkek"];
  String? _selectedgender = "Disi";

  CollectionReference petsCollection =
      FirebaseFirestore.instance.collection('Pets');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[100],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Evcil Hayvanlarım",
                  style: GoogleFonts.balsamiqSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
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
                          margin: EdgeInsets.only(bottom: 16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${pet.type} - ${pet.name}",
                                style: TextStyle(fontSize: 18),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPetDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddPetDialog(BuildContext context) async {
    String age = "";
    String name = "";
    String gender = "";
    String birthDate = "";

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yeni Evcil Hayvan Ekle'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButton<String>(
                  value: selectedType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue!;
                    });
                  },
                  items: ['Dog', 'Cat', 'Bird'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Ad'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                DropdownButtonFormField(
                  value: _selectedgender,
                  items: _selectedGenderList
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedgender = val as String;
                      gender = val as String;
                    });
                  },
                  dropdownColor: Colors.deepPurple.shade50,
                  decoration: InputDecoration(labelText: "Cinsiyet"),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Yaş'),
                  onChanged: (value) {
                    age = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Doğum Tarihi'),
                  onChanged: (value) {
                    birthDate = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                Pet newPet = Pet(
                  type: selectedType,
                  name: name,
                  gender: gender,
                  age: age,
                  birthDate: birthDate,
                );

                // Firestore'a yeni pet eklemek
                DocumentReference documentReference = await petsCollection.add({
                  'type': newPet.type,
                  'name': newPet.name,
                  'gender': newPet.gender,
                  'age': newPet.age,
                  'birthDate': newPet.birthDate,
                });

                // Eklenen belgenin ID'sini al
                String documentId = documentReference.id;

                // Firestore'da oluşturulan document ID'yi kullanarak belgeyi güncelle
                await documentReference.update({'id': documentId});

                Navigator.pop(context);
              },
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }
}
