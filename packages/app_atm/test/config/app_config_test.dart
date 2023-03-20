import 'package:flutter_test/flutter_test.dart';
import 'package:app_atm/src/config/app_config.dart';

void main() {
  group('AppConfig', () {
    final config = AppConfig.getInstance();

    setUp(() {});

    test('when init is called, should return future true', () async {
      // When
      final result = await config.init();

      // Expect
      expect(result, true);
    });

    tearDown(() {});
  });
}
