import 'package:domain_account/domain_account.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LogoutInputMapper {
  LogoutInputMapper();

  LogoutRequest map(LogoutInput data) {
    return LogoutRequest();
  }
}
