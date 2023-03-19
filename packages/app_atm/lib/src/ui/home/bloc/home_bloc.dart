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
  final IsLoginCommandUseCase _isLoginCommandUseCase;
  final IsLogoutCommandUseCase _isLogoutCommandUseCase;

  HomeBlocImpl(
    this._loginUseCase,
    this._logoutUseCase,
    this._isLoginCommandUseCase,
    this._isLogoutCommandUseCase,
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
      request: LogoutInput(username: output.username),
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
}
