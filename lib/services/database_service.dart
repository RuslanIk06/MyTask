import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_task/models/task.dart';

class DatabaseService {
  String _uid = '';

  DatabaseService() {
    if (FirebaseAuth.instance.currentUser != null) {
      _uid = FirebaseAuth.instance.currentUser!.uid;
    }
  }

  final _taskReference = FirebaseFirestore.instance.collection('mytask');

  List<Task> _taskListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Task(
        id: doc.id,
        title: data['title'] ?? '',
        note: data['note'] ?? '',
        complated: data['complated'] ?? false,
        dueDate:
            data['due_date'] == null ? null : DateTime.parse(data['due_date']),
        latitude: data['location'] == null ? 0.0 : data['location'].latitude,
        longitude: data['location'] == null ? 0.0 : data['location'].longitude,
      );
    }).toList();
  }

  Stream<List<Task>> get tasks {
    return _taskReference.snapshots().map(_taskListFromSnapshots);
  }

  Future addNewTask(String title) {
    return _taskReference.add({
      'title': title,
      'uid': _uid,
    });
  }

  Future updateTask(Task task) {
    return _taskReference.doc(task.id).update({
      'title': task.title,
      'note': task.note,
      'location': GeoPoint(task.latitude, task.longitude),
      'due_date': task.dueDate == null ? '' : task.dueDate!.toIso8601String(),
      'completed': task.complated,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future toggleCompleted(Task task) {
    return _taskReference.doc(task.id).update({
      'complated': !task.complated,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future deleteTask(String docId) {
    return _taskReference.doc(docId).delete();
  }
}
