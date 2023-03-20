import 'package:data_account/data_account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'owed_list_data.freezed.dart';
part 'owed_list_data.g.dart';

@freezed
class OwedListData with _$OwedListData  {
  const OwedListData._();

  const factory OwedListData({
    @JsonKey(name: 'owed_list') List<OwedData>? owedList,
  }) = _OwedListData;

  factory OwedListData.fromJson(Map<String, dynamic> json) =>
      _$OwedListDataFromJson(json);
}
