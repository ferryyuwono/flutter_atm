import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';

@freezed
class Account with _$Account {
  const factory Account({
    @Default(0) int id,
    @Default('') String username,
    @Default(0) int balance,
  }) = _Account;
}
