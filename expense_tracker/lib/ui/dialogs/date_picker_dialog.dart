import 'package:flutter/material.dart';

class DateTimePickerDialog{
  static Future<DateTime?> datePicker(BuildContext context){
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
  }
}