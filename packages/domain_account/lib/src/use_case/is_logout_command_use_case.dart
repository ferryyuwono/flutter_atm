import 'package:domain_account/domain_account.dart';
import 'package:format/format.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class IsLogoutCommandUseCase {
  IsLogoutCommandUseCase();

  static const matchCommand = "logout";
  static const unrecognizedCommand = 'Unrecognized command: {0}';
  static const tooMuchParameter = 'Logout can only have 0 parameter: \$logout';

  Future<IsLogoutCommandOutput> execute(String command) async {
    final trimCommand = command.trim();
    final userCommand = '\$ $trimCommand';
    final parameters = trimCommand.split(' ');

    final isMatchCommand = trimCommand.toLowerCase().startsWith(matchCommand);
    if (!isMatchCommand) {
      return IsLogoutCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [unrecognizedCommand.format(parameters[0])],
      );
    }

    if (parameters.length > 1) {
      return IsLogoutCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [tooMuchParameter],
      );
    }

    return IsLogoutCommandOutput(
      command: userCommand,
      isMatchCommand: isMatchCommand,
      isValidCommand: true,
    );
  }
}
