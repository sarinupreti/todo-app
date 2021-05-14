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
    final updatedId = task.copyWith(id: documentRef.id);
    await tasksRef.doc(updatedId.id).set(updatedId.toJson());
    return tasksRef.id;
  }

  ///read tasks from firestore
  Stream<List<Task>> readTasks() {
    Stream<QuerySnapshot> stream = tasksRef.snapshots();

    return stream.map(
        (qShot) => qShot.docs.map((doc) => Task.fromJson(doc.data())).toList());
  }

  ///update existing tasks from firestore
  Future updateTask(Task task) async {
    final document = tasksRef.doc(task.id);
    await document.update(task.toJson());
  }

  ///delete tasks from firestore
  Future deleteTask(Task task) async {
    final document = tasksRef.doc(task.id);
    await document.delete().then((value) {
      return value;
    }).onError((error, stackTrace) => {print(error)});
  }

  //
}
