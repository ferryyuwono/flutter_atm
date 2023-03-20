import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_request.freezed.dart';

@freezed
class TransferRequest with _$TransferRequest {
  const factory TransferRequest({
    required String transferTo,
    required int amount,
  }) = _TransferRequest;
}
