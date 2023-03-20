import 'package:domain_account/domain_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:format/format.dart';

void main() {
  group('IsWithdrawCommandUseCase', () {
    final isWithdrawCommandUseCase = IsWithdrawCommandUseCase();

    setUp(() {});

    test('when execute is called and command is not match, should return unrecognized data', () async {
      // Given
      const command = 'mock';

      // When
      final result = await isWithdrawCommandUseCase.execute(command);

      // Then
      final expected = IsWithdrawCommandOutput(
        isMatchCommand: false,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsWithdrawCommandUseCase.unrecognizedCommand.format(command),
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and withdraw has no parameter, should return input parameter data', () async {
      // Given
      const command = 'withdraw';

      // When
      final result = await isWithdrawCommandUseCase.execute(command);

      // Then
      const expected = IsWithdrawCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsWithdrawCommandUseCase.missingInputParameter,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and withdraw has too many parameter, should return too many parameter data', () async {
      // Given
      const command = 'withdraw param1 param2';

      // When
      final result = await isWithdrawCommandUseCase.execute(command);

      // Then
      const expected = IsWithdrawCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsWithdrawCommandUseCase.tooMuchParameter,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and withdraw amount is not decimal, should return parameter need to be decimal data', () async {
      // Given
      const command = 'withdraw mock';

      // When
      final result = await isWithdrawCommandUseCase.execute(command);

      // Then
      const expected = IsWithdrawCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsWithdrawCommandUseCase.parameterNeedToBeDecimal,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and deposit amount is less or same as zero, should return amount need greater than zero data', () async {
      // Given
      const command = 'withdraw -100';

      // When
      final result = await isWithdrawCommandUseCase.execute(command);

      // Then
      const expected = IsWithdrawCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        amount: 0,
        messages: [
          IsWithdrawCommandUseCase.amountBiggerThanZero,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and valid, should return valid data', () async {
      // Given
      const command = 'withdraw 100';

      // When
      final result = await isWithdrawCommandUseCase.execute(command);

      // Then
      const expected = IsWithdrawCommandOutput(
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
