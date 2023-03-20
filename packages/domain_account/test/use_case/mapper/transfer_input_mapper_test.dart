import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/transfer_input_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransferInputMapper', () {
    final transferInputMapper = TransferInputMapper();

    setUp(() {});

    test('when map TransferInput, should return TransferRequest', () async {
      // Given
      const input = TransferInput(
        transferTo: 'mock',
        amount: 100,
      );

      // When
      final result = transferInputMapper.map(input);

      // Then
      const expected = TransferRequest(
        transferTo: 'mock',
        amount: 100,
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
