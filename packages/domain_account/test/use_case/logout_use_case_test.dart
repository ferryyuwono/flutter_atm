import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/logout_input_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:format/format.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  group('LogoutUseCase', () {
    final repository = MockAccountRepository();
    final logoutInputMapper = LogoutInputMapper();
    final logoutUseCase = LogoutUseCase(
      repository,
      logoutInputMapper
    );

    setUp(() {});

    test('when execute is called and user has login, should return correct data', () async {
      // Given
      const username = 'mock';
      const request = LogoutRequest();
      const account = Account(
        id: 1,
        username: username,
        balance: 0
      );

      // When
      when(() => repository.hasLogin()).thenReturn(true);
      when(() => repository.logout(request: request))
          .thenAnswer((_) => Future.value(account));
      final result = await logoutUseCase.execute(
        const LogoutInput()
      );

      // Then
      final expected = LogoutOutput(
        account: account,
        isSuccess: true,
        messages: [LogoutUseCase.goodbyeMessage.format(account.username)],
      );
      expect(result, expected);
    });
    test('when execute is called and user has not login, should return failed data', () async {
      // When
      when(() => repository.hasLogin()).thenReturn(false);
      final result = await logoutUseCase.execute(
        const LogoutInput()
      );

      // Then
      const expected = LogoutOutput(
        isSuccess: false,
        messages: [LogoutUseCase.authenticationError],
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
