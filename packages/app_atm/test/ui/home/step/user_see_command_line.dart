import 'dart:async';

import 'package:app_atm/app_atm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

class MockHomeBloc extends HomeBloc {
  MockHomeBloc() : super(HomeState()) {
    on<HomeTypeCommandEvent>(
      _onHomeTypeCommandEvent
    );

    on<HomeSendCommandEvent>(
      _onHomeSendCommandEvent
    );
  }

  FutureOr<void> _onHomeTypeCommandEvent(HomeTypeCommandEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      typedCommand: event.command,
    ));
  }

  FutureOr<void> _onHomeSendCommandEvent(HomeSendCommandEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      logList: ['\$ ${event.command}'],
      typedCommand: '',
    ));
  }
}

Future<void> userSeeCommandLine(WidgetTester tester) async {
  GetIt.instance.registerSingleton<HomeBloc>(MockHomeBloc());

  final appRouter = GetIt.instance.get<AppRouter>();
  final app = MaterialApp.router(
    routerDelegate: appRouter.delegate(
      initialRoutes: [ const HomeRoute() ]
    ),
    routeInformationParser: appRouter.defaultRouteParser()
  );
  await tester.pumpWidget(app);
  await tester.pump();

  expect(find.byKey(const Key(HomePage.screenKey)), findsOneWidget);
  await tester.pumpAndSettle();
}
