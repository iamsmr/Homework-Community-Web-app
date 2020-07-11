import 'dart:html';
import 'dart:typed_data';
import 'package:Homework_Communities/screens/home.dart/task_list.dart';
import 'package:Homework_Communities/services/database_services.dart';
import 'package:Homework_Communities/shared/common.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:firebase/firebase.dart' as fb;

class Body extends StatefulWidget {
  final String uid;
  Body({this.uid});
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String task;
  String discription = '';
  bool isExpanded = false;
  String name = '  ';

  TextEditingController taskC = TextEditingController();
  TextEditingController discriptionC = TextEditingController();
  Uint8List pickedImage;
  pickImage() async {
    Uint8List fromPicker =
        await ImagePickerWeb.getImage(outputType: ImageType.bytes);

    if (fromPicker != null) {
      setState(() {
        pickedImage = fromPicker;
      });
    }
  }

  DatabaseService _databaseService = DatabaseService();
  void getUserInfo() async {
    await _databaseService.getUserInfo(widget.uid);
    setState(() {
      name = _databaseService.name;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void clear() {
    setState(() {
      taskC.clear();
      discriptionC.clear();
      pickedImage = null;
    });
  }

  void uploadTaskAndClear() async {
    await DatabaseService().updateTask(task, discription);
    setState(() {
      clear();
      isExpanded = !isExpanded;
    });
  }

  fb.UploadTask _uploadTask;
  Future uploadToFirebase(Uint8List imageFile, String imageName) async {
    final filePath = 'images/$imageName.png';
    setState(() {
      _uploadTask = fb
          .storage()
          .refFromURL('gs://question-ask.appspot.com')
          //.put(imageFile);
          .child(filePath)
          .put(imageFile);
    });

    return _uploadTask;
  }

  // String imageURL = fb
  //     .storage()
  //     .refFromURL('gs://question-ask.appspot.com')
  //     .child('images')
  //     .getDownloadURL()
  //     .toString();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final blankBox = size.width > 688
        ? Expanded(
            flex: 1,
            child: Container(
              height: size.height,
              color: Colors.grey[300],
            ),
          )
        : Text('');
    return Row(
      children: [
        blankBox,
        Expanded(
          flex: 3,
          child: Container(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              children: [
                ListTile(
                  title: Text('Post a task'),
                  leading: Icon(Icons.event_note, color: primarySwaches),
                ),
                SizedBox(height: 15),
                Card(
                  elevation: 2,
                  child: ExpansionTile(
                    onExpansionChanged: (val) => setState(
                      () => isExpanded = val,
                    ),
                    childrenPadding: EdgeInsets.only(left: 45, right: 45),
                    trailing: Text(''),
                    children: [
                      Container(
                        color: Color(0xffECEBF3),
                        child: TextField(
                          controller: taskC,
                          onChanged: (val) => setState(() => task = val),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Question',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        color: Color(0xffECEBF3),
                        child: TextField(
                          onChanged: (val) => setState(() => discription = val),
                          controller: discriptionC,
                          maxLines: null,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Discribe More',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      FlatButton.icon(
                        onPressed: () {
                          setState(() {
                            pickImage();
                          });
                        },
                        icon: Icon(Icons.add_a_photo),
                        label: Text('Attach Photo'),
                      ),
                      pickedImage != null
                          ? Container(
                              height: 300,
                              width: 400,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: MemoryImage(pickedImage),
                                ),
                              ),
                              //child: Image.file(pickedImage))
                            )
                          : Container(),
                      ButtonBar(
                        children: [
                          FlatButton(
                            color: primarySwaches,
                            textColor: Colors.white,
                            onPressed: task == '' || discription == ''
                                ? null
                                : () async {
                                    uploadTaskAndClear();
                                    await uploadToFirebase(pickedImage, task);
                                  },
                            child: Text('Post'),
                            disabledColor: Colors.grey,
                          ),
                          RaisedButton(
                            onPressed: () => clear(),
                            child: Text('Cancel'),
                          ),
                        ],
                      ),
                    ],
                    title: Text(
                      'Write your Questions here $name ?',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    leading: CircleAvatar(
                      child: Text(
                        '${name.substring(0, 1)}',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Questions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TaskList(),
              ],
            ),
          ),
        ),
        blankBox,
      ],
    );
  }
}
