import 'package:freezed_annotation/freezed_annotation.dart';

part 'deposit_request.freezed.dart';

@freezed
class DepositRequest with _$DepositRequest {
  const factory DepositRequest({
    required int amount,
  }) = _DepositRequest;
}
