import 'package:flutter/material.dart';

/// Represents a user profile property with validation and persistence capabilities.
///
/// Use this class to define form fields for user profile data collection with
/// built-in validation and saving functionality.
///
/// Example:
/// ```dart
/// final nameProperty = UserProperty(
///   label: 'Name',
///   get: () => currentName,
///   validate: (value) => value.length >= 2,
///   save: (value) => saveName(value),
/// );
/// ```
@immutable
class UserProperty {
  /// Display label for the form field
  final String label;

  /// Callback to retrieve the current value of the property
  final String Function() get;

  /// Validation function that returns true if the value is valid
  final bool Function(String value) validate;

  /// Callback to persist the property value
  final void Function(String value) save;

  /// The type of keyboard to display for input
  final TextInputType inputType;

  const UserProperty({
    required this.label,
    required this.get,
    required this.validate,
    required this.save,
    this.inputType = TextInputType.text,
  });

  /// Validates a given value against the property's validation rules
  bool isValid(String value) {
    return validate(value);
  }
}
