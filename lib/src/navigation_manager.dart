import 'package:flutter/material.dart';
import 'package:user_profile_gatekeeper/src/profile_completion_form.dart';
import 'user_property.dart';

/// Manages navigation behavior for profile completion forms.
class NavigationManager {
  final List<UserProperty> requiredUserProperties;

  NavigationManager({required this.requiredUserProperties});

  Future<bool> isProfileComplete() async {
    for (final userProperty in requiredUserProperties) {
      final value = await userProperty.get();
      if (value.isEmpty || value == '') {
        return false;
      }
      if (!userProperty.isValid(value)) {
        return false;
      }
    }
    return true;
  }

  void navigateToChild(BuildContext context, Widget child) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => child),
    );
  }

  void navigateToProfileCompletionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileCompletionForm(
          requiredUserProperties: requiredUserProperties,
        ),
      ),
    );
  }
}
