import 'package:domain_account/domain_account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'debt_credit.freezed.dart';

@freezed
class DebtCredit with _$DebtCredit {
  const factory DebtCredit({
    @Default([]) List<Owed> debts,
    @Default([]) List<Owed> credits,
  }) = _DebtCredit;
}
