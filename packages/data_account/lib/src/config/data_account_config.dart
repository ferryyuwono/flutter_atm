import 'package:common/common.dart';

import '../di/di.dart' as di;

class DataAccountConfig extends Config {
  DataAccountConfig._();

  factory DataAccountConfig.getInstance() {
    return _instance;
  }

  static final DataAccountConfig _instance = DataAccountConfig._();

  @override
  Future<bool> config() async {
    await di.configureInjection();
    return Future.value(true);
  }
}
