import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_input.freezed.dart';

@freezed
class TransferInput with _$TransferInput {
  const factory TransferInput({
    required String transferTo,
    required int amount,
  }) = _TransferInput;
}
