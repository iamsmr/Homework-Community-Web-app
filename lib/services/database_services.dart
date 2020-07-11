import 'dart:typed_data';

import 'package:Homework_Communities/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //Collection Refrence to user Collection
  CollectionReference userCollection = Firestore.instance.collection('Users');

  //Collection refrence to task or Question Colllection
  CollectionReference taskCollection = Firestore.instance.collection('Tasks');

  //Collection refrence to Answer collection
  CollectionReference answerCollection =
      Firestore.instance.collection('Answers');

  //Sirin Nme
  String name = '';

  //Update user Data
  Future updateUserData(String username, String email, String uid) async {
    return await userCollection.document(email).setData({
      "username": username,
      "email": email,
      "uid": uid,
    });
  }

  //Update Task
  Future updateTask(String task, String discription) async {
    return await taskCollection.document(task).setData({
      "task": task,
      "discription": discription,
    });
  }

  deleteTask(String task, String username) async {
    await answerCollection.document('$username-$task').delete();
    await taskCollection.document(task).delete();
  }

  //update Answer
  Future updateAnswer(String answer, String name, String question) async {
    return await answerCollection.document('$name-$question').setData({
      "answer": answer,
      "name": name,
      "question": question,
    });
  }

  //Task list form Snamshot
  List<Task> tasksFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map(
          (e) => Task(
            title: e.data["task"] ?? '',
            discription: e.data["discription"] ?? '',
          ),
        )
        .toList();
  }

  //stream for task
  Stream<List<Task>> get task {
    return taskCollection.snapshots().map(tasksFromSnapshot);
  }

  Future getUserInfo(String uid) async {
    return await Firestore.instance
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .getDocuments()
        .then(
          (value) => value.documents.forEach(
            (element) {
              if (element != null) {
                name = element.data["username"] ?? '  ';
              }
            },
          ),
        );
  }
  // Future linkStorageToFirestore(Uint8List image) async{
  //   return await taskCollection.
  // }
}
