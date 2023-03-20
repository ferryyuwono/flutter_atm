import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/withdraw_input_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WithdrawInputMapper', () {
    final withdrawInputMapper = WithdrawInputMapper();

    setUp(() {});

    test('when map WithdrawInput, should return WithdrawRequest', () async {
      // Given
      const input = WithdrawInput(
        amount: 100,
      );

      // When
      final result = withdrawInputMapper.map(input);

      // Then
      const expected = WithdrawRequest(
        amount: 100,
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
