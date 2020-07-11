import 'dart:typed_data';

class Task {
  String title;
  String discription;
  DateTime date;
  Uint8List image;
  Task({this.date, this.discription, this.image, this.title});
}
