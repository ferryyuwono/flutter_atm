import 'package:domain_account/domain_account.dart';
import 'package:format/format.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class IsLoginCommandUseCase {
  IsLoginCommandUseCase();

  static const matchCommand = "login";
  static const unrecognizedCommand = 'Unrecognized command: {0}';
  static const missingInputParameter = 'Please input login parameter: \$login [username]';
  static const tooMuchParameter = 'Login can only have 1 parameter';

  Future<IsLoginCommandOutput> execute(String command) async {
    final trimCommand = command.trim();
    final userCommand = '\$ $trimCommand';
    final parameters = trimCommand.split(' ');

    final isMatchCommand = trimCommand.toLowerCase().startsWith(matchCommand);
    if (!isMatchCommand) {
      return IsLoginCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [unrecognizedCommand.format(parameters[0])],
      );
    }

    if (parameters.length == 1) {
      return IsLoginCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [missingInputParameter],
      );
    }

    if (parameters.length > 2) {
      return IsLoginCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [tooMuchParameter],
      );
    }

    return IsLoginCommandOutput(
      command: userCommand,
      isMatchCommand: isMatchCommand,
      isValidCommand: true,
      username: parameters[1],
    );
  }
}
