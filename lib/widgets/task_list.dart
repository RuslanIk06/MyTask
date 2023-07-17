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
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
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
          final taskList = snapshot.data as List<Tasks>;
          return ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (ctx, index) {
              return Card(
                color: taskList[index].complated ? Colors.grey : null,
                child: ListTile(
                  onTap: taskList[index].complated
                      ? null
                      : () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (builder) => TaskDetalScreen(
                                task: taskList[index],
                              ),
                            ),
                          ),
                  leading: IconButton(
                    onPressed: () {
                      DatabaseService().toggleCompleted(taskList[index]);
                    },
                    icon: taskList[index].complated
                        ? const Icon(Icons.check_outlined)
                        : const Icon(Icons.circle_outlined),
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
