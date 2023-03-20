import 'package:domain_account/domain_account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'deposit_output.freezed.dart';

@freezed
class DepositOutput with _$DepositOutput {
  const DepositOutput._();

  const factory DepositOutput({
    @Default(Account()) Account data,
    @Default(false) bool isSuccess,
    @Default([]) List<String> messages,
  }) = _DepositOutput;
}
