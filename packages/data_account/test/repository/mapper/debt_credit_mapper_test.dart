import 'package:data_account/data_account.dart';
import 'package:data_account/src/repository/mapper/debt_credit_mapper.dart';
import 'package:data_account/src/repository/mapper/owed_mapper.dart';
import 'package:domain_account/domain_account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DebtCreditMapper', () {
    final owedMapper = OwedMapper();
    final debtCreditMapper = DebtCreditMapper(owedMapper);

    setUp(() {});

    test('when map data response is empty, should return model', () async {
      // Given
      const username = 'mock';
      const input = OwedListData();

      // When
      final result = debtCreditMapper.map(input, username);

      // Then
      const expected = DebtCredit(
        debts: [],
        credits: [],
      );
      expect(result, expected);
    });
    test('when map data response, should return model', () async {
      // Given
      const username = 'mock';
      const input = OwedListData(
        owedList: [
          OwedData(
            from: 'mock',
            to: 'mock2',
            amount: 100,
          ),
        ],
      );

      // When
      final result = debtCreditMapper.map(input, username);

      // Then
      const expected = DebtCredit(
        debts: [
          Owed(
            from: 'mock',
            to: 'mock2',
            amount: 100,
          ),
        ],
        credits: [],
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
