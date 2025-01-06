import 'package:flutter/material.dart';
import 'package:flutter_user_profile_wrapper/src/user_property.dart';
import 'navigation_manager.dart';

class ProfileWrapper extends StatelessWidget {
  final Widget child;
  final List<UserProperty> requiredUserProperties;
  final NavigationManager? navigationManager;

  const ProfileWrapper({
    super.key,
    required this.child,
    required this.requiredUserProperties,
    this.navigationManager,
  });

  @override
  Widget build(BuildContext context) {
    final manager = navigationManager ??
        NavigationManager(requiredUserProperties: requiredUserProperties);
    return FutureBuilder<bool>(
      future: manager.isProfileComplete(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data == true) {
          return child;
        } else {
          return manager.navigateToProfileCompletionScreen(context);
        }
      },
    );
  }
}
