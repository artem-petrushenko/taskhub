import 'package:flutter/material.dart';

import 'package:taskhub/src/common/widget/navigation/navigation.dart';

import 'package:taskhub/src/common/widget/theme/dark_theme.dart';
import 'package:taskhub/src/common/widget/theme/light_theme.dart';

class App extends StatelessWidget {
  final Navigation navigation;

  const App({
    Key? key,
    required this.navigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: LightTheme.themeData,
      darkTheme: DarkTheme.themeData,
      routes: navigation.routes,
      onGenerateRoute: navigation.onGenerateRoute,
      initialRoute: RouteNames.tasks,
    );
  }
}
