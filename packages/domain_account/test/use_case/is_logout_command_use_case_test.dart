import 'package:domain_account/domain_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:format/format.dart';

void main() {
  group('IsLogoutCommandUseCase', () {
    final isLogoutCommandUseCase = IsLogoutCommandUseCase();

    setUp(() {});

    test('when execute is called and command is not match, should return unrecognized data', () async {
      // Given
      const command = 'mock';

      // When
      final result = await isLogoutCommandUseCase.execute(command);

      // Then
      final expected = IsLogoutCommandOutput(
        isMatchCommand: false,
        command: '\$ $command',
        isValidCommand: false,
        username: '',
        messages: [
          IsLogoutCommandUseCase.unrecognizedCommand.format(command),
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and logout has no parameter, should return input parameter data', () async {
      // Given
      const command = 'logout';

      // When
      final result = await isLogoutCommandUseCase.execute(command);

      // Then
      const expected = IsLogoutCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        username: '',
        messages: [
          IsLogoutCommandUseCase.inputParameterCommand,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and logout has too many parameter, should return too many parameter data', () async {
      // Given
      const command = 'logout param1 param2';

      // When
      final result = await isLogoutCommandUseCase.execute(command);

      // Then
      const expected = IsLogoutCommandOutput(
        isMatchCommand: true,
        command: '\$ $command',
        isValidCommand: false,
        username: '',
        messages: [
          IsLogoutCommandUseCase.tooMuchParameterCommand,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and valid, should return valid data', () async {
      // Given
      const command = 'logout mock';

      // When
      final result = await isLogoutCommandUseCase.execute(command);

      // Then
      const expected = IsLogoutCommandOutput(
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
