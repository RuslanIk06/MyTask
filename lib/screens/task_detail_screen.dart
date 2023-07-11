import 'package:flutter/material.dart';
import 'package:my_task/function.dart';
import 'package:my_task/models/place_location.dart';
import 'package:my_task/models/task.dart';
import 'package:my_task/services/database_service.dart';
import 'package:my_task/widgets/map_widget.dart';

class TaskDetalScreen extends StatefulWidget {
  const TaskDetalScreen({super.key, required this.task});

  final Task task;

  @override
  State<TaskDetalScreen> createState() => _TaskDetalScreenState();
}

class _TaskDetalScreenState extends State<TaskDetalScreen> {
  Task _task = Task(id: '', title: '');
  final _taskTitleController = TextEditingController();
  final _today = DateTime.now();

  void _setLocation(PlaceLocation placeLocation) {
    setState(() {
      _task = _task.copyWith(
          latitude: placeLocation.latitude, longitude: placeLocation.longitude);
    });
  }

  @override
  void initState() {
    _task = widget.task;
    _taskTitleController.text = _task.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Task"),
        actions: [
          IconButton(
            onPressed: () {
              DatabaseService().deleteTask(_task.id);
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Apa yang mau kamu lakukan ? "),
              const SizedBox(height: 10),
              TextField(
                controller: _taskTitleController,
                decoration: const InputDecoration(
                  hintText: 'Saya mau...',
                ),
                onChanged: (value) {
                  _task = _task.copyWith(title: value);
                },
              ),
              const SizedBox(height: 25),
              const Text("Tanggal Waktu Penyelesaian"),
              const SizedBox(height: 10),
              if (_task.dueDate != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            FormatDateTime(_task.dueDate),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _task = _task.copyWith(
                                dueDate: DateTime(0),
                              );
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_task.dueDate == null)
                Row(
                  children: [
                    dueDatebutton('Hari Ini', value: _today),
                    dueDatebutton(
                      'Besok',
                      value: _today.add(
                        const Duration(days: 1),
                      ),
                    ),
                  ],
                ),
              if (_task.dueDate == null)
                Row(
                  children: [
                    dueDatebutton(
                      'Minggu Depan',
                      value: _today.add(
                        Duration(
                          days: (_today.weekday - 7).abs() + 1,
                        ),
                      ),
                    ),
                    dueDatebutton(
                      'Custom',
                      onPressed: () async {
                        DateTime? pickDate = await showDatePicker(
                          context: context,
                          initialDate: _today,
                          firstDate: _today,
                          lastDate: DateTime(_today.year + 10),
                        );

                        if (pickDate != null) {
                          setState(() {
                            _task = _task.copyWith(dueDate: pickDate);
                          });
                        }
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 25),
              const Text("Catatan"),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  String? note = await showDialog(
                    context: context,
                    builder: (builder) {
                      String tempNote = _task.note;
                      return Dialog(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Catatan',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              TextFormField(
                                maxLines: 6,
                                initialValue: tempNote,
                                onChanged: (value) {
                                  tempNote = value;
                                },
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(tempNote);
                                },
                                child: const Text("Selesai"),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  if (note != null) {
                    setState(() {
                      _task = _task.copyWith(note: note);
                    });
                  }
                },
                child: _task.note.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 0.5),
                        ),
                        child: const Center(
                          child: Text('Tap untuk menambahkan catatan'),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: Text(
                          _task.note,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
              ),
              const SizedBox(height: 25),
              const Text("Lokasi"),
              const SizedBox(height: 15),
              MapWidget(
                placeLocation: PlaceLocation(
                    latitude: _task.latitude, longitude: _task.longitude),
                setLocationFn: _setLocation,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  DatabaseService().updateTask(_task);
                  Navigator.of(context).pop();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    Text('Simpan'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  DatabaseService().toggleCompleted(_task);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    Text(
                      'Selesai',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dueDatebutton(String text,
      {DateTime? value, VoidCallback? onPressed}) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed ??
            () {
              setState(() {
                _task = _task.copyWith(dueDate: value);
              });
            },
        icon: const Icon(Icons.alarm_add),
        label: Text(text),
      ),
    );
  }
}
