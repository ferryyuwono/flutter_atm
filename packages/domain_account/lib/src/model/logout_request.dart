import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_request.freezed.dart';

@freezed
class LogoutRequest with _$LogoutRequest {
  const factory LogoutRequest({
    required String username,
  }) = _LogoutRequest;
}
