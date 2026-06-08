import 'package:frappe_form2/frappe_form2.dart';
import 'package:flutter/material.dart';

extension CustomTimeUtils on TimeOfDay {
  String toJson() {
    final String hourLabel = hour.asTwoDigits;
    final String minuteLabel = minute.asTwoDigits;
    return '$hourLabel:$minuteLabel:00';
  }
}
