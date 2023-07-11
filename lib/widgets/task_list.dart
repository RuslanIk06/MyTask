import 'package:flutter/material.dart';
import 'package:my_task/function.dart';
import 'package:my_task/models/task.dart';
import 'package:my_task/screens/task_detail_screen.dart';
import 'package:my_task/services/database_service.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService().tasks,
      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        }

        if (snapshot.data != null) {
          final taskList = snapshot.data as List<Task>;
          return ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (ctx, index) {
              return Card(
                color: taskList[index].complated ? Colors.grey : null,
                child: ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (builder) => TaskDetalScreen(
                        task: taskList[index],
                      ),
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {},
                    icon: taskList[index].complated
                        ? Icon(Icons.check_outlined)
                        : Icon(Icons.circle_outlined),
                  ),
                  title: Text(taskList[index].title),
                  subtitle: taskList[index].dueDate == null
                      ? null
                      : Text(
                          FormatDateTime(taskList[index].dueDate),
                        ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text("Tidak Ada Data"),
          );
        }
      },
    );
  }
}
