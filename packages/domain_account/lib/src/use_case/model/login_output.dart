import 'package:domain_account/domain_account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_output.freezed.dart';

@freezed
class LoginOutput with _$LoginOutput {
  const LoginOutput._();

  const factory LoginOutput({
    @Default(Account()) Account data,
    @Default(false) bool isSuccess,
    @Default('') String errorMessage,
  }) = _LoginOutput;
}
