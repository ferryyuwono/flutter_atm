import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_deposit_command_output.freezed.dart';

@freezed
class IsDepositCommandOutput with _$IsDepositCommandOutput {
  const IsDepositCommandOutput._();

  const factory IsDepositCommandOutput({
    @Default('') String command,
    @Default(false) bool isMatchCommand,
    @Default(false) bool isValidCommand,
    @Default(0) int amount,
    @Default([]) List<String> messages,
  }) = _IsDepositCommandOutput;
}
