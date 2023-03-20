import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.freezed.dart';

abstract class HomeEvent {}

@freezed
class HomeSendCommandEvent extends HomeEvent with _$HomeSendCommandEvent {
  const factory HomeSendCommandEvent({
    required String command,
  }) = _HomeSendCommandEvent;
}

@freezed
class HomeTypeCommandEvent extends HomeEvent with _$HomeTypeCommandEvent {
  const factory HomeTypeCommandEvent({
    required String command,
  }) = _HomeTypeCommandEvent;
}
