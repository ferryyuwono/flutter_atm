import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/deposit_input_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DepositInputMapper', () {
    final depositInputMapper = DepositInputMapper();

    setUp(() {});

    test('when map DepositInput, should return DepositRequest', () async {
      // Given
      const input = DepositInput(
        amount: 100,
      );

      // When
      final result = depositInputMapper.map(input);

      // Then
      const expected = DepositRequest(
        amount: 100,
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
