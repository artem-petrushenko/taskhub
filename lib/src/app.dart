import 'package:flutter/material.dart';

import 'package:taskhub/src/common/widget/navigation/navigation.dart';

class App extends StatelessWidget {
  final Navigation navigation;

  const App({
    Key? key,
    required this.navigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: TaskHubTheme.appTheme,
      routes: navigation.routes,
      onGenerateRoute: navigation.onGenerateRoute,
      initialRoute: RouteNames.tasks,
    );
  }
}

class TaskHubTheme {
  static ThemeData get appTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: Colors.amber,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0.0,
        focusElevation: 0.0,
        hoverElevation: 0.0,
        disabledElevation: 0.0,
        highlightElevation: 0.0,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 0.0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.amber.shade50,
        filled: true,
        errorBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
          borderSide: BorderSide(
            width: 2.0,
            color: Colors.red.shade900,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
          borderSide: BorderSide(
            width: 2.0,
            color: Colors.red.shade900,
          ),
        ),
        disabledBorder: UnderlineInputBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
          borderSide: BorderSide(
            width: 2.0,
            color: Colors.red.shade900,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
        border: const UnderlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
