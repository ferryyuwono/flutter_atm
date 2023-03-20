import 'package:domain_account/domain_account.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class DepositInputMapper {
  DepositInputMapper();

  DepositRequest map(DepositInput data) {
    return DepositRequest(
      amount: data.amount,
    );
  }
}
