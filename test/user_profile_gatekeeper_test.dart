import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:user_profile_gatekeeper/user_profile_gatekeeper.dart';
import 'package:user_profile_gatekeeper/src/profile_completion_form.dart';
import 'package:user_profile_gatekeeper/src/navigation_manager.dart';

class FakeNavigationManager extends NavigationManager {
  FakeNavigationManager({required super.requiredUserProperties});

  // Function to override isProfileComplete behavior
  Future<bool> Function()? overrideIsProfileComplete;
  bool navigateToProfileCompletionScreenCalled = false;

  @override
  Future<bool> isProfileComplete() {
    if (overrideIsProfileComplete != null) {
      return overrideIsProfileComplete!();
    }
    return super.isProfileComplete();
  }

  @override
  navigateToProfileCompletionScreen(BuildContext context) {
    navigateToProfileCompletionScreenCalled = true;
    return super.navigateToProfileCompletionScreen(context);
  }
}

void main() {
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

  group('UserProfileGatekeeper', () {
    testWidgets('displays child when profile is complete', (tester) async {
      // Arrange
      final fakeManager = FakeNavigationManager(requiredUserProperties: []);
      // Simulate profile completion
      fakeManager.overrideIsProfileComplete = () async => true;

      // Act
      await tester.pumpWidget(MaterialApp(
        home: UserProfileGatekeeper(
          requiredUserProperties: [],
          navigationManager: fakeManager,
          child: const Text('Child Widget'),
        ),
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Child Widget'), findsOneWidget);
    });

    testWidgets('navigates to profile completion when profile is incomplete',
        (tester) async {
      // Arrange
      final fakeManager = FakeNavigationManager(requiredUserProperties: []);
      // Simulate profile incompletion
      fakeManager.overrideIsProfileComplete = () async => false;

      final prop = UserProperty(
        label: 'Name',
        get: () async => '',
        validate: (v) => v.isNotEmpty,
        save: (v) async {},
      );

      // Act
      await tester.pumpWidget(MaterialApp(
        home: UserProfileGatekeeper(
          requiredUserProperties: [
            prop,
          ],
          navigationManager: fakeManager,
          child: const Text('Child Widget'),
        ),
      ));
      await tester.pumpAndSettle();

      // Assert
      // Since navigation is handled internally, verify that navigation method was called
      expect(fakeManager.navigateToProfileCompletionScreenCalled, isTrue);
      // Optionally, verify that the child is not displayed
      expect(find.text('Child Widget'), findsNothing);
      expect(find.text('Complete Your Profile'), findsOne);
    });

    testWidgets(
        'navigates to profile completion for missing property and then to child when complete',
        (tester) async {
      String storedValue = '';
      final prop = UserProperty(
        label: 'Name',
        get: () async => storedValue,
        validate: (v) => v.isNotEmpty,
        save: (v) async => storedValue = v,
      );
      debugPrint('prop: $prop');

      // Act
      await tester.pumpWidget(MaterialApp(
        home: UserProfileGatekeeper(
          requiredUserProperties: [
            prop,
          ],
          child: const Text('Child Widget'),
        ),
      ));
      await tester.pumpAndSettle();

      // Assert
      // verify that the profile completion form is displayed
      expect(find.text('Child Widget'), findsNothing);
      expect(find.byType(ProfileCompletionForm), findsOneWidget);

      // Act
      // find the fields and enter a valid value
      await tester.enterText(find.byKey(const Key('Name')), 'John');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Assert
      // verify that the child is now displayed
      expect(find.text('Child Widget'), findsOneWidget);
      expect(find.text('Complete Your Profile'), findsNothing);
    });
  });
}

// TODO: Save function cannot run until isValid is true

// TODO: Add another test case, where the user enters an invalid value, then a valid value, and then the child is displayed.