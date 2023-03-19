import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/logout_input_mapper.dart';
import 'package:format/format.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LogoutUseCase {
  final AccountRepository _repository;
  final LogoutInputMapper _inputMapper;

  static const authenticationError = 'No user found. Please login first to execute command';
  static const goodbyeMessage = 'Goodbye, {0}!';

  LogoutUseCase(
    this._repository,
    this._inputMapper,
  );

  Future<LogoutOutput> execute(LogoutInput input) async {
    if (!_repository.hasLogin()) {
      return const LogoutOutput(
        isSuccess: false,
        messages: [authenticationError],
      );
    }

    final result = await _repository.logout(
      request: _inputMapper.map(input),
    );

    return LogoutOutput(
      account: result,
      isSuccess: true,
      messages: [goodbyeMessage.format(result.username)],
    );
  }
}
