import 'package:domain_account/domain_account.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class TransferInputMapper {
  TransferInputMapper();

  TransferRequest map(TransferInput data) {
    return TransferRequest(
      transferTo: data.transferTo,
      amount: data.amount,
    );
  }
}
