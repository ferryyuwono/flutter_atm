import 'package:data_account/data_account.dart';
import 'package:data_account/src/repository/mapper/account_mapper.dart';
import 'package:domain_account/domain_account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccountMapper', () {
    final accountMapper = AccountMapper();

    setUp(() {});

    test('when map data response, should return model', () async {
      // Given
      const response = AccountData(
        id: 1,
        username: 'mock',
        balance: 100,
      );

      // When
      final result = accountMapper.map(response);

      // Then
      const expected = Account(
        id: 1,
        username: 'mock',
        balance: 100,
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
