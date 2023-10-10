import 'package:flutter/material.dart';

import 'package:taskhub/src/common/widget/navigation/navigation.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required Navigation navigation,
  }) : _navigation = navigation;

  final Navigation _navigation;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.amber,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 0.0,
          focusElevation: 0.0,
          hoverElevation: 0.0,
          disabledElevation: 0.0,
          highlightElevation: 0.0,
        ),
      ),
      routes: _navigation.routes,
      onGenerateRoute: _navigation.onGenerateRoute,
      initialRoute: RouteNames.tasks,
    );
  }
}
