library flutter_user_profile_wrapper;

import 'package:flutter/material.dart';
import 'src/user_property_manager.dart';
import 'src/navigation_manager.dart';

class ProfileWrapper extends StatelessWidget {
  final Widget child;
  final UserPropertyManager userPropertyManager;
  final NavigationManager navigationManager;

  ProfileWrapper({
    required this.child,
    required this.userPropertyManager,
    required this.navigationManager,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: navigationManager.isProfileComplete(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data == true) {
          return child;
        } else {
          return navigationManager.navigateToProfileCompletionScreen(context);
        }
      },
    );
  }
}
