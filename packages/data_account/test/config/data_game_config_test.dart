import 'package:data_account/data_account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DataGameConfig', () {
    final config = DataAccountConfig.getInstance();

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
