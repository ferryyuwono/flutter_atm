import 'package:domain_account/domain_account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_output.freezed.dart';

@freezed
class LogoutOutput with _$LogoutOutput {
  const LogoutOutput._();

  const factory LogoutOutput({
    @Default(Account()) Account account,
    @Default(false) bool isSuccess,
    @Default([]) List<String> messages,
  }) = _LogoutOutput;
}
