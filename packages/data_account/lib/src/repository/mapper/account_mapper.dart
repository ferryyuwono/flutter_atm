import 'package:data_account/data_account.dart';
import 'package:domain_account/domain_account.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AccountMapper {
  AccountMapper();

  Account map(AccountData data) {
    return Account(
      id: data.id ?? 0,
      username: data.username ?? '',
      balance: data.balance ?? 0,
    );
  }
}
