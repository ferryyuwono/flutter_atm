import 'package:domain_account/domain_account.dart';

abstract class AccountRepository {
  Future<Account> login({
    required LoginRequest request
  });

  bool hasLogin();
  Future<Account> getOrCreateAccount(String username);
  Account getLoginAccount();

  Future<Account> deposit({
    required DepositRequest request
  });

  Future<Account> withdraw({
    required WithdrawRequest request
  });

  Future<DebtCredit> getDebtCredit({
    required GetDebtCreditRequest request
  });

  Future<bool> updateOwed({
    required Owed owed
  });

  Future<Account> transfer({
    required TransferRequest request
  });

  Future<Account> logout({
    required LogoutRequest request
  });
}
