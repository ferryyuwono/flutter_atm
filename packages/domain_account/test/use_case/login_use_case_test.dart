import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/get_debt_credit_input_mapper.dart';
import 'package:domain_account/src/use_case/mapper/login_input_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:format/format.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  group('LoginUseCase', () {
    final repository = MockAccountRepository();
    final loginInputMapper = LoginInputMapper();
    final getDebtCreditInputMapper = GetDebtCreditInputMapper();
    final loginUseCase = LoginUseCase(
      repository,
      loginInputMapper,
      getDebtCreditInputMapper,
    );

    setUp(() {});

    test('when execute is called and user has not login, should return correct data', () async {
      // Given
      const username = 'mock';
      const response = Account(
        id: 1,
        username: username,
        balance: 0
      );
      const request = LoginRequest(
        username: username
      );
      const getDebtCreditRequest = GetDebtCreditRequest(
        username: username
      );
      const debtCreditResponse = DebtCredit(
        debts: [
          Owed(
            from: 'mock',
            to: 'mock2',
            amount: 50,
          ),
          Owed(
            from: 'mock',
            to: 'mock3',
            amount: 40,
          ),
        ],
        credits: [
          Owed(
            from: 'mock4',
            to: 'mock',
            amount: 30,
          ),
          Owed(
            from: 'mock5',
            to: 'mock',
            amount: 20,
          ),
        ],
      );

      // When
      when(() => repository.hasLogin()).thenReturn(false);
      when(() => repository.login(request: request))
          .thenAnswer((_) => Future.value(response));
      when(() => repository.getDebtCredit(request: getDebtCreditRequest))
          .thenAnswer((_) => Future.value(debtCreditResponse));
      final result = await loginUseCase.execute(
        const LoginInput(
          username: username
        )
      );

      // Then
      final expected = LoginOutput(
        data: response,
        debtCredit: debtCreditResponse,
        isSuccess: true,
        messages: [
          LoginUseCase.helloMessage.format(response.username),
          LoginUseCase.balanceMessage.format(response.balance),
          LoginUseCase.owedToMessage.format(50, 'mock2'),
          LoginUseCase.owedToMessage.format(40, 'mock3'),
          LoginUseCase.owedFromMessage.format(30, 'mock4'),
          LoginUseCase.owedFromMessage.format(20, 'mock5'),
        ],
      );
      expect(result, expected);
    });
    test('when execute is called and user has login, should return failed data', () async {
      // Given
      const username = 'mock';

      // When
      when(() => repository.hasLogin()).thenReturn(true);
      final result = await loginUseCase.execute(
        const LoginInput(
          username: username
        )
      );

      // Then
      const expected = LoginOutput(
        data: Account(),
        isSuccess: false,
        messages: [LoginUseCase.doubleLoginError],
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
