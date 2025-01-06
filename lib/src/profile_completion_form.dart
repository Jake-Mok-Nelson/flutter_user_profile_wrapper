import 'package:flutter/material.dart';
import 'user_property.dart';

class ProfileCompletionForm extends StatefulWidget {
  final List<UserProperty> requiredUserProperties;

  const ProfileCompletionForm(
      {super.key, required this.requiredUserProperties});

  @override
  ProfileCompletionFormState createState() => ProfileCompletionFormState();
}

class ProfileCompletionFormState extends State<ProfileCompletionForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Ensure that every user property has a unique label
    if (widget.requiredUserProperties
            .map((userProperty) => userProperty.label)
            .toSet()
            .length !=
        widget.requiredUserProperties.length) {
      throw ArgumentError('Every user property must have a unique label');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ...widget.requiredUserProperties.map((prop) {
                return TextFormField(
                  key: Key(prop.label),
                  keyboardType: prop.inputType,
                  decoration: InputDecoration(labelText: prop.label),
                  onSaved: (newValue) => prop.save(newValue!),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your ${prop.label}';
                    }

                    if (!prop.isValid(value)) {
                      return 'Invalid ${prop.label}';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved')),
      );
    }
  }
}
