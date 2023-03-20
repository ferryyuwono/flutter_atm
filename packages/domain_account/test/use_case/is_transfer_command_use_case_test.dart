import 'package:domain_account/domain_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:format/format.dart';

void main() {
  group('IsTransferCommandUseCase', () {
    final isTransferCommandUseCase = IsTransferCommandUseCase();

    setUp(() {});

    test('when execute is called and command is not match, should return unrecognized data', () async {
      // Given
      const command = 'mock';

      // When
      final result = await isTransferCommandUseCase.execute(command);

      // Then
      final expected = IsTransferCommandOutput(
        isMatchCommand: false,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsTransferCommandUseCase.unrecognizedCommand.format(command),
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and transfer has no parameter, should return input parameter data', () async {
      // Given
      const command = 'transfer';

      // When
      final result = await isTransferCommandUseCase.execute(command);

      // Then
      const expected = IsTransferCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsTransferCommandUseCase.missingInputParameter,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and transfer has too many parameter, should return too many parameter data', () async {
      // Given
      const command = 'transfer param1 param2 param3';

      // When
      final result = await isTransferCommandUseCase.execute(command);

      // Then
      const expected = IsTransferCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsTransferCommandUseCase.tooMuchParameter,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and transfer amount is not decimal, should return parameter need to be decimal data', () async {
      // Given
      const command = 'transfer mock mock';

      // When
      final result = await isTransferCommandUseCase.execute(command);

      // Then
      const expected = IsTransferCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsTransferCommandUseCase.parameterNeedToBeDecimal,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and deposit amount is less or same as zero, should return amount need greater than zero data', () async {
      // Given
      const command = 'transfer mock -100';

      // When
      final result = await isTransferCommandUseCase.execute(command);

      // Then
      const expected = IsTransferCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsTransferCommandUseCase.amountBiggerThanZero,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and valid, should return valid data', () async {
      // Given
      const command = 'transfer mock 100';

      // When
      final result = await isTransferCommandUseCase.execute(command);

      // Then
      const expected = IsTransferCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: true,
        transferTo: 'mock',
        amount: 100,
        messages: [],
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
