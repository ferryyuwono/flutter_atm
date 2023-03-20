import 'package:data_account/data_account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_list_data.freezed.dart';
part 'account_list_data.g.dart';

@freezed
class AccountListData with _$AccountListData  {
  const AccountListData._();

  const factory AccountListData({
    @JsonKey(name: 'accounts') List<AccountData>? accounts,
  }) = _AccountListData;

  factory AccountListData.fromJson(Map<String, dynamic> json) =>
      _$AccountListDataFromJson(json);
}
