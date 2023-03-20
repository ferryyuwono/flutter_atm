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
      when(() => repository.hasLogin()).thenReturn(false);
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
    test('when execute is called and user has login, should return success data', () async {
      // Given
      const username = 'mock';
      const amount = 100;
      const response = Account(
        id: 1,
        username: username,
        balance: 100
      );

      // When
      when(() => repository.hasLogin()).thenReturn(true);
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

    tearDown(() {});
  });
}
