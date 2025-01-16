import 'package:flutter/material.dart';
import 'package:user_profile_gatekeeper/user_profile_gatekeeper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define user properties
    // Important: These are example validators only, ensure you use
    // proper validation logic for your app
    final List<UserProperty> userProperties = [
      UserProperty(
        label: 'Name',
        get: () async => '', // Replace with actual retrieval logic
        validate: (value) => value.length >= 2,
        save: (value) async {
          // Replace with actual save logic
          debugPrint('Name saved: $value');
        },
      ),
      UserProperty(
        label: 'Email',
        get: () async => '', // Replace with actual retrieval logic
        validate: (value) => RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value),
        save: (value) async {
          // Replace with actual save logic
          debugPrint('Email saved: $value');
        },
        inputType: TextInputType.emailAddress,
      ),
      UserProperty(
        label: 'Phone Number',
        get: () async => '', // Replace with actual retrieval logic
        validate: (value) =>
            value.length > 7 &&
            value.length < 25 &&
            value.contains(RegExp(r'^[0-9]*$')),
        save: (value) async {
          // Replace with actual save logic
          debugPrint('Phone Number saved: $value');
        },
        inputType: TextInputType.phone,
      ),
      UserProperty(
        label: 'Date of Birth (YYYY-MM-DD)',
        get: () async => '', // Replace with actual retrieval logic
        validate: (value) {
          final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
          if (!datePattern.hasMatch(value)) {
            return false;
          }
          final parts = value.split('-');
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final day = int.parse(parts[2]);
          if (year < 1900 || year > 2022) {
            return false;
          }
          if (month < 1 || month > 12) {
            return false;
          }
          if (day < 1 || day > 31) {
            return false;
          }
          return true;
        },
        save: (value) async {
          // Replace with actual save logic
          debugPrint('Date of Birth saved: $value');
        },
        inputType: TextInputType.datetime,
      ),
    ];

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: UserProfileGatekeeper(
        requiredUserProperties: userProperties,
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
