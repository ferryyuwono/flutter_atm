import 'package:domain_account/domain_account.dart';
import 'package:format/format.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class IsTransferCommandUseCase {
  IsTransferCommandUseCase();

  static const matchCommand = "transfer";
  static const unrecognizedCommand = 'Unrecognized command: {0}';
  static const missingInputParameter = 'Please input transfer parameter';
  static const tooMuchParameter = 'Transfer can only have 2 parameter: \$transfer [username] [amount]';
  static const parameterNeedToBeDecimal = 'Transfer amount can only be decimal number';
  static const amountBiggerThanZero = 'Transfer amount need to be bigger than 0';

  Future<IsTransferCommandOutput> execute(String command) async {
    final trimCommand = command.trim();
    final userCommand = '\$ $trimCommand';
    final parameters = trimCommand.split(' ');

    final isMatchCommand = trimCommand.toLowerCase().startsWith(matchCommand);
    if (!isMatchCommand) {
      return IsTransferCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [unrecognizedCommand.format(parameters[0])],
      );
    }

    if (parameters.length == 1) {
      return IsTransferCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [missingInputParameter],
      );
    }

    if (parameters.length != 3) {
      return IsTransferCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [tooMuchParameter],
      );
    }

    final amountText = parameters[2];
    final int amount;
    try {
      amount = int.parse(amountText);
    } catch (_) {
      return IsTransferCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [parameterNeedToBeDecimal],
      );
    }

    if (amount <= 0) {
      return IsTransferCommandOutput(
        command: userCommand,
        isMatchCommand: isMatchCommand,
        isValidCommand: false,
        messages: [amountBiggerThanZero],
      );
    }

    return IsTransferCommandOutput(
      command: userCommand,
      isMatchCommand: isMatchCommand,
      isValidCommand: true,
      transferTo: parameters[1],
      amount: amount,
    );
  }
}
