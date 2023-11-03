import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:taskhub/src/app.dart';

import 'package:taskhub/firebase_options.dart';
import 'package:taskhub/src/common/widget/navigation/navigation.dart';

Future<void> main() async => runZonedGuarded(() async {
      final navigation = Navigation();
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      runApp(App(
        navigation: navigation,
      ));
    },
        (error, stack) =>
            FirebaseCrashlytics.instance.recordError(error, stack));
