import 'package:data/data.dart';
import 'package:data_account/data_account.dart';
import 'package:data_account/src/service/mapper/account_list_data_mapper.dart';
import 'package:data_account/src/service/mapper/owed_list_data_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferenceClient extends Mock implements SharedPreferenceClient {}

void main() {
  group('AccountService', () {
    late AccountService gameService;
    final sharedPreferenceClient = MockSharedPreferenceClient();
    final accountListDataMapper = AccountListDataMapper();
    final owedListDataMapper = OwedListDataMapper();

    setUp(() {
      gameService = AccountService(
        sharedPreferenceClient,
        accountListDataMapper,
        owedListDataMapper,
      );
    });

    test('when getAccount is called and not found, should return empty data', () async {
      // Given
      const username = 'mock';
      const response = AccountListData(
        accounts: [],
      );

      // When
      when(
        () => sharedPreferenceClient.getObject<AccountListData>(
          key: AccountService.accountKey,
          mapper: accountListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(response),
      );
      final result = await gameService.getAccount(
        username: username
      );

      // Then
      const expected = AccountData();
      expect(result, expected);
    });
    test('when getAccount is called and null, should return empty data', () async {
      // Given
      const username = 'mock';
      const response = AccountListData();

      // When
      when(
        () => sharedPreferenceClient.getObject<AccountListData>(
          key: AccountService.accountKey,
          mapper: accountListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(response),
      );
      final result = await gameService.getAccount(
        username: username
      );

      // Then
      const expected = AccountData();
      expect(result, expected);
    });
    test('when getAccount is called and found, should return data', () async {
      // Given
      const username = 'mock';
      const account = AccountData(
        id: 1,
        username: username,
        balance: 100,
      );
      const response = AccountListData(
        accounts: [ account ],
      );

      // When
      when(
        () => sharedPreferenceClient.getObject<AccountListData>(
          key: AccountService.accountKey,
          mapper: accountListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(response),
      );
      final result = await gameService.getAccount(
        username: username
      );

      // Then
      expect(result, account);
    });
    test('when addAccount is called and found, should return existing data', () async {
      // Given
      const username = 'mock';
      const account = AccountData(
        id: 1,
        username: username,
        balance: 100,
      );
      const response = AccountListData(
        accounts: [ account ],
      );

      // When
      when(
        () => sharedPreferenceClient.getObject<AccountListData>(
          key: AccountService.accountKey,
          mapper: accountListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(response),
      );
      final result = await gameService.addAccount(
        username: username
      );

      // Then
      expect(result, account);
    });
    test('when addAccount is called and null, should return new account data', () async {
      // Given
      const username = 'mock';
      const response = AccountListData();
      const newAccount = AccountData(
        id: 1,
        username: username,
        balance: 0,
      );
      final newResponse = response.copyWith(
        accounts: [ newAccount ],
      );

      // When
      when(
        () => sharedPreferenceClient.getObject<AccountListData>(
          key: AccountService.accountKey,
          mapper: accountListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(response),
      );
      when(
        () => sharedPreferenceClient.setObject<AccountListData>(
          key: AccountService.accountKey,
          object: newResponse,
          mapper: accountListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(true),
      );
      final result = await gameService.addAccount(
        username: username
      );

      // Then
      expect(result, newAccount);
    });
    test('when addAccount is called and not found, should return new account data', () async {
      // Given
      const username = 'mock';
      const response = AccountListData(
        accounts: [],
      );
      const newAccount = AccountData(
        id: 1,
        username: username,
        balance: 0,
      );
      final newResponse = response.copyWith(
        accounts: [ newAccount ],
      );

      // When
      when(
        () => sharedPreferenceClient.getObject<AccountListData>(
          key: AccountService.accountKey,
          mapper: accountListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(response),
      );
      when(
        () => sharedPreferenceClient.setObject<AccountListData>(
          key: AccountService.accountKey,
          object: newResponse,
          mapper: accountListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(true),
      );
      final result = await gameService.addAccount(
        username: username
      );

      // Then
      expect(result, newAccount);
    });
    test('when addBalance is called and not found, should return empty data', () async {
      // Given
      const username = 'mock';
      const response = AccountListData(
        accounts: [],
      );

      // When
      when(
        () => sharedPreferenceClient.getObject<AccountListData>(
          key: AccountService.accountKey,
          mapper: accountListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(response),
      );
      final result = await gameService.addBalance(
        username: username,
        amount: 100,
      );

      // Then
      expect(result, const AccountData());
    });
    test('when addBalance is called and found, should return data', () async {
      // Given
      const username = 'mock';
      const account = AccountData(
        id: 1,
        username: username,
        balance: 0,
      );
      const response = AccountListData(
        accounts: [account],
      );
      final newAccount = account.copyWith(
        balance: 100,
      );
      final newResponse = AccountListData(
        accounts: [newAccount],
      );

      // When
      when(
        () => sharedPreferenceClient.getObject<AccountListData>(
          key: AccountService.accountKey,
          mapper: accountListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(response),
      );

      when(
        () => sharedPreferenceClient.setObject<AccountListData>(
          key: AccountService.accountKey,
          object: newResponse,
          mapper: accountListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(true),
      );
      final result = await gameService.addBalance(
        username: username,
        amount: 100,
      );

      // Then
      expect(result, newAccount);
    });
    test('when getOwedList is called, should return data', () async {
      // Given
      const response = OwedListData(
        owedList: [],
      );

      // When
      when(
        () => sharedPreferenceClient.getObject<OwedListData>(
          key: AccountService.owedKey,
          mapper: owedListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(response),
      );
      final result = await gameService.getOwedList();

      // Then
      expect(result, response);
    });
    test('when updateOwed is called and owed amount is zero, should return data', () async {
      // Given
      const response = OwedListData(
        owedList: [],
      );
      const owed = OwedData(
        from: 'mock',
        to: 'mock2',
        amount: 0
      );
      const newResponse = OwedListData(
        owedList: [],
      );

      // When
      when(
        () => sharedPreferenceClient.getObject<OwedListData>(
          key: AccountService.owedKey,
          mapper: owedListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(response),
      );
      when(
        () => sharedPreferenceClient.setObject<OwedListData>(
          key: AccountService.owedKey,
          object: newResponse,
          mapper: owedListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(true),
      );
      final result = await gameService.updateOwed(owed);

      // Then
      expect(result, true);
    });
    test('when updateOwed is called and owed amount is greater than zero, should return data', () async {
      // Given
      const owed = OwedData(
          from: 'mock',
          to: 'mock2',
          amount: 100
      );
      const response = OwedListData(
        owedList: [owed],
      );
      const newResponse = OwedListData(
        owedList: [owed],
      );

      // When
      when(
        () => sharedPreferenceClient.getObject<OwedListData>(
          key: AccountService.owedKey,
          mapper: owedListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(response),
      );
      when(
        () => sharedPreferenceClient.setObject<OwedListData>(
          key: AccountService.owedKey,
          object: newResponse,
          mapper: owedListDataMapper
        ),
      ).thenAnswer(
        (_) => Future.value(true),
      );
      final result = await gameService.updateOwed(owed);

      // Then
      expect(result, true);
    });

    tearDown(() {});
  });
}
