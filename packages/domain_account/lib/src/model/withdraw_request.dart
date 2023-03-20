import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdraw_request.freezed.dart';

@freezed
class WithdrawRequest with _$WithdrawRequest {
  const factory WithdrawRequest({
    required int amount,
  }) = _WithdrawRequest;
}
