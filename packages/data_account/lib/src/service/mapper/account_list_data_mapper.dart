import 'dart:convert';

import 'package:data/data.dart';
import 'package:data_account/src/service/model/account_list_data.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class AccountListDataMapper implements ObjectMapper<AccountListData> {
  final jsonEncoder = const JsonEncoder();
  final jsonDecoder = const JsonDecoder();

  @override
  AccountListData mapToObject(String? jsonString) {
    try {
      final json = jsonDecoder.convert(jsonString ?? '{}');
      return json != null && json is Map<String, dynamic> ?
      AccountListData.fromJson(json) :
      const AccountListData();
    } catch(_) {}

    return const AccountListData();
  }

  @override
  String mapToJsonString(AccountListData object) {
    return jsonEncoder.convert(object.toJson());
  }
}
