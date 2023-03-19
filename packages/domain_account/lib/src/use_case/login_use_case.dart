import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/login_input_mapper.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LoginUseCase {
  final AccountRepository _repository;
  final LoginInputMapper _inputMapper;

  static const doubleLoginError = 'You have login as other user. please logout first';

  LoginUseCase(
    this._repository,
    this._inputMapper,
  );

  Future<LoginOutput> execute(LoginInput input) async {
    if (_repository.hasLogin()) {
      return const LoginOutput(
        isSuccess: false,
        errorMessage: doubleLoginError,
      );
    }

    final data = await _repository.login(
      request: _inputMapper.map(input),
    );
    return LoginOutput(
      data: data,
      isSuccess: true,
    );
  }
}
