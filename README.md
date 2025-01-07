# user_profile_gatekeeper

Ensure that your users have provided necessary profile information before they can access your app.

If you require that a user provides a property (e.g. name, email, phone number) as a key part of your apps functionality, you can use this package to ensure that the user has provided that information before they navigate.

This package is inspired by the [user_profile](https://pub.dev/packages/user_profile) package, but with a focus on ensuring that the user has provided the necessary information before they can access the app.

## Installation

```yaml
dependencies:
  user_profile_gatekeeper: ^0.1.0
```

## Usage

Configure your required user properties using the `UserProperty` class:
```dart
UserProperty(
  label: 'Name', // Displayed label
  get: () => 'John Doe', // A function that returns the current value
  validate: (value) => value.isNotEmpty, // A function that acts as a validator for the value
  save: (value) => {/* save new value */}, // A function that saves the new value to a persistent storage
)
```

Wrap your app with `UserProfileGatekeeper` to ensure necessary profile data is collected:
```dart
UserProfileGatekeeper(
  requiredUserProperties: [...],
  child: HomeScreen(),
)
```
