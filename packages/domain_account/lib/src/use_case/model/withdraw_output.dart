import 'package:domain_account/domain_account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdraw_output.freezed.dart';

@freezed
class WithdrawOutput with _$WithdrawOutput {
  const WithdrawOutput._();

  const factory WithdrawOutput({
    @Default(Account()) Account data,
    @Default(false) bool isSuccess,
    @Default([]) List<String> messages,
  }) = _WithdrawOutput;
}
