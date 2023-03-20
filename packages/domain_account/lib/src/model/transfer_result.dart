import 'package:domain_account/domain_account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_result.freezed.dart';

@freezed
class TransferResult with _$TransferResult {
  const factory TransferResult({
    @Default(Account()) Account account,
    @Default('') String transferTo,
    @Default(0) int transferAmount,
    @Default([]) List<Owed> owed,
  }) = _TransferResult;
}
