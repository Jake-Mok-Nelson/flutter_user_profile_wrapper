# user_profile_gatekeeper

Ensure that your users have provided necessary profile information before they can access your app.

## Installation

```yaml
dependencies:
  user_profile_gatekeeper: ^0.0.1
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


