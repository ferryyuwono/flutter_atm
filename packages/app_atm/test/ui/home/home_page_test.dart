// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/home_page_is_shown.dart';
import './step/user_see_command_line.dart';
import './step/user_type_command.dart';
import './step/user_tap_send_button.dart';
import './step/user_see_typed_command.dart';

void main() {
  group('''Home''', () {
    testWidgets('''Login''', (tester) async {
      await homePageIsShown(tester);
      await userSeeCommandLine(tester);
      await userTypeCommand(tester);
      await userTapSendButton(tester);
      await userSeeTypedCommand(tester);
    });
  });
}
