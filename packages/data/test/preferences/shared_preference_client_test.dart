import 'dart:convert';

import 'package:data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockData {
  final int number;
  MockData({
    this.number = 0
  });

  String toJson() {
    return '{ "number": $number }';
  }
}

class MockDataMapper extends ObjectMapper<MockData> {
  @override
  MockData mapToObject(String? jsonString) {
    const decoder = JsonDecoder();
    final json = decoder.convert(jsonString ?? '{}');
    return json != null && json is Map<String, dynamic> ?
      MockData(number: json['number'] ?? 0) :
      MockData();
  }

  @override
  String mapToJsonString(object) {
    return object.toJson();
  }
}

class MockSharedPreference extends Mock implements SharedPreferences {}

void main() {
  group('SharedPreferenceClient', () {
    final preferences = MockSharedPreference();
    final sharedPreferenceClient = SharedPreferenceClient(preferences);
    final mockDataMapper = MockDataMapper();

    setUp(() {});

    test('when get object is called and null, should return object', () async {
      // Given
      const key = 'mock';

      // When
      when(() => preferences.getString(key)).thenReturn(null);
      final result = await sharedPreferenceClient.getObject(
          key: key,
          mapper: mockDataMapper
      );

      // Expect
      final expected = MockData();
      expect(result.number, expected.number);
    });
    test('when get object is called and not null, should return object', () async {
      // Given
      const key = 'mock';
      const data = '{ "number": 1 }';

      // When
      when(() => preferences.getString(key)).thenReturn(data);
      final result = await sharedPreferenceClient.getObject(
        key: key,
        mapper: mockDataMapper
      );

      // Expect
      final expected = MockData(number: 1);
      expect(result.number, expected.number);
    });
    test('when set object is called, should return true', () async {
      // Given
      const key = 'mock';
      final object = MockData(number: 1);
      const jsonString = '{ "number": 1 }';

      // When
      when(() => preferences.setString(key, jsonString))
        .thenAnswer((_) => Future.value(true));
      final result = await sharedPreferenceClient.setObject(
        key: key,
        object: object,
        mapper: mockDataMapper,
      );

      // Expect
      expect(result, true);
    });

    tearDown(() {});
  });
}
