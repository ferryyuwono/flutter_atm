import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/model/get_debt_credit_request.dart';

abstract class AccountRepository {
  Future<Account> login({
    required LoginRequest request
  });

  bool hasLogin();
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

  Future<Account> logout({
    required LogoutRequest request
  });
}
