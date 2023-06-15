import 'package:rxdart/rxdart.dart';

class ReplayEventBus {
  final Map<Type, ReplaySubject<dynamic>> _subjectMap = {};

  ReplayEventBus._internal();

  static final ReplayEventBus _singleton = ReplayEventBus._internal();

  factory ReplayEventBus() => _singleton;

  void fire<T>(T data) {
    final type = T;
    var subject = _subjectMap[type];

    if (subject == null) {
      subject = ReplaySubject<T>();
      _subjectMap[type] = subject;
    }

    subject.add(data);
  }

  Stream<T> on<T>() {
    final type = T;
    var subject = _subjectMap[type];

    if (subject == null) {
      subject = ReplaySubject<T>();
      _subjectMap[type] = subject;
    }

    return subject.stream as Stream<T>;
  }

  void dispose<T>() {
    final type = T;
    final subject = _subjectMap[type];

    if (subject != null) {
      subject.close();
      _subjectMap.remove(type);
    }
  }
}