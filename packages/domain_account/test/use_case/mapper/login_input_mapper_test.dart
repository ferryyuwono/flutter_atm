import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/login_input_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginInputMapper', () {
    final loginInputMapper = LoginInputMapper();

    setUp(() {});

    test('when map LoginInput, should return LoginRequest', () async {
      // Given
      const input = LoginInput(
        username: 'mock',
      );

      // When
      final result = loginInputMapper.map(input);

      // Then
      const expected = LoginRequest(
        username: 'mock',
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
