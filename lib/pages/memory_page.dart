import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_application_2/models/note.dart';
import 'package:flutter_application_2/models/edit.dart';
import 'package:flutter_application_2/models/colors.dart';

class MemoryPage extends StatefulWidget {
  @override
  _MemoryPageState createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  List<Note> filteredNotes = [];
  bool sorted = false;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    filteredNotes = sampleNotes;
  }

//Notları değiştirilme zamanına göre sıralayan bir fonksiyon.
  List<Note> sortNotesByModifiedTime(List<Note> notes) {
    if (sorted) {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      notes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }

    sorted = !sorted;

    return notes;
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  // Arama çubuğuna yazılan metni temel alarak notları filtreleyen bir fonksiyon.
  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredNotes = sampleNotes
          .where((note) =>
              note.content.toLowerCase().contains(searchText.toLowerCase()) ||
              note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void deleteNote(int index) {
    setState(() {
      if (index >= 0 && index < filteredNotes.length) {
        Note note = filteredNotes[index];

        // Find the index of the note in the sampleNotes list
        int originalIndex =
            sampleNotes.indexWhere((element) => element.id == note.id);

        if (originalIndex != -1) {
          sampleNotes.removeAt(originalIndex);
        }

        filteredNotes.removeAt(index);
      }
    });
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Hata durumunu kontrol et
      print("Image picker error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 249, 249),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ANILAR',
                  style: TextStyle(
                      fontSize: 30, color: Color.fromARGB(255, 120, 43, 119)),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      // Notları değiştirilme zamanına göre sıralayan fonksiyonu çağır
                      filteredNotes = sortNotesByModifiedTime(filteredNotes);
                    });
                  },
                  padding: const EdgeInsets.all(0),
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 187, 122, 225).withOpacity(.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.sort,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            //arama kısmı
            TextField(
              onChanged: onSearchTextChanged,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: " Anı Ara..",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 32, 7, 11),
                ),
                fillColor: Color.fromARGB(255, 212, 83, 187),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: Color.fromARGB(0, 0, 0, 0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: Color.fromARGB(0, 0, 0, 0)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //NOTLAR
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 30),
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 20),
                    color: getRandomColor(),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        onTap: () async {
                          //EDİT SCREEN E YÖNLENDİRİLİYOR NOTA TIKLANDIĞINDA
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EditScreen(note: filteredNotes[index]),
                            ),
                          );
                          if (result != null) {
                            //NOTU GÜNCELLE
                            setState(() {
                              int originalIndex =
                                  sampleNotes.indexOf(filteredNotes[index]);

                              sampleNotes[originalIndex] = Note(
                                id: sampleNotes[originalIndex].id,
                                title: result[0],
                                content: result[1],
                                modifiedTime: DateTime.now(),
                                image: selectedImage,
                              );

                              filteredNotes[index] = Note(
                                id: filteredNotes[index].id,
                                title: result[0],
                                content: result[1],
                                modifiedTime: DateTime.now(),
                                image: selectedImage,
                              );
                            });
                          }
                        },
                        title: RichText(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: '${filteredNotes[index].title} \n',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: filteredNotes[index].content,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              )
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Edited: ${DateFormat('EEE MMM d, yyyy h:mm a').format(filteredNotes[index].modifiedTime)}',
                            style: TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            final result = await confirmDialog(context);
                            if (result != null && result) {
                              deleteNote(index);
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _selectImage();
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const EditScreen(),
            ),
          );

          if (result != null) {
            setState(() {
              sampleNotes.add(
                Note(
                  id: sampleNotes.length,
                  title: result[0],
                  content: result[1],
                  image: selectedImage,
                  modifiedTime: DateTime.now(),
                ),
              );
              filteredNotes = sampleNotes;
              selectedImage = null;
            });
          }
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(
          Icons.add,
          size: 38,
        ),
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          icon: const Icon(
            Icons.info,
            color: Colors.grey,
          ),
          title: const Text(
            'Are you sure you want to delete?',
            style: TextStyle(color: Colors.white),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const SizedBox(
                  width: 60,
                  child: Text(
                    'Yes',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const SizedBox(
                  width: 60,
                  child: Text(
                    'No',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
