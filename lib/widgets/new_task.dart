import 'package:flutter/material.dart';

import '../services/database_service.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  String _taskTitle = '';
  final _taskTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _taskTitleController,
              decoration: InputDecoration(
                hintText: 'Saya Mau....',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(width: 0.5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _taskTitle = value;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: _taskTitle.isEmpty
                ? null
                : () {
                    DatabaseService().addNewTask(_taskTitle);
                    _taskTitleController.clear();
                  },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
