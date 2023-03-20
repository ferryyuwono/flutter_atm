import 'package:app_atm/app_atm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> userTapSendButton(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key(HomePage.sendButtonKey)));
  await tester.pump();
}
