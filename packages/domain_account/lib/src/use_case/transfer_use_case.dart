import 'package:collection/collection.dart';
import 'package:domain_account/domain_account.dart';
import 'package:format/format.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class TransferUseCase {
  final AccountRepository _repository;
  
  static const authenticationError = 'No user found. Please login first to execute command';
  static const transferredToAmountFound = 'Transferred \${0} to {1}';
  static const balanceMessage = 'Your balance is \${0}!';
  static const owedFromMessage = 'Owed \${0} from {1}';
  static const owedToMessage = 'Owed \${0} to {1}';

  TransferUseCase(
    this._repository,
  );

  Future<TransferOutput> execute(TransferInput input) async {
    final account = _repository.getLoginAccount();
    if (account.id == 0) {
      return const TransferOutput(
        isSuccess: false,
        messages: [authenticationError],
      );
    }

    await _repository.getOrCreateAccount(input.transferTo);
    final debtCredit = await _repository.getDebtCredit(
      request: GetDebtCreditRequest(username: account.username)
    );

    // Credit
    final lowerCaseTransferTo = input.transferTo.toLowerCase();
    final credit = debtCredit.credits.firstWhereOrNull(
      (element) => element.from.toLowerCase() == lowerCaseTransferTo
    ) ?? const Owed();

    final int transferAmountAfterCredit;
    final Owed newCredit;
    if (credit.amount > input.amount) {
      newCredit = credit.copyWith(
        amount: credit.amount - input.amount,
      );
      transferAmountAfterCredit = 0;
    } else {
      newCredit = credit.copyWith(
        amount: 0,
      );
      transferAmountAfterCredit = input.amount - credit.amount;
    }
    await _repository.updateOwed(owed: newCredit);

    // Debt
    final int finalTransferAmount;
    final int nextDebtAmount;
    if (account.balance < transferAmountAfterCredit) {
      nextDebtAmount = transferAmountAfterCredit - account.balance;
      finalTransferAmount = account.balance;
    } else {
      nextDebtAmount = 0;
      finalTransferAmount = transferAmountAfterCredit;
    }

    final debt = debtCredit.debts.firstWhereOrNull(
      (element) => element.to.toLowerCase() == lowerCaseTransferTo
    ) ?? const Owed();

    Owed newDebt = const Owed();
    newDebt = debt.copyWith(
      amount: debt.amount + nextDebtAmount,
    );
    await _repository.updateOwed(owed: newDebt);

    // Transfer
    final newAccount = await _repository.transfer(
      request: TransferRequest(
        transferTo: input.transferTo,
        amount: finalTransferAmount,
      )
    );

    return TransferOutput(
      data: newAccount,
      isSuccess: true,
      messages: [
        transferredToAmountFound.format(finalTransferAmount, input.transferTo),
        balanceMessage.format(newAccount.balance),
        ...[credit.amount > 0 || newCredit.from.isNotEmpty ? owedFromMessage.format(newCredit.amount, newCredit.from) : ''],
        ...[debt.amount > 0 || newDebt.to.isNotEmpty ? owedToMessage.format(newDebt.amount, newDebt.to) : ''],
      ]
    );
  }
}
