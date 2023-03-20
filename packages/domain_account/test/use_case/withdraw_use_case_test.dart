import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/withdraw_input_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:format/format.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  group('WithdrawUseCase', () {
    final repository = MockAccountRepository();
    final withdrawInputMapper = WithdrawInputMapper();
    final withdrawUseCase = WithdrawUseCase(
      repository,
      withdrawInputMapper
    );

    setUp(() {});

    test('when execute is called and user has not login, should return authentication data', () async {
      // Given
      const amount = 100;

      // When
      when(() => repository.hasLogin()).thenReturn(false);
      final result = await withdrawUseCase.execute(
        const WithdrawInput(
          amount: amount
        )
      );

      // Then
      const expected = WithdrawOutput(
        data: Account(),
        isSuccess: false,
        messages: [
          WithdrawUseCase.authenticationError,
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and user has login and insufficient balance, should return insufficient balance data', () async {
      // Given
      const username = 'mock';
      const amount = 100;
      const response = Account(
        id: 1,
        username: username,
        balance: 0
      );

      // When
      when(() => repository.hasLogin()).thenReturn(true);
      when(() => repository.getLoginAccount()).thenReturn(response);
      final result = await withdrawUseCase.execute(
        const WithdrawInput(
          amount: amount
        )
      );

      // Then
      final expected = WithdrawOutput(
        data: response,
        isSuccess: false,
        messages: [
          WithdrawUseCase.insufficientBalanceMessage.format(response.balance)
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and user has login and has enough balance, should return success data', () async {
      // Given
      const username = 'mock';
      const amount = 100;
      const loginResponse = Account(
        id: 1,
        username: username,
        balance: 100
      );
      const response = Account(
        id: 1,
        username: username,
        balance: 100
      );

      // When
      when(() => repository.hasLogin()).thenReturn(true);
      when(() => repository.getLoginAccount()).thenReturn(loginResponse);
      when(() => repository.withdraw(
        request: const WithdrawRequest(amount: amount)
      )).thenAnswer((_) => Future.value(response));
      final result = await withdrawUseCase.execute(
        const WithdrawInput(
          amount: amount
        )
      );

      // Then
      final expected = WithdrawOutput(
        data: response,
        isSuccess: true,
        messages: [
          WithdrawUseCase.balanceMessage.format(response.balance)
        ],
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
