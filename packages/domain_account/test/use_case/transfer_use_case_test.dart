import 'package:domain_account/domain_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:format/format.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  group('TransferUseCase', () {
    final repository = MockAccountRepository();
    final transferUseCase = TransferUseCase(
      repository,
    );

    setUp(() {});

    test('when execute is called and user has not login, should return authentication data', () async {
      // Given
      const transferTo = 'mock';
      const amount = 100;

      // When
      when(() => repository.getLoginAccount()).thenReturn(const Account());
      final result = await transferUseCase.execute(
        const TransferInput(
          transferTo: transferTo,
          amount: amount
        )
      );

      // Then
      const expected = TransferOutput(
        isSuccess: false,
        messages: [
          TransferUseCase.authenticationError,
        ],
      );
      expect(result, expected);
    });

    test('when execute is called and user has login and transfer to not found, should return user not found data', () async {
      // Given
      const transferTo = 'mock2';
      const amount = 100;
      const account = Account(
        id: 1,
        username: 'mock',
        balance: 100
      );

      // When
      when(() => repository.getLoginAccount()).thenReturn(account);
      when(() => repository.hasAccount(transferTo))
        .thenAnswer((_) => Future.value(false));
      final result = await transferUseCase.execute(
        const TransferInput(
          transferTo: transferTo,
          amount: amount
        )
      );

      // Then
      final expected = TransferOutput(
        isSuccess: false,
        messages: [
          TransferUseCase.userNotFound.format(transferTo),
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and user has login and transfer to is found case 1, should return success data', () async {
      // Given
      const transferTo = 'mock2';
      const username = 'mock';
      const amount = 100;
      const account = Account(
        id: 1,
        username: username,
        balance: 50
      );
      const debtCredit = DebtCredit(
        credits: [
          Owed(
            from: 'mock2',
            to: 'mock',
            amount: 30
          ),
        ],
        debts: [
          Owed(
            from: 'mock',
            to: 'mock2',
            amount: 10
          ),
        ]
      );
      const newAccount = Account(
        id: 1,
        username: username,
        balance: 0
      );

      // When
      when(() => repository.getLoginAccount()).thenReturn(account);
      when(() => repository.hasAccount(transferTo))
        .thenAnswer((_) => Future.value(true));
      when(() => repository.transfer(
        request: const TransferRequest(
          transferTo: transferTo,
          amount: amount,
        )
      )).thenAnswer((_) => Future.value(account));
      when(() => repository.getDebtCredit(
        request: const GetDebtCreditRequest(
          username: username,
        )
      )).thenAnswer((_) => Future.value(debtCredit));
      when(() => repository.updateOwed(
        owed: const Owed(
          from: 'mock2',
          to: 'mock',
          amount: 0
        )
      )).thenAnswer((_) => Future.value(true));
      when(() => repository.updateOwed(
        owed: const Owed(
          from: 'mock',
          to: 'mock2',
          amount: 30
        )
      )).thenAnswer((_) => Future.value(true));
      when(() => repository.transfer(
        request: const TransferRequest(
          transferTo: transferTo,
          amount: 50,
        )
      )).thenAnswer((_) => Future.value(newAccount));
      final result = await transferUseCase.execute(
        const TransferInput(
          transferTo: transferTo,
          amount: amount
        )
      );

      // Then
      final expected = TransferOutput(
        data: newAccount,
        isSuccess: true,
        messages: [
          TransferUseCase.transferredToAmountFound.format(50, transferTo),
          TransferUseCase.balanceMessage.format(0),
          TransferUseCase.owedFromMessage.format(0, transferTo),
          TransferUseCase.owedToMessage.format(30, transferTo),
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and user has login and transfer to is found case 2, should return success data', () async {
      // Given
      const transferTo = 'mock2';
      const username = 'mock';
      const amount = 100;
      const account = Account(
        id: 1,
        username: username,
        balance: 50
      );
      const debtCredit = DebtCredit(
        credits: [
          Owed(
            from: 'mock2',
            to: 'mock',
            amount: 110
          ),
        ],
        debts: [
          Owed(
            from: 'mock',
            to: 'mock2',
            amount: 10
          ),
        ]
      );
      const newAccount = Account(
        id: 1,
        username: username,
        balance: 50
      );

      // When
      when(() => repository.getLoginAccount()).thenReturn(account);
      when(() => repository.hasAccount(transferTo))
          .thenAnswer((_) => Future.value(true));
      when(() => repository.transfer(
          request: const TransferRequest(
            transferTo: transferTo,
            amount: amount,
          )
      )).thenAnswer((_) => Future.value(account));
      when(() => repository.getDebtCredit(
          request: const GetDebtCreditRequest(
            username: username,
          )
      )).thenAnswer((_) => Future.value(debtCredit));
      when(() => repository.updateOwed(
          owed: const Owed(
              from: 'mock2',
              to: 'mock',
              amount: 10
          )
      )).thenAnswer((_) => Future.value(true));
      when(() => repository.updateOwed(
          owed: const Owed(
              from: 'mock',
              to: 'mock2',
              amount: 10
          )
      )).thenAnswer((_) => Future.value(true));
      when(() => repository.transfer(
          request: const TransferRequest(
            transferTo: transferTo,
            amount: 0,
          )
      )).thenAnswer((_) => Future.value(newAccount));
      final result = await transferUseCase.execute(
          const TransferInput(
              transferTo: transferTo,
              amount: amount
          )
      );

      // Then
      final expected = TransferOutput(
        data: newAccount,
        isSuccess: true,
        messages: [
          TransferUseCase.transferredToAmountFound.format(0, transferTo),
          TransferUseCase.balanceMessage.format(50),
          TransferUseCase.owedFromMessage.format(10, transferTo),
          TransferUseCase.owedToMessage.format(10, transferTo),
        ],
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
