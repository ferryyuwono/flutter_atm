import 'package:app_atm/app_atm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> userTypeCommand(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key(HomePage.commandTextFieldKey)),
    'login ferry',
  );
  await tester.pumpAndSettle();
}
