import 'package:data_account/data_account.dart';
import 'package:data_account/src/repository/mapper/owed_mapper.dart';
import 'package:domain_account/domain_account.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class DebtCreditMapper {
  final OwedMapper _owedMapper;

  DebtCreditMapper(
    this._owedMapper,
  );

  DebtCredit map(OwedListData data, String username) {
    final loweredCaseUsername = username.toLowerCase();
    final debtListData = data.owedList?.where(
      (element) => element.from?.toLowerCase() == loweredCaseUsername
    ).toList() ?? [];
    final creditListData = data.owedList?.where(
      (element) => element.to?.toLowerCase() == loweredCaseUsername
    ).toList() ?? [];

    return DebtCredit(
      debts: debtListData.map(_owedMapper.map).toList(),
      credits: creditListData.map(_owedMapper.map).toList(),
    );
  }
}
