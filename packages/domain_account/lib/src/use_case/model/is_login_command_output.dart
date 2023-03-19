import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_login_command_output.freezed.dart';

@freezed
class IsLoginCommandOutput with _$IsLoginCommandOutput {
  const IsLoginCommandOutput._();

  const factory IsLoginCommandOutput({
    @Default('') String command,
    @Default(false) bool isMatchCommand,
    @Default(false) bool isValidCommand,
    @Default('') String username,
    @Default([]) List<String> messages,
  }) = _IsLoginCommandOutput;
}
