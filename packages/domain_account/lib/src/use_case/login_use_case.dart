import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/get_debt_credit_input_mapper.dart';
import 'package:domain_account/src/use_case/mapper/login_input_mapper.dart';
import 'package:format/format.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LoginUseCase {
  final AccountRepository _repository;
  final LoginInputMapper _inputMapper;
  final GetDebtCreditInputMapper _debtCreditInputMapper;

  static const doubleLoginError = 'You have login. Please logout first';
  static const helloMessage = 'Hello, {0}!';
  static const balanceMessage = 'Your balance is \${0}!';
  static const owedToMessage = 'Owed \${0} to {1}';
  static const owedFromMessage = 'Owed \${0} from {1}';

  LoginUseCase(
    this._repository,
    this._inputMapper,
    this._debtCreditInputMapper,
  );

  Future<LoginOutput> execute(LoginInput input) async {
    if (_repository.hasLogin()) {
      return const LoginOutput(
        isSuccess: false,
        messages: [doubleLoginError],
      );
    }

    final data = await _repository.login(
      request: _inputMapper.map(input),
    );

    final debtCredit = await _repository.getDebtCredit(
      request: _debtCreditInputMapper.map(input),
    );

    final debtMessage = debtCredit.debts.map((e) =>
      owedToMessage.format(e.amount, e.to),
    );

    final creditMessage = debtCredit.credits.map((e) =>
      owedFromMessage.format(e.amount, e.from),
    );

    return LoginOutput(
      data: data,
      debtCredit: debtCredit,
      isSuccess: true,
      messages: [
        helloMessage.format(data.username),
        balanceMessage.format(data.balance),
        ...debtMessage,
        ...creditMessage
      ]
    );
  }
}
