import 'package:data_account/data_account.dart';
import 'package:data_account/src/repository/account_repository_impl.dart';
import 'package:data_account/src/repository/mapper/account_mapper.dart';
import 'package:domain_account/domain_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountService extends Mock implements AccountService {}

void main() {
  group('AccountRepositoryImpl', () {
    final accountService = MockAccountService();
    final accountMapper = AccountMapper();

    setUp(() {});

    test('when login is called and not found, should return data', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
      );
      const username = 'mock';
      const request = LoginRequest(
        username: username,
      );

      // When
      when(
        () => accountService.getAccount(username: username),
      ).thenAnswer(
        (_) => Future.value(const AccountData()),
      );
      when(
        () => accountService.addAccount(username: username),
      ).thenAnswer(
        (_) => Future.value(const AccountData(
          id: 1,
          username: username,
          balance: 0,
        )),
      );
      final result = await accountRepository.login(
        request: request
      );

      // Then
      const expected = Account(
        id: 1,
        username: username,
        balance: 0,
      );
      expect(result, expected);
    });
    test('when login is called, should return data', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
      );
      const username = 'mock';
      const request = LoginRequest(
        username: username,
      );

      // When
      when(
        () => accountService.getAccount(username: username),
      ).thenAnswer(
        (_) => Future.value(
          const AccountData(
            id: 1,
            username: username,
            balance: 0,
          )
        ),
      );
      final result = await accountRepository.login(
        request: request
      );

      // Then
      const expected = Account(
        id: 1,
        username: username,
        balance: 0,
      );
      expect(result, expected);
    });
    test('when hasLogin is called, should return data', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
      );

      // When
      final result = accountRepository.hasLogin();

      // Then
      expect(result, false);
    });
    test('when logout is called and has login, should return data', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
      );

      // When
      final result = await accountRepository.logout(
        request: const LogoutRequest()
      );

      // Then
      expect(result, Account());
    });

    tearDown(() {});
  });
}
