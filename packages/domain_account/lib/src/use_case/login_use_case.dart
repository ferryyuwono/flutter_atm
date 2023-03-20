import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/login_input_mapper.dart';
import 'package:format/format.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LoginUseCase {
  final AccountRepository _repository;
  final LoginInputMapper _inputMapper;

  static const doubleLoginError = 'You have login. Please logout first';
  static const helloMessage = 'Hello, {0}!';
  static const balanceMessage = 'Your balance is \${0}!';

  LoginUseCase(
    this._repository,
    this._inputMapper,
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
    return LoginOutput(
      data: data,
      isSuccess: true,
      messages: [
        helloMessage.format(data.username),
        balanceMessage.format(data.balance),
      ]
    );
  }
}
