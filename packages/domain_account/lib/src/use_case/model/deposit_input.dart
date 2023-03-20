import 'package:freezed_annotation/freezed_annotation.dart';

part 'deposit_input.freezed.dart';

@freezed
class DepositInput with _$DepositInput {
  const factory DepositInput({
    required int amount,
  }) = _DepositInput;
}
