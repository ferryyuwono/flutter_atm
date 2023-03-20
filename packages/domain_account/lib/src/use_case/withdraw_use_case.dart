import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/withdraw_input_mapper.dart';
import 'package:format/format.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class WithdrawUseCase {
  final AccountRepository _repository;
  final WithdrawInputMapper _inputMapper;
  
  static const authenticationError = 'No user found. Please login first to execute command';
  static const insufficientBalanceMessage = 'Insufficient balance. You only have \${0}!';
  static const balanceMessage = 'Your balance is \${0}!';

  WithdrawUseCase(
    this._repository,
    this._inputMapper,
  );

  Future<WithdrawOutput> execute(WithdrawInput input) async {
    if (!_repository.hasLogin()) {
      return const WithdrawOutput(
        isSuccess: false,
        messages: [authenticationError],
      );
    }

    final account = _repository.getLoginAccount();
    if (account.balance < input.amount) {
      return WithdrawOutput(
        data: account,
        isSuccess: false,
        messages: [insufficientBalanceMessage.format(account.balance)],
      );
    }

    final data = await _repository.withdraw(
      request: _inputMapper.map(input),
    );
    return WithdrawOutput(
      data: data,
      isSuccess: true,
      messages: [
        balanceMessage.format(data.balance),
      ]
    );
  }
}
