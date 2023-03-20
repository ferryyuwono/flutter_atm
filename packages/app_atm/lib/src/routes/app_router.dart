import 'package:auto_route/auto_route.dart';
import 'package:app_atm/app_atm.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomePage),
  ],
)
class $AppRouter {}
