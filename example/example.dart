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
            label: 'Name',
            get: () async => Future.value('John Doe'),
            validate: (value) => value.isNotEmpty,
            save: (newValue) async {
              // logic to save the new value to a persistent store
              return Future.value();
            },
          ),
          UserProperty(
            label: 'Email',
            get: () async {
              // logic to get the email from a persistent store
              return Future.value('myEmail@email.com');
            },
            validate: (value) {
              // logic to validate the email
              return value.isNotEmpty && value.contains('@');
            },
            save: (newValue) async {
              // logic to save the new value to a persistent store
              return Future.value();
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
