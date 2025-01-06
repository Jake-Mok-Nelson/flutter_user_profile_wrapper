import 'package:flutter/material.dart';

@immutable
class UserProperty {
  final String label;
  final String Function() get;
  final bool Function(String value)
      validate; // Returns true if the value is valid
  final void Function(String value) save; // Saves the value
  final TextInputType inputType;

  const UserProperty({
    required this.label,
    required this.get,
    required this.validate,
    required this.save,
    this.inputType = TextInputType.text,
  });

  bool isValid(String value) {
    return validate(value);
  }
}
