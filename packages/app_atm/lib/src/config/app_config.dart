import 'package:app_atm/app_atm.dart';
import 'package:initializer/initializer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di/di.dart' as di;

class AppConfig extends ApplicationConfig {
  factory AppConfig.getInstance() {
    return _instance;
  }

  AppConfig._();

  static final AppConfig _instance = AppConfig._();

  @override
  Future<bool> config() async {
    await di.configureInjection();
    di.getIt.registerSingleton<SharedPreferences>(
        await SharedPreferences.getInstance()
    );
    di.getIt.registerSingleton<AppRouter>(AppRouter());
    return Future.value(true);
  }
}
