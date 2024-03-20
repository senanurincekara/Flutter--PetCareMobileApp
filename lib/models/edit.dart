import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/note.dart';

// EditScreen, not düzenleme veya yeni not ekleme ekranıdır
class EditScreen extends StatefulWidget {
  final Note? note;
  const EditScreen({super.key, this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  File? _editedImage;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      // Eğer düzenlenen bir not varsa, controller ları ve resmi başlatıyor burda

      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
      _editedImage = widget.note!.image;
    }
  }

  bool isValidImageFile(File file) {
    if (file == null) {
      // Seçilen dosyanın geçerli bir resim dosyası olup olmadığını kontrol eder

      return false;
    }

    // Dosyanın uzantısını al
    String extension = path.extension(file.path).toLowerCase();

    // Desteklenen uzantıları kontrol et (örneğin, jpg, jpeg, png)
    List<String> supportedExtensions = ['.jpg', '.jpeg', '.png'];
    return supportedExtensions.contains(extension);
  }

  // Galeriden resim seçme işlemini gerçekleştirir
  Future<void> _selectImage() async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File selectedImage = File(pickedFile.path);
        if (isValidImageFile(selectedImage)) {
          setState(() {
            _editedImage = selectedImage;
          });
        } else {
          print("Invalid image file");
        }
      }
    } catch (e) {
      print("Image picker error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: const EdgeInsets.all(0),
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800.withOpacity(.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 30),
                    ),
                  ),
                  TextField(
                    controller: _contentController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type something here',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  if (_editedImage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.file(_editedImage!),
                    ),
                  ElevatedButton(
                    onPressed: _selectImage,
                    child: const Text('Select Image'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      //kayıt etme alanı
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(
            context,
            [_titleController.text, _contentController.text, _editedImage],
          );
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.save),
      ),
    );
  }
}
