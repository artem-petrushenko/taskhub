import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class BLoCObserver extends BlocObserver {
  @override
  void onClose(
    BlocBase<dynamic> bloc,
  ) {
    super.onClose(bloc);
    log('${bloc.runtimeType}.close()');
  }

  @override
  void onCreate(
    BlocBase<dynamic> bloc,
  ) {
    super.onCreate(bloc);
    log('${bloc.runtimeType}');
  }

  @override
  void onError(
    BlocBase<dynamic> bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    super.onError(bloc, error, stackTrace);
    log('Error: $error\n'
        'StackTrace: $stackTrace');
  }

  @override
  void onEvent(
    Bloc<dynamic, dynamic> bloc,
    Object? event,
  ) {
    super.onEvent(bloc, event);
    if (event == null) return;
    log('${bloc.runtimeType}.add(${event.runtimeType})');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    final Object? event = transition.event;
    final Object? currentState = transition.currentState;
    final Object? nextState = transition.nextState;

    if (event == null || currentState == null || nextState == null) return;
    log('${bloc.runtimeType} ${event.runtimeType}: ${currentState.runtimeType} => ${nextState.runtimeType} ');
  }
}
