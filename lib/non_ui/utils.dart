import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Utlis {
  static void showSnackbar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "$title",
      ),
      duration: Duration(milliseconds: 500),
    ));
  }

  static DateTime toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }

  static StreamTransformer transformer<Task>(
          Task Function(Map<String, dynamic> json) fromJson) =>
      StreamTransformer<QuerySnapshot<Object>, List<Task>>.fromHandlers(
        handleData: (QuerySnapshot data, EventSink<List<Task>> sink) {
          final snaps = data.docs.map((doc) => doc.data()).toList();
          final objects = snaps.map((json) => fromJson(json)).toList();

          sink.add(objects);
        },
      );
}
