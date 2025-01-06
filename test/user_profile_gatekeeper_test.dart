import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:user_profile_gatekeeper/user_profile_gatekeeper.dart';
import 'package:user_profile_gatekeeper/src/profile_completion_form.dart';
import 'package:user_profile_gatekeeper/src/navigation_manager.dart';

class FakeNavigationManager extends NavigationManager {
  FakeNavigationManager({required super.requiredUserProperties});

  Completer<bool>? isProfileCompleteCompleter;

  @override
  Future<bool> isProfileComplete() {
    return isProfileCompleteCompleter?.future ?? super.isProfileComplete();
  }

  @override
  Widget navigateToProfileCompletionScreen(BuildContext context) {
    return const Text('Mock Profile Completion Screen');
  }
}

void main() {
  group('ProfileWrapper', () {
    testWidgets('shows CircularProgressIndicator while loading',
        (tester) async {
      final manager = FakeNavigationManager(requiredUserProperties: []);
      manager.isProfileCompleteCompleter = Completer<bool>();
      await tester.pumpWidget(MaterialApp(
        home: UserProfileGatekeeper(
          requiredUserProperties: const [],
          navigationManager: manager,
          child: const Text('Child Widget'),
        ),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      manager.isProfileCompleteCompleter!.complete(true);
      await tester.pumpAndSettle();
    });

    testWidgets('shows child if profile is complete', (tester) async {
      final manager = FakeNavigationManager(requiredUserProperties: []);
      manager.isProfileCompleteCompleter = Completer<bool>()..complete(true);
      await tester.pumpWidget(MaterialApp(
        home: UserProfileGatekeeper(
          requiredUserProperties: const [],
          navigationManager: manager,
          child: const Text('Child Widget'),
        ),
      ));
      await tester.pump();
      expect(find.text('Child Widget'), findsOneWidget);
    });

    testWidgets('navigates to profile completion screen if not complete',
        (tester) async {
      final manager = FakeNavigationManager(requiredUserProperties: []);
      manager.isProfileCompleteCompleter = Completer<bool>()..complete(false);
      await tester.pumpWidget(MaterialApp(
        home: UserProfileGatekeeper(
          requiredUserProperties: const [],
          navigationManager: manager,
          child: const Text('Child Widget'),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Mock Profile Completion Screen'), findsOneWidget);
    });
  });

  group('UserProperty', () {
    test('isValid returns true for a valid value', () {
      final userProperty = UserProperty(
        label: 'Name',
        get: () async => 'John',
        validate: (value) => value.isNotEmpty,
        save: (value) async {},
      );
      expect(userProperty.isValid('Jane'), isTrue);
    });

    test('isValid returns false for an invalid value', () {
      final userProperty = UserProperty(
        label: 'NonEmpty',
        get: () async => '',
        validate: (value) => value.isNotEmpty,
        save: (value) async {},
      );
      expect(userProperty.isValid(''), isFalse);
    });
  });

  group('NavigationManager', () {
    test('isProfileComplete returns false if any property is invalid',
        () async {
      final props = [
        UserProperty(
            label: 'Empty',
            get: () async => '',
            validate: (v) => v.isNotEmpty,
            save: (v) async {}),
        UserProperty(
            label: 'NonEmpty',
            get: () async => 'John',
            validate: (v) => v.isNotEmpty,
            save: (v) async {}),
      ];
      final manager = NavigationManager(requiredUserProperties: props);
      expect(await manager.isProfileComplete(), isFalse);
    });

    test('isProfileComplete returns true if all properties are valid',
        () async {
      final props = [
        UserProperty(
            label: 'Name',
            get: () async => 'John',
            validate: (v) => v.isNotEmpty,
            save: (v) async {}),
      ];
      final manager = NavigationManager(requiredUserProperties: props);
      expect(await manager.isProfileComplete(), isTrue);
    });
  });

  group('ProfileCompletionForm', () {
    testWidgets('validates and saves form when inputs are valid',
        (tester) async {
      final testProps = [
        UserProperty(
          label: 'Name',
          get: () async => '',
          validate: (v) => v.isNotEmpty,
          save: (v) async {},
        ),
      ];

      await tester.pumpWidget(MaterialApp(
        home: ProfileCompletionForm(requiredUserProperties: testProps),
      ));
      await tester.pumpAndSettle(); // Wait for the FutureBuilder to complete

      await tester.enterText(find.byKey(const Key('Name')), 'Alice');
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Please enter your Name'), findsNothing);
      expect(find.text('Invalid Name'), findsNothing);
    });

    testWidgets('shows validation error with invalid input', (tester) async {
      final testProps = [
        UserProperty(
          label: 'Email',
          get: () async => '',
          validate: (v) => v.contains('@'),
          save: (v) async {},
        ),
      ];

      await tester.pumpWidget(MaterialApp(
        home: ProfileCompletionForm(requiredUserProperties: testProps),
      ));
      await tester.pumpAndSettle(); // Wait for the FutureBuilder to complete

      await tester.enterText(find.byKey(const Key('Email')), 'invalid-email');
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Invalid Email'), findsOneWidget);
    });
  });
}
