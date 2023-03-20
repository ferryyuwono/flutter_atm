import 'package:domain_account/domain_account.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GetDebtCreditInputMapper {
  GetDebtCreditInputMapper();

  GetDebtCreditRequest map(LoginInput input) {
    return GetDebtCreditRequest(
      username: input.username,
    );
  }
}
