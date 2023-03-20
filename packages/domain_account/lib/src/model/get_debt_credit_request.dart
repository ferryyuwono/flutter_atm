import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_debt_credit_request.freezed.dart';

@freezed
class GetDebtCreditRequest with _$GetDebtCreditRequest {
  const factory GetDebtCreditRequest({
    required String username,
  }) = _GetDebtCreditRequest;
}
