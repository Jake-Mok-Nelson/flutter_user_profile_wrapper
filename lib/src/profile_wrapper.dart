import 'package:flutter/material.dart';
import 'package:user_profile_gatekeeper/src/user_property.dart';
import 'navigation_manager.dart';

/// A widget that ensures all required user profile properties are completed
/// before displaying its child widget.
///
/// If the profile is incomplete, it will display a profile completion form
/// instead of the child widget.
class UserProfileGatekeeper extends StatelessWidget {
  /// The widget to display when the profile is complete
  final Widget child;

  /// List of user properties that must be validated
  final List<UserProperty> requiredUserProperties;

  /// Optional navigation manager for custom navigation behavior
  final NavigationManager? navigationManager;

  const UserProfileGatekeeper({
    super.key,
    required this.child,
    required this.requiredUserProperties,
    this.navigationManager,
  });

  @override
  Widget build(BuildContext context) {
    // Use provided navigation manager or create a default one
    final manager = navigationManager ??
        NavigationManager(requiredUserProperties: requiredUserProperties);

    return FutureBuilder<bool>(
      future: manager.isProfileComplete(),
      builder: (context, snapshot) {
        // Show loading indicator while checking profile completion
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data == true) {
          // Profile is complete, show the child widget
          return child;
        } else {
          // Profile is incomplete, show the completion form
          return manager.navigateToProfileCompletionScreen(context);
        }
      },
    );
  }
}
