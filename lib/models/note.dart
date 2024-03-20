import 'dart:io'; // Ekledik

class Note {
  int id;
  String title;
  String content;
  File? image;
  DateTime modifiedTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.image,
    required this.modifiedTime,
  });
}

List<Note> sampleNotes = [
  Note(
    id: 0,
    title: 'İlk yürüyüş',
    content:
        'Bugün saat 2de ilk yürüyüşümüzü gerçekleştirdik \nArtık bana daha çok güvendiğini hissediyorum',
    // image:
    //     File('assets/resimler/1.png'), // Resim dosyanızın yolunu buraya ekleyin

    modifiedTime: DateTime(2022, 1, 1, 34, 5),
  ),
  Note(
    id: 1,
    title: 'Top Yakalamca',
    content:
        '1. bugün sabah güneşi ile birlikte yürüyüşe çıktık\ndeniz kenarına vardığımızda Çakıl ile birlikte yolda bir top bulduk çakıl buna çok sevindi onunla oynamam için etrafımda dönmeye başladı. Beraber top yakalmaca oynadık , çok eğlenceli bir gündü',
    // image: File('assets/resimler/2.png'),
    modifiedTime: DateTime(2022, 1, 1, 34, 5),
  ),
  Note(
    id: 2,
    title: 'Minnoşun yeni gözlüğü',
    content:
        'Evde bulduğum çocukluk gözlüğümü bugün minnoşun patilerinde buldum , onunla oynuyordu . Belliki çok sevmiş',
    modifiedTime: DateTime(2023, 3, 1, 19, 5),
  ),
];
