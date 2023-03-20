import 'package:freezed_annotation/freezed_annotation.dart';

part 'owed.freezed.dart';

@freezed
class Owed with _$Owed {
  const factory Owed({
    @Default('') String from,
    @Default('') String to,
    @Default(0) int amount,
  }) = _Owed;
}
