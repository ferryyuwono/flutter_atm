import 'package:common/common.dart';

import '../di/di.dart' as di;

class DomainAccountConfig extends Config {
  factory DomainAccountConfig.getInstance() {
    return _instance;
  }

  DomainAccountConfig._();

  static final DomainAccountConfig _instance = DomainAccountConfig._();

  @override
  Future<bool> config() async {
    await di.configureInjection();
    return Future.value(true);
  }
}
