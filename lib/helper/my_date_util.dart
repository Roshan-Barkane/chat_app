import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDataUtil {
  // for getting formatted time from formMillisecondsSinceEpoch String.
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    // int.parse() that use to type_case string to int.
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
}
