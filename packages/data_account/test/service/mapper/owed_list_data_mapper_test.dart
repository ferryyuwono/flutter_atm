import 'package:data_account/data_account.dart';
import 'package:data_account/src/service/mapper/owed_list_data_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OwedListDataMapper', () {
    final owedListDataMapper = OwedListDataMapper();

    setUp(() {});

    test('when mapToObject with null response, should return empty list data', () async {
      // Given
      const response = null;

      // When
      final result = owedListDataMapper.mapToObject(response);

      // Then
      const expected = OwedListData();
      expect(result, expected);
    });
    test('when mapToObject with invalid array response, should return empty list data', () async {
      // Given
      const response = '[]';

      // When
      final result = owedListDataMapper.mapToObject(response);

      // Then
      const expected = OwedListData();
      expect(result, expected);
    });
    test('when mapToObject with invalid string response, should return empty list data', () async {
      // Given
      const response = 'asd';

      // When
      final result = owedListDataMapper.mapToObject(response);

      // Then
      const expected = OwedListData();
      expect(result, expected);
    });
    test('when mapToObject with invalid object response, should return empty list data', () async {
      // Given
      const response = '{}';

      // When
      final result = owedListDataMapper.mapToObject(response);

      // Then
      const expected = OwedListData();
      expect(result, expected);
    });
    test('when mapToObject with valid response, should return valid list data', () async {
      // Given
      const response = '{"owed_list":[{"from":"mock","to":"mock2","amount":100}]}';

      // When
      final result = owedListDataMapper.mapToObject(response);

      // Then
      const expected = OwedListData(
        owedList: [
          OwedData(
            from: 'mock',
            to: 'mock2',
            amount: 100,
          ),
        ],
      );
      expect(result, expected);
    });
    test('when mapToJson, should return valid json', () async {
      // Given
      const response = OwedListData(
        owedList: [
          OwedData(
            from: 'mock',
            to: 'mock2',
            amount: 100,
          ),
        ],
      );

      // When
      final result = owedListDataMapper.mapToJsonString(response);

      // Then
      const expected = '{"owed_list":[{"from":"mock","to":"mock2","amount":100}]}';
      expect(result, expected);
    });

    tearDown(() {});
  });
}
