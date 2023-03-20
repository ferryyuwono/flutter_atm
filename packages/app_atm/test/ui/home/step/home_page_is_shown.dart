import 'package:app_atm/app_atm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:initializer/initializer.dart';

class MockAppConfig extends ApplicationConfig {
  factory MockAppConfig.getInstance() {
    return _instance;
  }

  MockAppConfig._();

  static final MockAppConfig _instance = MockAppConfig._();

  @override
  Future<bool> config() async {
    GetIt.instance.registerSingleton<AppRouter>(AppRouter());
    return Future.value(true);
  }
}

Future<void> homePageIsShown(WidgetTester tester) async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer(MockAppConfig.getInstance()).init();
}
