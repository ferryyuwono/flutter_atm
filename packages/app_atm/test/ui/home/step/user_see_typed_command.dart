import 'package:app_atm/app_atm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:format/format.dart';

Future<void> userSeeTypedCommand(WidgetTester tester) async {
  expect(find.byKey(Key(HomePage.listLogItemKey.format(0))), findsOneWidget);
  await tester.pumpAndSettle();
}
