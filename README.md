# user_profile_gatekeeper

Live demo: [https://jake-mok-nelson.github.io/user_profile_gatekeeper/](https://jake-mok-nelson.github.io/user_profile_gatekeeper/)

Ensure that your users have provided necessary profile information before they can access your app.

If you require that a user provides a property (e.g. name, email, phone number) as a key part of your apps functionality, you can use this package to ensure that the user has provided that information before they navigate.

### When to use this

- Ensure user's have completed all required information for your app to function
- Validate user input before allowing them to navigate to ensure all required data is present
- Ensure that existing required user properties aren't removed or changed to something that doesn't meet your requirements

### When not to use this

- If you don't have any required user properties outside of the mandatory ones from most providers (e.g. id, email, password)
- If you don't need to validate user input before allowing them to navigate
- If you don't need to ensure that existing required user properties aren't removed or changed
- As a replacement for a full user profile system (e.g. user settings, user profile, etc.)
- To store sensitive information (e.g. SSN, credit card information, passwords, etc.


## Installation

```yaml
dependencies:
  user_profile_gatekeeper: ^0.1.1
```

## Usage

Configure your required user properties using the `UserProperty` class:
```dart
UserProperty(
  label: 'displayName',
  get: () async {
    // Call your APIs here to get the value of a property and see if it's set
    // final user = FirebaseAuth.instance.currentUser;
    // return user?.displayName ?? '';
    return Future.value('John');
  },
  // Validate that the value is not empty and is between 2 and 50 characters
  // Validation occurs on load and when the user tries to save
  validate: (String value) => switch (value) {
    String s when s.isEmpty => false,
    String s when s.length < 2 || s.length > 50 => false,

    // Is AlphaNumeric
    String s when !RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(s) => false,
    _ => true,
  },
  save: (String value) async {
    // Store the new value in a persistent place to proceed with navigation
    // final user = FirebaseAuth.instance.currentUser;
    // await user?.updateDisplayName(value);
  },
),
```

Wrap your app with `UserProfileGatekeeper` to ensure necessary profile data is collected:
```dart
UserProfileGatekeeper(
  requiredUserProperties: [...],
  child: HomeScreen(),
)
```
