import 'package:data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockData {
  final int number;
  MockData({
    this.number = 0
  });
}

class MockDataMapper extends ObjectMapper<MockData> {
  @override
  MockData mapToObject(json) {
    return json != null && json is Map<String, dynamic> ?
      MockData(number: json['number'] ?? 0) :
      MockData();
  }

  @override
  Map<String, dynamic> mapToJson(object) {
    return { 'number': object.number };
  }
}

class MockSharedPreference extends Mock implements SharedPreferences {}

void main() {
  group('SharedPreferenceClient', () {
    final preferences = MockSharedPreference();
    final sharedPreferenceClient = SharedPreferenceClient(preferences);
    final mockDataMapper = MockDataMapper();

    setUp(() {});

    test('when get object is called, should return object', () async {
      // Given
      const key = 'mock';
      const data = "{ 'number': 1 }";

      // When
      when(() => preferences.getString(key)).thenReturn(data);
      final result = await sharedPreferenceClient.getObject(
        key: key,
        mapper: mockDataMapper
      );

      // Expect
      final expected = MockData(number: 1);
      expect(result, expected);
    });
    test('when set object is called, should return true', () async {
      // Given
      const key = 'mock';
      final object = MockData(number: 1);
      const objectJson = "{ 'number': 1 }";

      // When
      when(() => preferences.setString(key, objectJson))
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
