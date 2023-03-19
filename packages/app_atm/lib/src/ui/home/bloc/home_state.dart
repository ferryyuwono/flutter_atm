import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default([]) List<String> logList,
    @Default('') String typedCommand,
    @Default(false) bool isLoading,
  }) = _HomeState;
}
