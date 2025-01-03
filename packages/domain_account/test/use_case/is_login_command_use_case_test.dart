import 'package:domain_account/domain_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:format/format.dart';

void main() {
  group('IsLoginCommandUseCase', () {
    final isLoginCommandUseCase = IsLoginCommandUseCase();

    setUp(() {});

    test('when execute is called and command is not match, should return unrecognized data', () async {
      // Given
      const command = 'mock';

      // When
      final result = await isLoginCommandUseCase.execute(command);

      // Then
      final expected = IsLoginCommandOutput(
        isMatchCommand: false,
        command: '\$ $command',
        isValidCommand: false,
        username: '',
        messages: [
          IsLoginCommandUseCase.unrecognizedCommand.format(command),
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and login has no parameter, should return input parameter data', () async {
      // Given
      const command = 'login';

      // When
      final result = await isLoginCommandUseCase.execute(command);

      // Then
      const expected = IsLoginCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        username: '',
        messages: [
          IsLoginCommandUseCase.missingInputParameter,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and login has too many parameter, should return too many parameter data', () async {
      // Given
      const command = 'login param1 param2';

      // When
      final result = await isLoginCommandUseCase.execute(command);

      // Then
      const expected = IsLoginCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        username: '',
        messages: [
          IsLoginCommandUseCase.tooMuchParameter,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and valid, should return valid data', () async {
      // Given
      const command = 'login mock';

      // When
      final result = await isLoginCommandUseCase.execute(command);

      // Then
      const expected = IsLoginCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: true,
        username: 'mock',
        messages: [],
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
