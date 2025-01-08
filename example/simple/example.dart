import 'package:flutter/material.dart';
import 'package:user_profile_gatekeeper/user_profile_gatekeeper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // you want to be logged in already to ensure access to user properties
      home: UserProfileGatekeeper(
        requiredUserProperties: List<UserProperty>.unmodifiable([
          UserProperty(
            label: 'displayName',
            get: () async {
              // Call your APIs here to get the value of a property and see if it's set
              // final user = FirebaseAuth.instance.currentUser;
              // return user?.displayName ?? '';
              return Future.value('John');
            },
            // Validate that the value is not empty and is between 2 and 50 characters
            // Validation occurs on load and when the user tries to save
            validate: (String value) => switch (value) {
              String s when s.isEmpty => false,
              String s when s.length < 2 || s.length > 50 => false,

              // Is AlphaNumeric
              String s when !RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(s) => false,
              _ => true,
            },
            save: (String value) async {
              // Store the new value in a persistent place to proceed with navigation
              // final user = FirebaseAuth.instance.currentUser;
              // await user?.updateDisplayName(value);
            },
          ),
        ]),
        child: Scaffold(
          appBar: AppBar(title: const Text('Profile Wrapper Example')),
          body: const Center(child: Text('Hello, world!')),
        ),
      ),
    );
  }
}
