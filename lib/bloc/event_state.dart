part of 'event_bloc.dart';

class EventState extends Equatable {
  const EventState({
    this.list = const [],
    this.message = const Message.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  final List<String> list;
  final Message message;
  final FormzSubmissionStatus status;
  final bool isValid;
  EventState copyWith({
    List<String>? list,
    Message? message,
    FormzSubmissionStatus? status,
    bool? isValid,
  }) {
    return EventState(
      list: list ?? this.list,
      message: message ?? this.message,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [list,message,status,isValid];
}
