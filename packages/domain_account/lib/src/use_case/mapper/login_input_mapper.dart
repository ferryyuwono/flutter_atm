import 'package:domain_account/domain_account.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LoginInputMapper {
  LoginInputMapper();

  LoginRequest map(LoginInput data) {
    return LoginRequest(
      username: data.username,
    );
  }
}
