import 'package:domain_account/domain_account.dart';
import 'package:format/format.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class IsWithdrawCommandUseCase {
  IsWithdrawCommandUseCase();

  static const matchCommand = "withdraw";
  static const unrecognizedCommand = 'Unrecognized command: {0}';
  static const missingInputParameter = 'Please input withdraw parameter';
  static const tooMuchParameter = 'Withdraw can only have 1 parameter: \$withdraw [amount]';
  static const parameterNeedToBeDecimal = 'Withdraw amount can only be decimal number';
  static const amountBiggerThanZero = 'Withdraw amount need to be bigger than 0';

  Future<IsWithdrawCommandOutput> execute(String command) async {
    final trimCommand = command.trim();
    final userCommand = '\$ $trimCommand';
    final parameters = trimCommand.split(' ');

    final isMatchCommand = trimCommand.toLowerCase().startsWith(matchCommand);
    if (!isMatchCommand) {
      return IsWithdrawCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [unrecognizedCommand.format(parameters[0])],
      );
    }

    if (parameters.length == 1) {
      return IsWithdrawCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [missingInputParameter],
      );
    }

    if (parameters.length > 2) {
      return IsWithdrawCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [tooMuchParameter],
      );
    }

    final parameter = parameters[1];
    final int amount;
    try {
      amount = int.parse(parameter);
    } catch (_) {
      return IsWithdrawCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [parameterNeedToBeDecimal],
      );
    }

    if (amount <= 0) {
      return IsWithdrawCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [amountBiggerThanZero],
      );
    }

    return IsWithdrawCommandOutput(
      command: userCommand,
      isMatchCommand: isMatchCommand,
      isValidCommand: true,
      amount: amount,
    );
  }
}
