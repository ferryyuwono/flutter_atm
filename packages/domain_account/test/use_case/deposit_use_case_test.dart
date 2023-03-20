import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/deposit_input_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:format/format.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  group('DepositUseCase', () {
    final repository = MockAccountRepository();
    final depositInputMapper = DepositInputMapper();
    final depositUseCase = DepositUseCase(
      repository,
      depositInputMapper
    );

    setUp(() {});

    test('when execute is called and user has not login, should return authentication data', () async {
      // Given
      const amount = 100;

      // When
      when(() => repository.getLoginAccount()).thenReturn(const Account());
      final result = await depositUseCase.execute(
        const DepositInput(
          amount: amount
        )
      );

      // Then
      const expected = DepositOutput(
        data: Account(),
        isSuccess: false,
        messages: [
          DepositUseCase.authenticationError,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and user has login and no debt, should return success data', () async {
      // Given
      const username = 'mock';
      const amount = 100;
      const account = Account(
        id: 1,
        username: username,
        balance: 0
      );
      const response = Account(
        id: 1,
        username: username,
        balance: 100
      );
      const debtCredit = DebtCredit(
        debts: [],
        credits: [],
      );

      // When
      when(() => repository.getLoginAccount()).thenReturn(account);
      when(() => repository.getDebtCredit(
          request: const GetDebtCreditRequest(username: username)
      )).thenAnswer((_) => Future.value(debtCredit));
      when(() => repository.deposit(
        request: const DepositRequest(amount: amount)
      )).thenAnswer((_) => Future.value(response));
      final result = await depositUseCase.execute(
        const DepositInput(
          amount: amount
        )
      );

      // Then
      final expected = DepositOutput(
        data: response,
        isSuccess: true,
        messages: [
          DepositUseCase.balanceMessage.format(response.balance)
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and user has login, should return success data', () async {
      // Given
      const username = 'mock';
      const amount = 100;
      const account = Account(
        id: 1,
        username: username,
        balance: 0
      );
      const response = Account(
        id: 1,
        username: username,
        balance: 0
      );
      const debtCredit = DebtCredit(
        debts: [
          Owed(
            from: 'mock',
            to: 'mock2',
            amount: 20,
          ),
          Owed(
            from: 'mock',
            to: 'mock3',
            amount: 80,
          )
        ],
        credits: [],
      );

      // When
      when(() => repository.getLoginAccount()).thenReturn(account);
      when(() => repository.getDebtCredit(
        request: const GetDebtCreditRequest(username: username)
      )).thenAnswer((_) => Future.value(debtCredit));
      when(() => repository.updateOwed(
        owed: const Owed(
          from: 'mock',
          to: 'mock2',
          amount: 0,
        )
      )).thenAnswer((_) => Future.value(true));
      when(() => repository.updateOwed(
        owed: const Owed(
          from: 'mock',
          to: 'mock3',
          amount: 0,
        )
      )).thenAnswer((_) => Future.value(true));
      when(() => repository.deposit(
        request: const DepositRequest(amount: 0)
      )).thenAnswer((_) => Future.value(response));
      final result = await depositUseCase.execute(
        const DepositInput(
          amount: amount
        )
      );

      // Then
      final expected = DepositOutput(
        data: response,
        isSuccess: true,
        messages: [
          DepositUseCase.transferredToAmount.format(20, 'mock2'),
          DepositUseCase.transferredToAmount.format(80, 'mock3'),
          DepositUseCase.balanceMessage.format(response.balance),
          DepositUseCase.owedToMessage.format(0, 'mock2'),
          DepositUseCase.owedToMessage.format(0, 'mock3'),
        ],
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
