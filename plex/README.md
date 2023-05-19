<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

1. Create boilerplate code for an **Application**
2. Built in login screen
3. Built in User session manager
4. Free useful widgets
5. Free useful utilities
6. Built in screens and pages
7. Builtin form builder from model class

## Getting started

Install the `plex` in your application.

## Usage

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    PlexApp(
      appLogo: Image.asset(imageHosiery),
      title: "Plex App",
      initialRoute: 'home',
      useAuthorization: true,
      onLogin: (email, pass) async {
        var user = PlexUser(<String, dynamic>{"Name": "Abdur Rahman"});
        return user;
      },
      routes: [
        PlexRoute("home", const HomeScreen()),
      ],
    ),
  );
}
```
