import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class Constants {
  static String millisecondsToFormatString(String lastModified) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(lastModified));
    return DateFormat('h:mm a').format(dateTime);
  }
  static String dateYearFormatString(String lastModified) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(lastModified));
    return DateFormat("dd/MM/yyyy").format(dateTime);
  }
  static DateTime stringTimeToDate(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return dateTime;
  }
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
  static final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  );
}