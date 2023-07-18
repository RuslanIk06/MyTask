import 'package:flutter/material.dart';
import 'package:my_task/widgets/new_task.dart';
import 'package:my_task/widgets/task_list.dart';

class AllTaskScreen extends StatelessWidget {
  const AllTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MyTask'),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       FirebaseAuth.instance.signOut();
        //     },
        //     icon: const Icon(Icons.logout),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: TaskList(),
              ),
              NewTask(),
            ],
          ),
        ),
      ),
    );
  }
}
