import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_withdraw_command_output.freezed.dart';

@freezed
class IsWithdrawCommandOutput with _$IsWithdrawCommandOutput {
  const IsWithdrawCommandOutput._();

  const factory IsWithdrawCommandOutput({
    @Default('') String command,
    @Default(false) bool isMatchCommand,
    @Default(false) bool isValidCommand,
    @Default(0) int amount,
    @Default([]) List<String> messages,
  }) = _IsWithdrawCommandOutput;
}
