import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdraw_input.freezed.dart';

@freezed
class WithdrawInput with _$WithdrawInput {
  const factory WithdrawInput({
    required int amount,
  }) = _WithdrawInput;
}
