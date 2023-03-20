import 'package:data/data.dart';
import 'package:data_account/data_account.dart';
import 'package:data_account/src/service/mapper/account_list_data_mapper.dart';
import 'package:data_account/src/service/model/account_list_data.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AccountService {
  final SharedPreferenceClient _sharedPreferenceClient;
  final AccountListDataMapper _accountListDataMapper;

  static const accountKey = 'preference.account';

  AccountService(
    this._sharedPreferenceClient,
    this._accountListDataMapper,
  );

  Future<AccountListData> _getAccountList() async {
    return _sharedPreferenceClient.getObject<AccountListData>(
      key: accountKey,
      mapper: _accountListDataMapper,
    );
  }

  Future<bool> _setAccountList(
    AccountListData accountListData,
  ) async {
    return _sharedPreferenceClient.setObject<AccountListData>(
      key: accountKey,
      object: accountListData,
      mapper: _accountListDataMapper,
    );
  }

  Future<AccountData> getAccount({
    required String username
  }) async {
    final accountList = await _getAccountList();
    return _getAccount(
      accountList: accountList,
      username: username,
    );
  }

  AccountData _getAccount({
    required AccountListData accountList,
    required String username
  }) {
    final lowerCaseUsername = username.toLowerCase();
    return accountList.accounts?.firstWhere(
      (element) => element.username?.toLowerCase() == lowerCaseUsername,
      orElse: () => const AccountData(),
    ) ?? const AccountData();
  }

  Future<AccountData> addAccount({
    required String username
  }) async {
    final accountList = await _getAccountList();
    final existingAccount = _getAccount(
      accountList: accountList,
      username: username,
    );
    if (existingAccount.id != null) {
      return existingAccount;
    }

    final newAccount = AccountData(
      id: (accountList.accounts?.length ?? 0) + 1,
      username: username,
      balance: 0,
    );

    final List<AccountData> accounts = accountList.accounts ?? [];
    final AccountListData newAccountList = accountList.copyWith(
      accounts: [...accounts, newAccount ]
    );
    await _setAccountList(newAccountList);

    return newAccount;
  }
}
