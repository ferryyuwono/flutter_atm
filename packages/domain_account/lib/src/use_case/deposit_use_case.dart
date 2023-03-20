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

  DepositUseCase(
    this._repository,
    this._inputMapper,
  );

  Future<DepositOutput> execute(DepositInput input) async {
    if (!_repository.hasLogin()) {
      return const DepositOutput(
        isSuccess: false,
        messages: [authenticationError],
      );
    }

    final data = await _repository.deposit(
      request: _inputMapper.map(input),
    );
    return DepositOutput(
      data: data,
      isSuccess: true,
      messages: [
        balanceMessage.format(data.balance),
      ]
    );
  }
}
