import 'dart:async';

import 'package:baby_book/bus.dart';
import 'package:baby_book/main.dart';
import 'package:baby_book/models/message.dart';
import 'package:baby_book/replay_event_bus.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'event_event.dart';

part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super(const EventState()) {
    on<EventEvent>((event, emit) {});
    on<EventSendEvent>(_onEventSendEvent);
    on<EventMessageChangedEvent>(_onEventMessageChangedEvent);
  }

  void _onEventSendEvent(EventSendEvent event, Emitter<EventState> emit) {
    List<String> list =[];
    if(state.isValid){
      list.add(state.message.value);
      ReplayEventBus().fire<MyEvent>(MyEvent(state.message.value));
      bus.emit("eventName",state.message.value);
    }
    if(state.list.isNotEmpty){
      list.insertAll(0,state.list);
    }
    print("----$list");
    emit(
      state.copyWith(
        list: list,
        message: const Message.pure(),
        isValid: false,
        status: FormzSubmissionStatus.success,
      ),
    );
  }

  void _onEventMessageChangedEvent(
      EventMessageChangedEvent event, Emitter<EventState> emit) {
    final message = Message.dirty(event.message);
    emit(
      state.copyWith(
        message: message,
        isValid: Formz.validate([message]),
      ),
    );
  }
}
