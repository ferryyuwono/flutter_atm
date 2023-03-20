import 'dart:convert';

import 'package:data/data.dart';
import 'package:data_account/src/service/model/owed_list_data.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class OwedListDataMapper implements ObjectMapper<OwedListData> {
  final jsonEncoder = const JsonEncoder();
  final jsonDecoder = const JsonDecoder();

  @override
  OwedListData mapToObject(String? jsonString) {
    try {
      final json = jsonDecoder.convert(jsonString ?? '{}');
      return json != null && json is Map<String, dynamic> ?
      OwedListData.fromJson(json) :
      const OwedListData();
    } catch(_) {}

    return const OwedListData();
  }

  @override
  String mapToJsonString(OwedListData object) {
    return jsonEncoder.convert(object.toJson());
  }
}
