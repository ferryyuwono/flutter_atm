import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/logout_input_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LogoutInputMapper', () {
    final logoutInputMapper = LogoutInputMapper();

    setUp(() {});

    test('when map LogoutInput, should return LogoutRequest', () async {
      // Given
      const input = LogoutInput();

      // When
      final result = logoutInputMapper.map(input);

      // Then
      const expected = LogoutRequest();
      expect(result, expected);
    });

    tearDown(() {});
  });
}
