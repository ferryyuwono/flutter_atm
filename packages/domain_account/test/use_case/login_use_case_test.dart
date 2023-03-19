import 'package:domain_account/domain_account.dart';
import 'package:domain_account/src/use_case/mapper/login_input_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  group('LoginUseCase', () {
    final repository = MockAccountRepository();
    final loginInputMapper = LoginInputMapper();
    final loginUseCase = LoginUseCase(
      repository,
      loginInputMapper
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

      // When
      when(() => repository.hasLogin()).thenReturn(false);
      when(() => repository.login(request: request))
          .thenAnswer((_) => Future.value(response));
      final result = await loginUseCase.execute(
        const LoginInput(
          username: username
        )
      );

      // Then
      const expected = LoginOutput(
        data: response,
        isSuccess: true,
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
        errorMessage: LoginUseCase.doubleLoginError,
      );
      expect(result, expected);
    });

    tearDown(() {});
  });
}
