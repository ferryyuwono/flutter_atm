import 'package:bloc_test/bloc_test.dart';
import 'package:app_atm/app_atm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:domain_account/domain_account.dart';
import 'package:format/format.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockDepositUseCase extends Mock implements DepositUseCase {}
class MockWithdrawUseCase extends Mock implements WithdrawUseCase {}
class MockTransferUseCase extends Mock implements TransferUseCase {}
class MockIsLoginCommandUseCase extends Mock implements IsLoginCommandUseCase {}
class MockIsLogoutCommandUseCase extends Mock implements IsLogoutCommandUseCase {}
class MockIsDepositCommandUseCase extends Mock implements IsDepositCommandUseCase {}
class MockIsWithdrawCommandUseCase extends Mock implements IsWithdrawCommandUseCase {}
class MockIsTransferCommandUseCase extends Mock implements IsTransferCommandUseCase {}

void main() {
  group('HomeBlocImpl', () {
    late HomeBlocImpl bloc;
    final loginUseCase = MockLoginUseCase();
    final logoutUseCase = MockLogoutUseCase();
    final depositUseCase = MockDepositUseCase();
    final withdrawUseCase = MockWithdrawUseCase();
    final transferUseCase = MockTransferUseCase();
    final isLoginCommandUseCase = MockIsLoginCommandUseCase();
    final isLogoutCommandUseCase = MockIsLogoutCommandUseCase();
    final isDepositCommandUseCase = MockIsDepositCommandUseCase();
    final isWithdrawCommandUseCase = MockIsWithdrawCommandUseCase();
    final isTransferCommandUseCase = MockIsTransferCommandUseCase();

    setUp(() {
      bloc = HomeBlocImpl(
        loginUseCase,
        logoutUseCase,
        depositUseCase,
        withdrawUseCase,
        transferUseCase,
        isLoginCommandUseCase,
        isLogoutCommandUseCase,
        isDepositCommandUseCase,
        isWithdrawCommandUseCase,
        isTransferCommandUseCase,
      );
    });

    test('when created, should has correct initialState', () {
      expect(bloc.state, HomeState());
    });

    blocTest<HomeBloc, HomeState>(
      'when input HomeTypeCommandEvent, should return type command',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const HomeTypeCommandEvent(
          command: 'login'
        ));
      },
      expect: () => <HomeState>[
        HomeState(
          typedCommand: 'login'
        ),
      ],
    );

    // Login
    blocTest<HomeBloc, HomeState>(
      'when input HomeSendCommandEvent login invalid, should return invalid log list',
      setUp: () {
        when(() => isLoginCommandUseCase.execute('login'))
            .thenAnswer((_) => Future.value(
            const IsLoginCommandOutput(
              command: '\$ login',
              isMatchCommand: true,
              isValidCommand: false,
              messages: [
                IsLoginCommandUseCase.missingInputParameter
              ]
            )
        ));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const HomeSendCommandEvent(
            command: 'login'
        ));
      },
      expect: () => <HomeState>[
        HomeState(typedCommand: '', logList: ['\$ login', IsLoginCommandUseCase.missingInputParameter]),
      ],
    );
    blocTest<HomeBloc, HomeState>(
      'when input HomeSendCommandEvent login, should return log list',
      setUp: () {
        when(() => isLoginCommandUseCase.execute('login ferry'))
          .thenAnswer((_) => Future.value(
            const IsLoginCommandOutput(
              command: '\$ login ferry',
              isMatchCommand: true,
              isValidCommand: true,
              username: 'ferry',
            )
        ));
        when(() => loginUseCase.execute(const LoginInput(username: 'ferry')))
            .thenAnswer((_) => Future.value(
              LoginOutput(
                data: const Account(),
                debtCredit: const DebtCredit(),
                isSuccess: true,
                messages: [
                  LoginUseCase.helloMessage.format('ferry'),
                  LoginUseCase.balanceMessage.format(0),
                ]
              )
        ));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const HomeSendCommandEvent(
          command: 'login ferry'
        ));
      },
      expect: () => <HomeState>[
        HomeState(typedCommand: '', logList: ['\$ login ferry'], isLoading: true),
        HomeState(typedCommand: '', logList: [
          '\$ login ferry',
          LoginUseCase.helloMessage.format('ferry'),
          LoginUseCase.balanceMessage.format(0),
        ], isLoading: false),
      ],
    );

    // Deposit
    blocTest<HomeBloc, HomeState>(
      'when input HomeSendCommandEvent deposit invalid, should return invalid log list',
      setUp: () {
        when(() => isLoginCommandUseCase.execute('deposit mock'))
            .thenAnswer((_) => Future.value(
            const IsLoginCommandOutput(
                command: '\$ deposit mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isDepositCommandUseCase.execute('deposit mock'))
            .thenAnswer((_) => Future.value(
            const IsDepositCommandOutput(
                command: '\$ deposit mock',
                isMatchCommand: true,
                isValidCommand: false,
                messages: [
                  IsDepositCommandUseCase.missingInputParameter
                ]
            )
        ));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const HomeSendCommandEvent(
            command: 'deposit mock'
        ));
      },
      expect: () => <HomeState>[
        HomeState(typedCommand: '', logList: ['\$ deposit mock', IsDepositCommandUseCase.missingInputParameter]),
      ],
    );
    blocTest<HomeBloc, HomeState>(
      'when input HomeSendCommandEvent deposit, should return log list',
      setUp: () {
        when(() => isLoginCommandUseCase.execute('deposit'))
            .thenAnswer((_) => Future.value(
            const IsLoginCommandOutput(
                command: '\$ deposit',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isDepositCommandUseCase.execute('deposit'))
            .thenAnswer((_) => Future.value(
            const IsDepositCommandOutput(
                command: '\$ deposit',
                isMatchCommand: true,
                isValidCommand: true,
                amount: 100
            )
        ));
        when(() => depositUseCase.execute(const DepositInput(amount: 100)))
            .thenAnswer((_) => Future.value(
            DepositOutput(
                isSuccess: true,
                messages: [
                  DepositUseCase.balanceMessage.format(100),
                ]
            )
        ));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const HomeSendCommandEvent(
            command: 'deposit'
        ));
      },
      expect: () => <HomeState>[
        HomeState(typedCommand: '', logList: ['\$ deposit'], isLoading: true),
        HomeState(typedCommand: '', logList: [
          '\$ deposit',
          DepositUseCase.balanceMessage.format(100),
        ], isLoading: false),
      ],
    );

    // Withdraw
    blocTest<HomeBloc, HomeState>(
      'when input HomeSendCommandEvent withdraw invalid, should return invalid log list',
      setUp: () {
        when(() => isLoginCommandUseCase.execute('withdraw mock'))
            .thenAnswer((_) => Future.value(
            const IsLoginCommandOutput(
                command: '\$ withdraw mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isDepositCommandUseCase.execute('withdraw mock'))
            .thenAnswer((_) => Future.value(
            const IsDepositCommandOutput(
                command: '\$ withdraw mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isWithdrawCommandUseCase.execute('withdraw mock'))
            .thenAnswer((_) => Future.value(
            const IsWithdrawCommandOutput(
                command: '\$ withdraw mock',
                isMatchCommand: true,
                isValidCommand: false,
                messages: [
                  IsWithdrawCommandUseCase.missingInputParameter
                ]
            )
        ));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const HomeSendCommandEvent(
            command: 'withdraw mock'
        ));
      },
      expect: () => <HomeState>[
        HomeState(typedCommand: '', logList: ['\$ withdraw mock', IsWithdrawCommandUseCase.missingInputParameter]),
      ],
    );
    blocTest<HomeBloc, HomeState>(
      'when input HomeSendCommandEvent withdraw, should return log list',
      setUp: () {
        when(() => isLoginCommandUseCase.execute('withdraw'))
            .thenAnswer((_) => Future.value(
            const IsLoginCommandOutput(
                command: '\$ withdraw',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isDepositCommandUseCase.execute('withdraw'))
            .thenAnswer((_) => Future.value(
            const IsDepositCommandOutput(
                command: '\$ withdraw mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isWithdrawCommandUseCase.execute('withdraw'))
            .thenAnswer((_) => Future.value(
            const IsWithdrawCommandOutput(
                command: '\$ withdraw',
                isMatchCommand: true,
                isValidCommand: true,
                amount: 100
            )
        ));
        when(() => withdrawUseCase.execute(const WithdrawInput(amount: 100)))
            .thenAnswer((_) => Future.value(
            WithdrawOutput(
                isSuccess: true,
                messages: [
                  WithdrawUseCase.balanceMessage.format(100),
                ]
            )
        ));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const HomeSendCommandEvent(
            command: 'withdraw'
        ));
      },
      expect: () => <HomeState>[
        HomeState(typedCommand: '', logList: ['\$ withdraw'], isLoading: true),
        HomeState(typedCommand: '', logList: [
          '\$ withdraw',
          WithdrawUseCase.balanceMessage.format(100),
        ], isLoading: false),
      ],
    );

    // Transfer
    blocTest<HomeBloc, HomeState>(
      'when input HomeSendCommandEvent transfer invalid, should return invalid log list',
      setUp: () {
        when(() => isLoginCommandUseCase.execute('transfer mock'))
            .thenAnswer((_) => Future.value(
            const IsLoginCommandOutput(
                command: '\$ transfer mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isDepositCommandUseCase.execute('transfer mock'))
            .thenAnswer((_) => Future.value(
            const IsDepositCommandOutput(
                command: '\$ transfer mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isWithdrawCommandUseCase.execute('transfer mock'))
            .thenAnswer((_) => Future.value(
            const IsWithdrawCommandOutput(
                command: '\$ transfer mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isTransferCommandUseCase.execute('transfer mock'))
            .thenAnswer((_) => Future.value(
            const IsTransferCommandOutput(
                command: '\$ transfer mock',
                isMatchCommand: true,
                isValidCommand: false,
                messages: [
                  IsTransferCommandUseCase.missingInputParameter
                ]
            )
        ));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const HomeSendCommandEvent(
            command: 'transfer mock'
        ));
      },
      expect: () => <HomeState>[
        HomeState(typedCommand: '', logList: ['\$ transfer mock', IsTransferCommandUseCase.missingInputParameter]),
      ],
    );
    blocTest<HomeBloc, HomeState>(
      'when input HomeSendCommandEvent transfer, should return log list',
      setUp: () {
        when(() => isLoginCommandUseCase.execute('transfer'))
            .thenAnswer((_) => Future.value(
            const IsLoginCommandOutput(
                command: '\$ transfer',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isDepositCommandUseCase.execute('transfer'))
            .thenAnswer((_) => Future.value(
            const IsDepositCommandOutput(
                command: '\$ transfer mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isWithdrawCommandUseCase.execute('transfer'))
            .thenAnswer((_) => Future.value(
            const IsWithdrawCommandOutput(
                command: '\$ transfer mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isTransferCommandUseCase.execute('transfer'))
            .thenAnswer((_) => Future.value(
            const IsTransferCommandOutput(
                command: '\$ transfer',
                isMatchCommand: true,
                isValidCommand: true,
                transferTo: 'mock2',
                amount: 100
            )
        ));
        when(() => transferUseCase.execute(const TransferInput(transferTo: 'mock2', amount: 100)))
            .thenAnswer((_) => Future.value(
            TransferOutput(
                isSuccess: true,
                messages: [
                  TransferUseCase.balanceMessage.format(100),
                ]
            )
        ));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const HomeSendCommandEvent(
            command: 'transfer'
        ));
      },
      expect: () => <HomeState>[
        HomeState(typedCommand: '', logList: ['\$ transfer'], isLoading: true),
        HomeState(typedCommand: '', logList: [
          '\$ transfer',
          TransferUseCase.balanceMessage.format(100),
        ], isLoading: false),
      ],
    );

    // Logout
    blocTest<HomeBloc, HomeState>(
      'when input HomeSendCommandEvent logout invalid, should return invalid log list',
      setUp: () {
        when(() => isLoginCommandUseCase.execute('logout mock'))
            .thenAnswer((_) => Future.value(
            const IsLoginCommandOutput(
                command: '\$ logout mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isDepositCommandUseCase.execute('logout mock'))
            .thenAnswer((_) => Future.value(
            const IsDepositCommandOutput(
                command: '\$ logout mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isWithdrawCommandUseCase.execute('logout mock'))
            .thenAnswer((_) => Future.value(
            const IsWithdrawCommandOutput(
                command: '\$ logout mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isTransferCommandUseCase.execute('logout mock'))
            .thenAnswer((_) => Future.value(
            const IsTransferCommandOutput(
                command: '\$ logout mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isLogoutCommandUseCase.execute('logout mock'))
            .thenAnswer((_) => Future.value(
            const IsLogoutCommandOutput(
                command: '\$ logout mock',
                isMatchCommand: true,
                isValidCommand: false,
                messages: [
                  IsLogoutCommandUseCase.tooMuchParameter
                ]
            )
        ));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const HomeSendCommandEvent(
            command: 'logout mock'
        ));
      },
      expect: () => <HomeState>[
        HomeState(typedCommand: '', logList: ['\$ logout mock', IsLogoutCommandUseCase.tooMuchParameter]),
      ],
    );
    blocTest<HomeBloc, HomeState>(
      'when input HomeSendCommandEvent logout, should return log list',
      setUp: () {
        when(() => isLoginCommandUseCase.execute('logout'))
            .thenAnswer((_) => Future.value(
            const IsLoginCommandOutput(
                command: '\$ logout',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isDepositCommandUseCase.execute('logout'))
            .thenAnswer((_) => Future.value(
            const IsDepositCommandOutput(
                command: '\$ logout mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isWithdrawCommandUseCase.execute('logout'))
            .thenAnswer((_) => Future.value(
            const IsWithdrawCommandOutput(
                command: '\$ logout mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isTransferCommandUseCase.execute('logout'))
            .thenAnswer((_) => Future.value(
            const IsTransferCommandOutput(
                command: '\$ logout mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isLogoutCommandUseCase.execute('logout'))
            .thenAnswer((_) => Future.value(
            const IsLogoutCommandOutput(
                command: '\$ logout',
                isMatchCommand: true,
                isValidCommand: true,
            )
        ));
        when(() => logoutUseCase.execute(const LogoutInput()))
            .thenAnswer((_) => Future.value(
            LogoutOutput(
                isSuccess: true,
                messages: [
                  LogoutUseCase.goodbyeMessage.format('ferry'),
                ]
            )
        ));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const HomeSendCommandEvent(
            command: 'logout'
        ));
      },
      expect: () => <HomeState>[
        HomeState(typedCommand: '', logList: ['\$ logout'], isLoading: true),
        HomeState(typedCommand: '', logList: [
          '\$ logout',
          LogoutUseCase.goodbyeMessage.format('ferry'),
        ], isLoading: false),
      ],
    );

    // Unrecognized
    blocTest<HomeBloc, HomeState>(
      'when input HomeSendCommandEvent logout invalid, should return invalid log list',
      setUp: () {
        when(() => isLoginCommandUseCase.execute('logout mock'))
            .thenAnswer((_) => Future.value(
            const IsLoginCommandOutput(
                command: '\$ logout mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isDepositCommandUseCase.execute('logout mock'))
            .thenAnswer((_) => Future.value(
            const IsDepositCommandOutput(
                command: '\$ logout mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isWithdrawCommandUseCase.execute('logout mock'))
            .thenAnswer((_) => Future.value(
            const IsWithdrawCommandOutput(
                command: '\$ logout mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isTransferCommandUseCase.execute('logout mock'))
            .thenAnswer((_) => Future.value(
            const IsTransferCommandOutput(
                command: '\$ logout mock',
                isMatchCommand: false,
                messages: [
                  IsLoginCommandUseCase.unrecognizedCommand
                ]
            )
        ));
        when(() => isLogoutCommandUseCase.execute('logout mock'))
            .thenAnswer((_) => Future.value(
            const IsLogoutCommandOutput(
                command: '\$ logout mock',
                isMatchCommand: false,
                isValidCommand: false,
                messages: [
                  IsLogoutCommandUseCase.unrecognizedCommand
                ]
            )
        ));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const HomeSendCommandEvent(
            command: 'logout mock'
        ));
      },
      expect: () => <HomeState>[
        HomeState(typedCommand: '', logList: ['\$ logout mock', IsLogoutCommandUseCase.unrecognizedCommand]),
      ],
    );

    tearDown(() {
      bloc.close();
    });
  });
}
