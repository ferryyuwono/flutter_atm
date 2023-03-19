import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_data.freezed.dart';
part 'account_data.g.dart';

@freezed
class AccountData with _$AccountData {
  const AccountData._();

  const factory AccountData({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'balance') int? balance,
  }) = _AccountData;

  factory AccountData.fromJson(Map<String, dynamic> json) => _$AccountDataFromJson(json);
}
