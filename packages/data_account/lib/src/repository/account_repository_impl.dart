import 'package:data_account/data_account.dart';
import 'package:data_account/src/repository/mapper/account_mapper.dart';
import 'package:domain_account/domain_account.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final AccountService _accountService;
  final AccountMapper _accountMapper;

  Account loginAccount = const Account();

  AccountRepositoryImpl(
    this._accountService,
    this._accountMapper,
  );

  @override
  Future<Account> login({
    required LoginRequest request
  }) async {
    final response = await _accountService.getAccount(username: request.username);
    if (response.id != null) {
      loginAccount = _accountMapper.map(response);
      return loginAccount;
    }

    final newAccount = await _accountService.addAccount(username: request.username);
    loginAccount = _accountMapper.map(newAccount);
    return loginAccount;
  }

  @override
  bool hasLogin() => loginAccount.id > 0;

  @override
  Future<Account> logout({
    required LogoutRequest request
  }) async {
    final account = loginAccount;
    loginAccount = const Account();
    return account;
  }
}
