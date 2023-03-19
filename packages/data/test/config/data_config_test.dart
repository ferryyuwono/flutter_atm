import 'package:data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DataConfig', () {
    final config = DataConfig.getInstance();

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
