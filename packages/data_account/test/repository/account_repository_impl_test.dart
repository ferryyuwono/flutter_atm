import 'package:data_account/data_account.dart';
import 'package:data_account/src/repository/account_repository_impl.dart';
import 'package:data_account/src/repository/mapper/account_mapper.dart';
import 'package:data_account/src/repository/mapper/debt_credit_mapper.dart';
import 'package:data_account/src/repository/mapper/owed_mapper.dart';
import 'package:domain_account/domain_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountService extends Mock implements AccountService {}

void main() {
  group('AccountRepositoryImpl', () {
    final accountService = MockAccountService();
    final accountMapper = AccountMapper();
    final OwedMapper owedMapper = OwedMapper();
    final debtCreditMapper = DebtCreditMapper(owedMapper);

    setUp(() {});

    test('when login is called and not found, should return data', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
        debtCreditMapper,
        owedMapper,
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
        debtCreditMapper,
        owedMapper,
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
        debtCreditMapper,
        owedMapper,
      );

      // When
      final result = accountRepository.hasLogin();

      // Then
      expect(result, false);
    });
    test('when getDebtCredit is called, should return data', () async {
      // Given
      const username = 'mock';
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
        debtCreditMapper,
        owedMapper,
      );

      // When
      when(
        () => accountService.getOwedList(),
      ).thenAnswer(
        (_) => Future.value(const OwedListData()),
      );
      final result = await accountRepository.getDebtCredit(
        request: const GetDebtCreditRequest(username: username)
      );

      // Then
      expect(result, const DebtCredit());
    });
    test('when deposit is called, should return account', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
        debtCreditMapper,
        owedMapper,
      );
      const username = 'mock';
      accountRepository.loginAccount = const Account(
        id: 1,
        username: username,
        balance: 0,
      );
      const amount = 100;

      // When
      when(
        () => accountService.addBalance(
          username: username,
          amount: amount
        ),
      ).thenAnswer(
        (_) => Future.value(const AccountData(
          id: 1,
          username: username,
          balance: 100,
        )),
      );
      final result = await accountRepository.deposit(
        request: const DepositRequest(amount: amount)
      );

      // Then
      const expected = Account(
        id: 1,
        username: username,
        balance: 100,
      );
      expect(result, expected);
    });
    test('when withdraw is called, should return account', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
        debtCreditMapper,
        owedMapper,
      );
      const username = 'mock';
      accountRepository.loginAccount = const Account(
        id: 1,
        username: username,
        balance: 100,
      );
      const amount = 100;

      // When
      when(
        () => accountService.addBalance(
          username: username,
          amount: -amount
        ),
      ).thenAnswer(
        (_) => Future.value(const AccountData(
          id: 1,
          username: username,
          balance: 0,
        )),
      );
      final result = await accountRepository.withdraw(
        request: const WithdrawRequest(amount: amount)
      );

      // Then
      const expected = Account(
        id: 1,
        username: username,
        balance: 0,
      );
      expect(result, expected);
    });
    test('when logout is called and has login, should return data', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
        debtCreditMapper,
        owedMapper,
      );

      // When
      final result = await accountRepository.logout(
        request: const LogoutRequest()
      );

      // Then
      expect(result, const Account());
    });
    test('when getOrCreateAccount is called and exists, should return account', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
        debtCreditMapper,
        owedMapper,
      );
      const username = 'mock';

      // When
      when(
        () => accountService.getAccount(username: username),
      ).thenAnswer(
        (_) => Future.value(const AccountData(
          id: 1,
          username: username,
          balance: 0
        )),
      );
      final result = await accountRepository.getOrCreateAccount(username);

      // Then
      expect(result, const Account(
        id: 1,
        username: 'mock',
        balance: 0
      ));
    });
    test('when getOrCreateAccount is called and not found, should return account', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
        debtCreditMapper,
        owedMapper,
      );
      const username = 'mock';

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
          balance: 0
        )),
      );
      final result = await accountRepository.getOrCreateAccount(username);

      // Then
      expect(result, const Account(
        id: 1,
        username: 'mock',
        balance: 0
      ));
    });
    test('when updateOwed is called with empty owed, should return false', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
        debtCreditMapper,
        owedMapper,
      );
      const owed = Owed();

      // When
      final result = await accountRepository.updateOwed(owed: owed);

      // Then
      expect(result, false);
    });
    test('when updateOwed is called, should return true', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
        debtCreditMapper,
        owedMapper,
      );
      const owed = Owed(
        from: 'mock',
        to: 'mock2',
        amount: 100
      );

      // When
      when(
        () => accountService.updateOwed(const OwedData(
          from: 'mock',
          to: 'mock2',
          amount: 100
        )),
      ).thenAnswer(
        (_) => Future.value(true),
      );
      final result = await accountRepository.updateOwed(owed: owed);

      // Then
      expect(result, true);
    });
    test('when transfer is called and transfer is zero, should return account', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
        debtCreditMapper,
        owedMapper,
      );
      const transferTo = 'mock2';

      // When
      final result = await accountRepository.transfer(
        request: const TransferRequest(transferTo: transferTo, amount: 0)
      );

      // Then
      expect(result, const Account());
    });
    test('when transfer is called, should return account', () async {
      // Given
      final accountRepository = AccountRepositoryImpl(
        accountService,
        accountMapper,
        debtCreditMapper,
        owedMapper,
      );
      const username = 'mock';
      accountRepository.loginAccount = const Account(
        id: 1,
        username: username,
        balance: 100,
      );
      const amount = 100;
      const transferTo = 'mock2';

      // When
      when(
        () => accountService.addBalance(
          username: username,
          amount: -amount
        ),
      ).thenAnswer(
        (_) => Future.value(const AccountData(
          id: 1,
          username: username,
          balance: 0,
        )),
      );
      when(
        () => accountService.addBalance(
          username: transferTo,
          amount: amount
        ),
      ).thenAnswer(
        (_) => Future.value(const AccountData(
          id: 2,
          username: transferTo,
          balance: amount,
        )),
      );
      final result = await accountRepository.transfer(
        request: const TransferRequest(transferTo: transferTo, amount: amount)
      );

      // Then
      expect(result, const Account(
        id: 1,
        username: username,
        balance: 0,
      ));
    });

    tearDown(() {});
  });
}
