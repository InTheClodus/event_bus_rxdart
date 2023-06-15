part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();
}

/// 发送信息
class EventSendEvent extends EventEvent {
  const EventSendEvent();
  @override
  List<Object> get props => [];
}

/// Message输入框改变
class EventMessageChangedEvent extends EventEvent {
  final String message;

  const EventMessageChangedEvent(this.message);

  @override
  List<Object> get props => [message];
}