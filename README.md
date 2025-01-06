# flutter_user_profile_wrapper

Handle display of the user profile and the checking of mandatory user properties

## Usage

To use the `ProfileWrapper` class, follow these steps:

1. Define required user properties.
2. Get user properties.
3. Validate user properties.
4. Save user properties.
5. Implement navigation logic.

### Defining Required User Properties

To define required user properties, use the `defineProperty` method of the `UserPropertyManager` class:

```dart
UserPropertyManager userPropertyManager = UserPropertyManager(
  getPropertyFunction: (key) {
    // Implement your logic to get the property
  },
  savePropertyFunction: (key, value) {
    // Implement your logic to save the property
  },
);
userPropertyManager.defineProperty('name', 'John Doe');
userPropertyManager.defineProperty('email', 'john.doe@example.com');
```

### Getting User Properties

To get user properties, use the `getProperty` method of the `UserPropertyManager` class:

```dart
String name = userPropertyManager.getProperty('name');
String email = userPropertyManager.getProperty('email');
```

### Validating User Properties

To validate user properties, use the `validateProperty` method of the `UserPropertyManager` class:

```dart
bool isNameValid = userPropertyManager.validateProperty('name', (value) => value != null && value.isNotEmpty);
bool isEmailValid = userPropertyManager.validateProperty('email', (value) => value != null && value.contains('@'));
```

### Saving User Properties

To save user properties, use the `saveProperty` method of the `UserPropertyManager` class:

```dart
userPropertyManager.saveProperty('name', 'John Doe');
userPropertyManager.saveProperty('email', 'john.doe@example.com');
```

### Navigation Logic

To implement the navigation logic, use the `ProfileWrapper` and `NavigationManager` classes:

```dart
NavigationManager navigationManager = NavigationManager(userPropertyManager: userPropertyManager);

ProfileWrapper(
  child: YourChildWidget(),
  userPropertyManager: userPropertyManager,
  navigationManager: navigationManager,
);
```

The `ProfileWrapper` class will check if the user profile is complete and navigate to the appropriate screen accordingly.
