import 'package:data_account/data_account.dart';
import 'package:data_account/src/service/mapper/account_list_data_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccountListDataMapper', () {
    final accountListDataMapper = AccountListDataMapper();

    setUp(() {});

    test('when mapToObject with null response, should return empty paged list', () async {
      // Given
      const response = null;

      // When
      final result = accountListDataMapper.mapToObject(response);

      // Then
      const expected = AccountListData();
      expect(result, expected);
    });
    test('when mapToObject with invalid array response, should return empty paged list', () async {
      // Given
      const response = '[]';

      // When
      final result = accountListDataMapper.mapToObject(response);

      // Then
      const expected = AccountListData();
      expect(result, expected);
    });
    test('when mapToObject with invalid string response, should return empty paged list', () async {
      // Given
      const response = 'asd';

      // When
      final result = accountListDataMapper.mapToObject(response);

      // Then
      const expected = AccountListData();
      expect(result, expected);
    });
    test('when mapToObject with invalid object response, should return empty paged list', () async {
      // Given
      const response = '{}';

      // When
      final result = accountListDataMapper.mapToObject(response);

      // Then
      const expected = AccountListData();
      expect(result, expected);
    });
    test('when mapToObject with valid response, should return valid paged list', () async {
      // Given
      const response = '{"accounts":[{"id":1,"username":"mock","balance":100}]}';

      // When
      final result = accountListDataMapper.mapToObject(response);

      // Then
      const expected = AccountListData(
        accounts: [
          AccountData(
            id: 1,
            username: 'mock',
            balance: 100
          ),
        ],
      );
      expect(result, expected);
    });
    test('when mapToJson, should return valid json', () async {
      // Given
      const response = AccountListData(
        accounts: [
          AccountData(
              id: 1,
              username: 'mock',
              balance: 100
          ),
        ],
      );

      // When
      final result = accountListDataMapper.mapToJsonString(response);

      // Then
      const expected = '{"accounts":[{"id":1,"username":"mock","balance":100}]}';
      expect(result, expected);
    });

    tearDown(() {});
  });
}
