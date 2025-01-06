import 'package:flutter/material.dart';
import 'user_property.dart';

/// A form widget that collects required user profile information.
///
/// This widget creates a form with input fields for each required user property.
/// It validates that all user properties have unique labels and ensures proper
/// input validation for each field.
///
/// Example:
/// ```dart
/// ProfileCompletionForm(
///   requiredUserProperties: [
///     UserProperty(label: 'Name', inputType: TextInputType.text),
///     UserProperty(label: 'Email', inputType: TextInputType.emailAddress),
///   ],
/// )
/// ```
///
/// The form includes:
/// * Input fields for each required property
/// * Validation for empty fields and property-specific validation
/// * A save button that validates and saves all input
///
/// Throws an [ArgumentError] if any user properties have duplicate labels.

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
                return FutureBuilder<String>(
                  future: prop.get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return TextFormField(
                      key: Key(prop.label),
                      keyboardType: prop.inputType,
                      decoration: InputDecoration(labelText: prop.label),
                      initialValue: snapshot.data,
                      onSaved: (newValue) async => await prop.save(newValue!),
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

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(); // Navigate back after saving
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved')),
      );
    }
  }
}
