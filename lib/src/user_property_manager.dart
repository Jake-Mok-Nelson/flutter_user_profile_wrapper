import 'package:flutter/material.dart';

class UserPropertyManager {
  final Map<String, UserProperty> _userProperties = {};

  void defineProperty(String key, UserProperty property) {
    _userProperties[key] = property;
  }

  dynamic getProperty(String key) {
    return _userProperties[key]?.get();
  }

  bool validateProperty(String key) {
    final property = _userProperties[key];
    return property != null && property.validate();
  }

  void saveProperty(String key, dynamic value) {
    _userProperties[key]?.save(value);
  }
}

class UserProperty {
  final Function get;
  final Function validate;
  final Function save;
  final TextInputType inputType;

  UserProperty({
    required this.get,
    required this.validate,
    required this.save,
    this.inputType = TextInputType.text,
  });
}
