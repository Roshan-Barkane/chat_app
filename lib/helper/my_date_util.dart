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

  // get last message(used in chat user card)
  static String getLastMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sendTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime currentTime = DateTime.now();

    if (currentTime.day == sendTime.day &&
        currentTime.month == sendTime.month &&
        currentTime.year == sendTime.year) {
      return TimeOfDay.fromDateTime(sendTime).format(context);
    }
    return "${sendTime.day} :${_getMonth(sendTime)} ";
  }

  // get month name from month no. or index
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Mpr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nav';
      case 12:
        return 'Des';
    }
    return 'NA';
  }
}
