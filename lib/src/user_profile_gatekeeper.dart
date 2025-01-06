import 'package:flutter/material.dart';
import 'package:user_profile_gatekeeper/src/user_property.dart';
import 'navigation_manager.dart';

/// A widget that ensures all required user profile properties are completed
/// before displaying its child widget.
///
/// If the profile is incomplete, it will display a profile completion form
/// instead of the child widget.
class UserProfileGatekeeper extends StatefulWidget {
  final List<UserProperty> requiredUserProperties;
  final NavigationManager? navigationManager;
  final Widget child;

  const UserProfileGatekeeper({
    super.key,
    required this.requiredUserProperties,
    this.navigationManager,
    required this.child,
  });

  @override
  UserProfileGatekeeperState createState() => UserProfileGatekeeperState();
}

class UserProfileGatekeeperState extends State<UserProfileGatekeeper> {
  late final NavigationManager navigationManager;

  @override
  void initState() {
    super.initState();
    navigationManager = widget.navigationManager ??
        NavigationManager(
            requiredUserProperties: widget.requiredUserProperties);
    _checkProfile(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkProfile(BuildContext context) async {
    bool isComplete = await navigationManager.isProfileComplete();
    if (!isComplete) {
      context.mounted
          ? navigationManager.navigateToProfileCompletionScreen(context)
          : throw Exception('UserProfileGatekeeper disposed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
