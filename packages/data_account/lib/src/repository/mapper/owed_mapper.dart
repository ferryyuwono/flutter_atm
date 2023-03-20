import 'package:data_account/data_account.dart';
import 'package:domain_account/domain_account.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class OwedMapper {
  OwedMapper();

  Owed map(OwedData data) {
    return Owed(
      from: data.from ?? '',
      to: data.to ?? '',
      amount: data.amount ?? 0,
    );
  }
}
