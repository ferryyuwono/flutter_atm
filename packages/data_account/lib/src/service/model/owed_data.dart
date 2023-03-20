import 'package:freezed_annotation/freezed_annotation.dart';

part 'owed_data.freezed.dart';
part 'owed_data.g.dart';

@freezed
class OwedData with _$OwedData {
  const OwedData._();

  const factory OwedData({
    @JsonKey(name: 'from') String? from,
    @JsonKey(name: 'to') String? to,
    @JsonKey(name: 'amount') int? amount,
  }) = _OwedData;

  factory OwedData.fromJson(Map<String, dynamic> json) => _$OwedDataFromJson(json);
}
