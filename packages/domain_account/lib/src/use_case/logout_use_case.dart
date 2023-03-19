import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/logout_input_mapper.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LogoutUseCase {
  final AccountRepository _repository;
  final LogoutInputMapper _inputMapper;

  static const authenticationError = 'No user found. Please login first to execute command';

  LogoutUseCase(
    this._repository,
    this._inputMapper,
  );

  Future<LogoutOutput> execute(LogoutInput input) async {
    if (!_repository.hasLogin()) {
      return const LogoutOutput(
        isSuccess: false,
        errorMessage: authenticationError,
      );
    }

    final result = await _repository.logout(
      request: _inputMapper.map(input),
    );

    return LogoutOutput(
      account: result,
      isSuccess: true,
    );
  }
}
