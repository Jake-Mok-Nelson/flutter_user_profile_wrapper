import 'package:flutter/material.dart';
import 'user_property_manager.dart';

class ProfileCompletionForm extends StatefulWidget {
  final UserPropertyManager userPropertyManager;

  ProfileCompletionForm({required this.userPropertyManager});

  @override
  _ProfileCompletionFormState createState() => _ProfileCompletionFormState();
}

class _ProfileCompletionFormState extends State<ProfileCompletionForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, TextInputType> _inputTypes = {};

  @override
  void initState() {
    super.initState();
    widget.userPropertyManager._userProperties.forEach((key, value) {
      _controllers[key] = TextEditingController(text: widget.userPropertyManager.getProperty(key));
      _inputTypes[key] = TextInputType.text; // Default to TextInputType.text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ..._controllers.keys.map((key) {
                return TextFormField(
                  controller: _controllers[key],
                  keyboardType: _inputTypes[key],
                  decoration: InputDecoration(labelText: key),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your $key';
                    }
                    return null;
                  },
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Save'),
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
      _controllers.forEach((key, controller) {
        widget.userPropertyManager.saveProperty(key, controller.text);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile saved')),
      );
    }
  }
}
