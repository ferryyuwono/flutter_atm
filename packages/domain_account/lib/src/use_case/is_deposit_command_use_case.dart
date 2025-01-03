import 'package:domain_account/domain_account.dart';
import 'package:format/format.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class IsDepositCommandUseCase {
  IsDepositCommandUseCase();

  static const matchCommand = "deposit";
  static const unrecognizedCommand = 'Unrecognized command: {0}';
  static const missingInputParameter = 'Please input deposit parameter';
  static const tooMuchParameter = 'Deposit can only have 1 parameter: \$transfer [amount]';
  static const parameterNeedToBeDecimal = 'Deposit amount can only be decimal number';
  static const amountBiggerThanZero = 'Deposit amount need to be bigger than 0';

  Future<IsDepositCommandOutput> execute(String command) async {
    final trimCommand = command.trim();
    final userCommand = '\$ $trimCommand';
    final parameters = trimCommand.split(' ');

    final isMatchCommand = trimCommand.toLowerCase().startsWith(matchCommand);
    if (!isMatchCommand) {
      return IsDepositCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [unrecognizedCommand.format(parameters[0])],
      );
    }

    if (parameters.length == 1) {
      return IsDepositCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [missingInputParameter],
      );
    }

    if (parameters.length > 2) {
      return IsDepositCommandOutput(
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
      return IsDepositCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [parameterNeedToBeDecimal],
      );
    }

    if (amount <= 0) {
      return IsDepositCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [amountBiggerThanZero],
      );
    }

    return IsDepositCommandOutput(
      command: userCommand,
      isMatchCommand: isMatchCommand,
      isValidCommand: true,
      amount: amount,
    );
  }
}
