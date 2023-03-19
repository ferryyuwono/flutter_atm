import 'package:data/data.dart';
import 'package:data_account/data_account.dart';
import 'package:data_account/src/service/mapper/account_list_data_mapper.dart';
import 'package:data_account/src/service/model/account_list_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferenceClient extends Mock implements SharedPreferenceClient {}

void main() {
  group('AccountService', () {
    late AccountService gameService;
    final sharedPreferenceClient = MockSharedPreferenceClient();
    final accountListDataMapper = AccountListDataMapper();

    setUp(() {
      gameService = AccountService(
        sharedPreferenceClient,
        accountListDataMapper,
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

    tearDown(() {});
  });
}
