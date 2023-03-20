import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/get_debt_credit_input_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetDebtCreditInputMapper', () {
    final getDebtCreditInputMapper = GetDebtCreditInputMapper();

    setUp(() {});

    test('when map LoginInput, should return GetDebtCreditRequest', () async {
      // Given
      const input = LoginInput(
        username: 'mock',
      );

      // When
      final result = getDebtCreditInputMapper.map(input);

      // Then
      const expected = GetDebtCreditRequest(
        username: 'mock',
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
