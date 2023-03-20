import 'package:domain_account/domain_account.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class WithdrawInputMapper {
  WithdrawInputMapper();

  WithdrawRequest map(WithdrawInput data) {
    return WithdrawRequest(
      amount: data.amount,
    );
  }
}
