import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_transfer_command_output.freezed.dart';

@freezed
class IsTransferCommandOutput with _$IsTransferCommandOutput {
  const IsTransferCommandOutput._();

  const factory IsTransferCommandOutput({
    @Default('') String command,
    @Default(false) bool isMatchCommand,
    @Default(false) bool isValidCommand,
    @Default('') String transferTo,
    @Default(0) int amount,
    @Default([]) List<String> messages,
  }) = _IsTransferCommandOutput;
}
