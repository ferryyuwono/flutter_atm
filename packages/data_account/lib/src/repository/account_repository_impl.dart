import 'package:data_account/data_account.dart';
import 'package:data_account/src/repository/mapper/account_mapper.dart';
import 'package:data_account/src/repository/mapper/debt_credit_mapper.dart';
import 'package:data_account/src/repository/mapper/owed_mapper.dart';
import 'package:domain_account/domain_account.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final AccountService _accountService;
  final AccountMapper _accountMapper;
  final DebtCreditMapper _debtCreditMapper;
  final OwedMapper _owedMapper;

  Account loginAccount = const Account();

  AccountRepositoryImpl(
    this._accountService,
    this._accountMapper,
    this._debtCreditMapper,
    this._owedMapper,
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
  Account getLoginAccount() => loginAccount;

  @override
  Future<Account> deposit({
    required DepositRequest request
  }) async {
    final account = await _accountService.addBalance(
      username: loginAccount.username,
      amount: request.amount
    );
    loginAccount = _accountMapper.map(account);
    return loginAccount;
  }

  @override
  Future<Account> withdraw({
    required WithdrawRequest request
  }) async {
    final account = await _accountService.addBalance(
      username: loginAccount.username,
      amount: -request.amount
    );
    loginAccount = _accountMapper.map(account);
    return loginAccount;
  }

  @override
  Future<DebtCredit> getDebtCredit({
    required GetDebtCreditRequest request
  }) async {
    final response = await _accountService.getOwedList();
    return _debtCreditMapper.map(response, request.username);
  }

  @override
  Future<bool> updateOwed({
    required Owed owed
  }) async {
    if (owed.from.isEmpty) {
      return false;
    }

    return await _accountService.updateOwed(
      _owedMapper.mapToData(owed)
    );
  }

  @override
  Future<Account> logout({
    required LogoutRequest request
  }) async {
    final account = loginAccount;
    loginAccount = const Account();
    return account;
  }

  @override
  Future<bool> hasAccount(String username) async {
    final response = await _accountService.getAccount(
      username: username
    );
    return response.id != null;
  }

  @override
  Future<Account> transfer({
    required TransferRequest request
  }) async {
    if (request.amount == 0) {
      return loginAccount;
    }

    await withdraw(request: WithdrawRequest(amount: request.amount));
    await _accountService.addBalance(
      username: request.transferTo,
      amount: request.amount
    );
    return loginAccount;
  }
}
