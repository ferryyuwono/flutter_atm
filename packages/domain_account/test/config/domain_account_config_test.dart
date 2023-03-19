import 'package:domain_account/domain_account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DomainAccountConfig', () {
    final config = DomainAccountConfig.getInstance();

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
