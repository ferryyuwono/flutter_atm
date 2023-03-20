import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/deposit_input_mapper.dart';
import 'package:format/format.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class DepositUseCase {
  final AccountRepository _repository;
  final DepositInputMapper _inputMapper;
  
  static const authenticationError = 'No user found. Please login first to execute command';
  static const balanceMessage = 'Your balance is \${0}!';
  static const transferredToAmount = 'Transferred \${0} to {1}';
  static const owedToMessage = 'Owed \${0} to {1}';

  DepositUseCase(
    this._repository,
    this._inputMapper,
  );

  Future<DepositOutput> execute(DepositInput input) async {
    final account = _repository.getLoginAccount();
    if (account.id == 0) {
      return const DepositOutput(
        isSuccess: false,
        messages: [authenticationError],
      );
    }

    final debtCredit = await _repository.getDebtCredit(
      request: GetDebtCreditRequest(username: account.username)
    );

    int balance = input.amount;
    final transferMessage = <String>[];
    final owedMessage = <String>[];
    for (final debt in debtCredit.debts) {
      final Owed newDebt;
      if (debt.amount < balance) {
        newDebt = debt.copyWith(
          amount: 0,
        );
        transferMessage.add(
          transferredToAmount.format(debt.amount, debt.to)
        );
        balance -= debt.amount;
      } else {
        newDebt = debt.copyWith(
          amount: debt.amount - balance,
        );
        transferMessage.add(
          transferredToAmount.format(balance, debt.to)
        );
        balance = 0;
      }
      owedMessage.add(
        owedToMessage.format(newDebt.amount, debt.to)
      );
      await _repository.updateOwed(owed: newDebt);

      if (balance == 0) {
        break;
      }
    }

    final data = await _repository.deposit(
      request: DepositRequest(amount: balance),
    );
    return DepositOutput(
      data: data,
      isSuccess: true,
      messages: [
        ...transferMessage,
        balanceMessage.format(data.balance),
        ...owedMessage,
      ]
    );
  }
}
