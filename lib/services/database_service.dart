import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_task/models/data_users.dart';
import 'package:my_task/models/task.dart';

class DatabaseService {
  String _uid = '';

  DatabaseService() {
    if (FirebaseAuth.instance.currentUser != null) {
      _uid = FirebaseAuth.instance.currentUser!.uid;
    }
  }

  final _taskReference = FirebaseFirestore.instance.collection('mytask');
  final _datauserReference = FirebaseFirestore.instance.collection('users');

  List<Tasks> _taskListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Tasks(
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

  Stream<List<Tasks>> get tasks {
    return _taskReference
        .where('uid', isEqualTo: _uid)
        .orderBy('complated')
        .orderBy('due_date')
        .snapshots()
        .map(_taskListFromSnapshots);
  }

  DataUser _dataUserFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return DataUser(
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      userImageUrl: data['user_image_url'] ?? '',
    );
  }

  Stream<DataUser> get dataUser {
    return _datauserReference.doc(_uid).snapshots().map(_dataUserFromSnapshot);
  }

  Future addNewTask(String title) {
    return _taskReference.add({
      'title': title,
      'due_date': null,
      'complated': false,
      'uid': _uid,
    });
  }

  Future updateTask(Tasks task) {
    return _taskReference.doc(task.id).update({
      'title': task.title,
      'note': task.note,
      'location': GeoPoint(task.latitude, task.longitude),
      'due_date': task.dueDate == null ? null : task.dueDate!.toIso8601String(),
      'complated': task.complated,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future toggleCompleted(Tasks task) {
    return _taskReference.doc(task.id).update({
      'complated': !task.complated,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future deleteTask(String docId) {
    return _taskReference.doc(docId).delete();
  }

  Future updateUsername(String username) {
    return _datauserReference.doc(_uid).update({
      'username': username,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future uploadUserImage(File file) async {
    final ref =
        FirebaseStorage.instance.ref().child('user_data').child(_uid + '.jpg');
    await ref.putFile(file);

    final url = await ref.getDownloadURL();

    await _datauserReference.doc(_uid).update({
      'user_image_url': url,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}
