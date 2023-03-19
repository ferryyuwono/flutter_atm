import 'package:common/common.dart';
import 'package:data/data.dart';
import 'package:domain_account/domain_account.dart';
import 'package:data_account/data_account.dart';

abstract class ApplicationConfig extends Config {}

class AppInitializer {
  AppInitializer(this._applicationConfig);

  final ApplicationConfig _applicationConfig;
  bool isInitialized = false;

  Future<bool> init() async {
    await DataConfig.getInstance().init();
    await DataAccountConfig.getInstance().init();
    await DomainAccountConfig.getInstance().init();
    await _applicationConfig.init();
    return Future.value(true);
  }
}
