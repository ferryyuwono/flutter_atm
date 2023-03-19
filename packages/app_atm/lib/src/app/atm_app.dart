import 'package:flutter/material.dart';
import 'package:app_atm/app_atm.dart';
import 'package:get_it/get_it.dart';

class AtmApp extends StatefulWidget {
  const AtmApp({Key? key}) : super(key: key);

  @override
  State<AtmApp> createState() => _AtmAppState();
}

class _AtmAppState extends State<AtmApp> {
  final _appRouter = GetIt.instance.get<AppRouter>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(
        initialRoutes: [ const HomeRoute() ]
      ),
      routeInformationParser: _appRouter.defaultRouteParser()
    );
  }
}
