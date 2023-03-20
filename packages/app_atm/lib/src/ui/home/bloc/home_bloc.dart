import 'dart:async';

import 'package:domain_account/domain_account.dart';
import 'package:app_atm/app_atm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

abstract class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(super.initialState);
}

@Injectable(as: HomeBloc)
class HomeBlocImpl extends HomeBloc {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final DepositUseCase _depositUseCase;
  final WithdrawUseCase _withdrawUseCase;
  final IsLoginCommandUseCase _isLoginCommandUseCase;
  final IsLogoutCommandUseCase _isLogoutCommandUseCase;
  final IsDepositCommandUseCase _isDepositCommandUseCase;
  final IsWithdrawCommandUseCase _isWithdrawCommandUseCase;

  HomeBlocImpl(
    this._loginUseCase,
    this._logoutUseCase,
    this._depositUseCase,
    this._withdrawUseCase,
    this._isLoginCommandUseCase,
    this._isLogoutCommandUseCase,
    this._isDepositCommandUseCase,
    this._isWithdrawCommandUseCase,
  ) : super(HomeState()) {
    on<HomeTypeCommandEvent>(
      _onHomeTypeCommandEvent,
    );

    on<HomeSendCommandEvent>(
      _onHomeSendCommandEvent,
    );
  }

  FutureOr<void> _onHomeTypeCommandEvent(HomeTypeCommandEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      typedCommand: event.command,
    ));
  }

  FutureOr<void> _onHomeSendCommandEvent(HomeSendCommandEvent event, Emitter<HomeState> emit) async {
    if (event.command.isEmpty) {
      return;
    }

    final isLoginCommandOutput = await _isLoginCommandUseCase.execute(event.command);
    if (isLoginCommandOutput.isMatchCommand) {
      await _handleLoginCommand(emit: emit, output: isLoginCommandOutput);
      return;
    }

    final isDepositCommandOutput = await _isDepositCommandUseCase.execute(event.command);
    if (isDepositCommandOutput.isMatchCommand) {
      await _handleDepositCommand(emit: emit, output: isDepositCommandOutput);
      return;
    }

    final isWithdrawCommandOutput = await _isWithdrawCommandUseCase.execute(event.command);
    if (isWithdrawCommandOutput.isMatchCommand) {
      await _handleWithdrawCommand(emit: emit, output: isWithdrawCommandOutput);
      return;
    }

    final isLogoutCommandOutput = await _isLogoutCommandUseCase.execute(event.command);
    if (isLogoutCommandOutput.isMatchCommand) {
      await _handleLogoutCommand(emit: emit, output: isLogoutCommandOutput);
      return;
    }

    emit(state.copyWith(
      typedCommand: '',
      logList: [
        ...state.logList,
        isLogoutCommandOutput.command,
        ...isLogoutCommandOutput.messages
      ],
    ));
  }

  Future<void> _handleLoginCommand({
    required Emitter<HomeState> emit,
    required IsLoginCommandOutput output,
  }) async {
    if (!output.isValidCommand) {
      emit(state.copyWith(
        typedCommand: '',
        logList: [...state.logList, output.command, ...output.messages],
      ));
      return;
    }

    emit(state.copyWith(
      typedCommand: '',
      logList: [...state.logList, output.command],
      isLoading: true,
    ));
    await _login(
      emit: emit,
      request: LoginInput(username: output.username),
    );
  }

  Future<void> _login({
    required Emitter<HomeState> emit,
    required LoginInput request,
  }) async {
    final output = await _loginUseCase.execute(request);
    emit(state.copyWith(
      logList: [...state.logList, ...output.messages],
      isLoading: false,
    ));
  }

  Future<void> _handleLogoutCommand({
    required Emitter<HomeState> emit,
    required IsLogoutCommandOutput output,
  }) async {
    if (!output.isValidCommand) {
      emit(state.copyWith(
        typedCommand: '',
        logList: [...state.logList, output.command, ...output.messages],
      ));
      return;
    }

    emit(state.copyWith(
      typedCommand: '',
      logList: [...state.logList, output.command],
      isLoading: true,
    ));
    await _logout(
      emit: emit,
      request: const LogoutInput(),
    );
  }

  Future<void> _logout({
    required Emitter<HomeState> emit,
    required LogoutInput request,
  }) async {
    final output = await _logoutUseCase.execute(request);
    emit(state.copyWith(
      logList: [...state.logList, ...output.messages],
      isLoading: false,
    ));
  }

  Future<void> _handleDepositCommand({
    required Emitter<HomeState> emit,
    required IsDepositCommandOutput output,
  }) async {
    if (!output.isValidCommand) {
      emit(state.copyWith(
        typedCommand: '',
        logList: [...state.logList, output.command, ...output.messages],
      ));
      return;
    }

    emit(state.copyWith(
      typedCommand: '',
      logList: [...state.logList, output.command],
      isLoading: true,
    ));
    await _deposit(
      emit: emit,
      request: DepositInput(amount: output.amount),
    );
  }

  Future<void> _deposit({
    required Emitter<HomeState> emit,
    required DepositInput request,
  }) async {
    final output = await _depositUseCase.execute(request);
    emit(state.copyWith(
      logList: [...state.logList, ...output.messages],
      isLoading: false,
    ));
  }

  Future<void> _handleWithdrawCommand({
    required Emitter<HomeState> emit,
    required IsWithdrawCommandOutput output,
  }) async {
    if (!output.isValidCommand) {
      emit(state.copyWith(
        typedCommand: '',
        logList: [...state.logList, output.command, ...output.messages],
      ));
      return;
    }

    emit(state.copyWith(
      typedCommand: '',
      logList: [...state.logList, output.command],
      isLoading: true,
    ));
    await _withdraw(
      emit: emit,
      request: WithdrawInput(amount: output.amount),
    );
  }

  Future<void> _withdraw({
    required Emitter<HomeState> emit,
    required WithdrawInput request,
  }) async {
    final output = await _withdrawUseCase.execute(request);
    emit(state.copyWith(
      logList: [...state.logList, ...output.messages],
      isLoading: false,
    ));
  }
}
