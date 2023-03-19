import 'package:data/data.dart';
import 'package:data_account/src/service/model/account_list_data.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AccountListDataMapper implements ObjectMapper<AccountListData> {
  @override
  AccountListData mapToObject(dynamic json) {
    return json != null && json is Map<String, dynamic> ?
      AccountListData.fromJson(json) :
      const AccountListData();
  }

  @override
  Map<String, dynamic> mapToJson(AccountListData object) {
    return object.toJson();
  }
}
