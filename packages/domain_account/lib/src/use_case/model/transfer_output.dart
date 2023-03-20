import 'package:domain_account/domain_account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_output.freezed.dart';

@freezed
class TransferOutput with _$TransferOutput {
  const TransferOutput._();

  const factory TransferOutput({
    @Default(Account()) Account data,
    @Default(false) bool isSuccess,
    @Default([]) List<String> messages,
  }) = _TransferOutput;
}
