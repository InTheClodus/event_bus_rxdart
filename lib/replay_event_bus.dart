import 'package:rxdart/rxdart.dart';

class ReplayEventBus {
  final Map<Type, ReplaySubject<dynamic>> _subjectMap = {};
  final Map<Type, BehaviorSubject<dynamic>> _behaviorSubjectMap = {};

  ReplayEventBus._internal();

  static final ReplayEventBus _singleton = ReplayEventBus._internal();

  factory ReplayEventBus() => _singleton;

  /// 所有发送的事件都会添加到事件流中
  /// 当有订阅时会返回所有的事件
  void fire<T>(T data) {
    final type = T;
    var subject = _subjectMap[type];

    if (subject == null) {
      subject = ReplaySubject<T>();
      _subjectMap[type] = subject;
    }

    subject.add(data);
  }

  /// 只会返回最后一次发送的事件
  /// 当有订阅时会返回最后一次的事件,
  /// 当使用这个方法发送事件时，使用onLatest订阅事件
  void fireLatest<T>(T data) {
    final type = T;
    var subject = _behaviorSubjectMap[type];

    if (subject == null) {
      subject = BehaviorSubject<T>();
      _behaviorSubjectMap[type] = subject;
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

  Stream<T> onLatest<T>() {
    final type = T;
    var subject = _behaviorSubjectMap[type];

    if (subject == null) {
      subject = BehaviorSubject<T>();
      _behaviorSubjectMap[type] = subject;
    }

    return subject.stream as Stream<T>;
  }

  void dispose<T>() {
    final type = T;
    final subject = _subjectMap[type];
    var behaviorSubject = _behaviorSubjectMap[T];

      subject?.close();
      _subjectMap.remove(type);

      behaviorSubject?.close();
      _behaviorSubjectMap.remove(T);

  }
}
