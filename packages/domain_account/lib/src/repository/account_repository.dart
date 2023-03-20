import 'package:domain_account/domain_account.dart';

abstract class AccountRepository {
  Future<Account> login({
    required LoginRequest request
  });

  bool hasLogin();

  Future<Account> logout({
    required LogoutRequest request
  });
}
