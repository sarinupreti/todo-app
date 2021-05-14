import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:withu_todo/non_ui/jsonclasses/task.dart';

class FirebaseManager {
  static FirebaseManager _one;

  static FirebaseManager get shared =>
      (_one == null ? (_one = FirebaseManager._()) : _one);
  FirebaseManager._();

  Future<void> initialise() => Firebase.initializeApp();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  CollectionReference get tasksRef =>
      FirebaseFirestore.instance.collection('SARIN_UPRETI');

  DocumentReference get documentRef => tasksRef.doc();

  ///add task in firestore
  Future<void> createTask(Task task) async {
    try {
      final updatedId = task.copyWith(id: documentRef.id);
      await tasksRef.doc(updatedId.id).set(updatedId.toJson());
      return tasksRef.id;
    } catch (e) {
      print(e);
    }
  }

  ///read tasks from firestore
  // ignore: missing_return
  Stream<List<Task>> readTasks() {
    try {
      Stream<QuerySnapshot> stream = tasksRef.snapshots();
      return stream.map((qShot) =>
          qShot.docs.map((doc) => Task.fromJson(doc.data())).toList());
    } catch (e) {
      print(e);
    }
  }

  ///update existing tasks from firestore
  Future updateTask(Task task) async {
    try {
      final document = tasksRef.doc(task.id);
      await document.update(task.toJson());
    } catch (e) {
      print(e);
    }
  }

  ///delete tasks from firestore
  Future deleteTask(Task task) async {
    try {
      final document = tasksRef.doc(task.id);
      await document.delete();
    } catch (e) {
      print(e);
    }
  }

  //
}
