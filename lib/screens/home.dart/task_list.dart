import 'package:Homework_Communities/models/task.dart';
import 'package:Homework_Communities/models/user.dart';
import 'package:Homework_Communities/screens/home.dart/task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<List<Task>>(context) ?? [];
    final user = Provider.of<User>(context);
    return tasks.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (_, i) {
              return TaskTile(tasks: tasks[i], user: user);
            },
          )
        : Container(
            child: Column(
              children: [
                SizedBox(height: 20),
                Icon(Icons.hourglass_empty, size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'No Question Found',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          );
  }
}
