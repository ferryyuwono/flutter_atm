import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';

class TestConfig extends Config {
  @override
  Future<bool> config() {
    return Future.value(true);
  }
}

void main() {
  group('Config', () {
    final config = TestConfig();

    setUp(() {});

    test('when init is called, should return config function', () async {
      // When
      final result = await config.init();

      // Expect
      expect(result, true);
    });

    tearDown(() {});
  });
}
