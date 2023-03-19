import 'package:data/data.dart';
import 'package:data_account/data_account.dart';
import 'package:data_account/src/repository/account_repository_impl.dart';
import 'package:data_account/src/repository/mapper/account_mapper.dart';
import 'package:domain_account/domain_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountService extends Mock implements AccountService {}

void main() {
  group('AccountRepositoryImpl', () {
    late AccountRepositoryImpl accountRepository;
    final accountService = MockAccountService();
    final accountMapper = AccountMapper();

    setUp(() {
      accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
      );
    });

    test('when login is called, should return data', () async {
      // Given
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
      accountRepository.loginAccount = const Account(
        id: 1,
        username: 'mock',
        balance: 0,
      );

      // When
      final result = accountRepository.hasLogin();

      // Then
      expect(result, true);
    });
    test('when logout is called and has login, should return data', () async {
      // Given
      const account = Account(
        id: 1,
        username: 'mock',
        balance: 0,
      );
      accountRepository.loginAccount = account;

      // When
      final result = await accountRepository.logout(
        request: const LogoutRequest(username: 'mock')
      );

      // Then
      expect(result, account);
    });
    test('when logout is called has not login, should return failed data', () async {
      // Given
      accountRepository.loginAccount = const Account();

      // When
      final result = await accountRepository.logout(
          request: const LogoutRequest(username: 'mock')
      );

      // Then
      expect(result, const Account());
    });

    tearDown(() {});
  });
}
