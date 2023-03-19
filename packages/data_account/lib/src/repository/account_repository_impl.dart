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
    final account = _accountMapper.map(response);
    if (account.id > 0) {
      loginAccount = account;
    }

    return account;
  }

  @override
  bool hasLogin() => loginAccount.id > 0;

  @override
  Future<Account> logout({
    required LogoutRequest request
  }) async {
    if (loginAccount.username == request.username) {
      final account = loginAccount;
      loginAccount = const Account();
      return account;
    }

    return const Account();
  }
}
