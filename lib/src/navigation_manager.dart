import 'package:flutter/material.dart';
import 'package:user_profile_gatekeeper/src/profile_completion_form.dart';
import 'user_property.dart';

/// Manages navigation behavior for profile completion forms.
class NavigationManager {
  final List<UserProperty> requiredUserProperties;

  NavigationManager({required this.requiredUserProperties});

  Future<bool> isProfileComplete() async {
    for (final userProperty in requiredUserProperties) {
      if (!userProperty.isValid(userProperty.get())) {
        return false;
      }
    }
    return true;
  }

  Widget navigateToChild(BuildContext context, Widget child) {
    return child;
  }

  Widget navigateToProfileCompletionScreen(BuildContext context) {
    return ProfileCompletionForm(
        requiredUserProperties: requiredUserProperties);
  }
}
