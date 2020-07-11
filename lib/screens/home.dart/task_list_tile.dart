import 'package:Homework_Communities/models/task.dart';
import 'package:Homework_Communities/models/user.dart';
import 'package:Homework_Communities/services/database_services.dart';
import 'package:Homework_Communities/shared/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class TaskTile extends StatefulWidget {
  final Task tasks;
  final User user;
  TaskTile({this.tasks, this.user});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  void initState() {
    super.initState();
    getAnswer();
    getUserInfo();
  }

  bool showAnswerForm = false;
  TextEditingController answerC = TextEditingController();
  String answer;
  String url;
  String name;
  Stream<QuerySnapshot> getAnswer() {
    return Firestore.instance
        .collection('Answers')
        .where("question", isEqualTo: widget.tasks.title)
        .snapshots();
  }

  void close() {
    setState(() {
      showAnswerForm = !showAnswerForm;
      answerC.clear();
    });
  }

  getUserInfo() {
    return Firestore.instance
        .collection('Users')
        .where('uid', isEqualTo: widget.user.uid)
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              return setState(() {
                name = element.data["username"];
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getAnswer(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final answers = snapshot.data.documents;
          return Container(
            padding: EdgeInsets.all(6),
            child: Card(
              elevation: 3.5,
              child: ExpansionTile(
                trailing: answers.isNotEmpty
                    ? CircleAvatar(child: Text(answers.length.toString()))
                    : null,
                leading: Icon(Icons.note, size: 30),
                childrenPadding: EdgeInsets.only(left: 20, bottom: 20),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 7),
                    Text(widget.tasks.title),
                    Text(
                      widget.tasks.discription,
                      maxLines: 20,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    widget.tasks.image == null
                        ? Container()
                        : Container(
                            decoration: BoxDecoration(
                              color: primarySwaches.withOpacity(.4),
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: NetworkImage(url)),
                            ),
                            height: 350,
                            width: double.infinity,
                          ),
                    SizedBox(height: 20),
                  ],
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: answers.length,
                    itemBuilder: (_, i) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            answers[i].data['name'].substring(0, 1),
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        title: Text(answers[i].data['name']),
                        subtitle: Text(answers[i].data["answer"]),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  showAnswerForm == false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton.icon(
                              label: Text('Give answer'),
                              icon: Icon(Icons.question_answer),
                              onPressed: () => setState(
                                () => showAnswerForm = !showAnswerForm,
                              ),
                            ),
                            // IconButton(
                            //   onPressed: () => DatabaseService().deleteTask(
                            //     widget.tasks.title,answers[i].data['name'],
                            //   ),
                            //   icon: Icon(Icons.delete),
                            // ),
                          ],
                        )
                      : Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onChanged: (val) =>
                                      setState(() => answer = val),
                                  controller: answerC,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    prefixIcon: IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () => close(),
                                    ),
                                    hintText: 'Answer',
                                  ),
                                ),
                              ),
                              FlatButton.icon(
                                color: primarySwaches,
                                textColor: Colors.white,
                                onPressed: answer == '' || answerC.text == ''
                                    ? null
                                    : () async {
                                        await DatabaseService().updateAnswer(
                                            answer, name, widget.tasks.title);
                                        close();
                                      },
                                icon: Icon(Icons.question_answer),
                                label: Text('Answer'),
                                disabledColor: Colors.grey,
                              )
                            ],
                          ),
                        )
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
