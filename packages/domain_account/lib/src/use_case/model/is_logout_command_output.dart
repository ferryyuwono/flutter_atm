import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_logout_command_output.freezed.dart';

@freezed
class IsLogoutCommandOutput with _$IsLogoutCommandOutput {
  const IsLogoutCommandOutput._();

  const factory IsLogoutCommandOutput({
    @Default('') String command,
    @Default(false) bool isMatchCommand,
    @Default(false) bool isValidCommand,
    @Default([]) List<String> messages,
  }) = _IsLogoutCommandOutput;
}
