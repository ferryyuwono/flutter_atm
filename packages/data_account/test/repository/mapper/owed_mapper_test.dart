import 'package:data_account/data_account.dart';
import 'package:data_account/src/repository/mapper/owed_mapper.dart';
import 'package:domain_account/domain_account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OwedMapper', () {
    final owedMapper = OwedMapper();

    setUp(() {});

    test('when map data response, should return model', () async {
      // Given
      const response = OwedData(
        from: 'mock',
        to: 'mock2',
        amount: 100,
      );

      // When
      final result = owedMapper.map(response);

      // Then
      const expected = Owed(
        from: 'mock',
        to: 'mock2',
        amount: 100,
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
