import 'package:domain_account/domain_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:format/format.dart';

void main() {
  group('IsDepositCommandUseCase', () {
    final isDepositCommandUseCase = IsDepositCommandUseCase();

    setUp(() {});

    test('when execute is called and command is not match, should return unrecognized data', () async {
      // Given
      const command = 'mock';

      // When
      final result = await isDepositCommandUseCase.execute(command);

      // Then
      final expected = IsDepositCommandOutput(
        isMatchCommand: false,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsDepositCommandUseCase.unrecognizedCommand.format(command),
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and deposit has no parameter, should return input parameter data', () async {
      // Given
      const command = 'deposit';

      // When
      final result = await isDepositCommandUseCase.execute(command);

      // Then
      const expected = IsDepositCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsDepositCommandUseCase.missingInputParameter,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and deposit has too many parameter, should return too many parameter data', () async {
      // Given
      const command = 'deposit param1 param2';

      // When
      final result = await isDepositCommandUseCase.execute(command);

      // Then
      const expected = IsDepositCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsDepositCommandUseCase.tooMuchParameter,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and deposit amount is not decimal, should return parameter need to be decimal data', () async {
      // Given
      const command = 'deposit mock';

      // When
      final result = await isDepositCommandUseCase.execute(command);

      // Then
      const expected = IsDepositCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsDepositCommandUseCase.parameterNeedToBeDecimal,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and valid, should return valid data', () async {
      // Given
      const command = 'deposit 100';

      // When
      final result = await isDepositCommandUseCase.execute(command);

      // Then
      const expected = IsDepositCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: true,
        amount: 100,
        messages: [],
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
