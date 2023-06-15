import 'package:formz/formz.dart';

enum MessageValidationError { empty }

class Message extends FormzInput<String, MessageValidationError> {
  const Message.pure() : super.pure('');
  const Message.dirty([super.value = '']) : super.dirty();

  @override
  MessageValidationError? validator(String value) {
    if (value.isEmpty) return MessageValidationError.empty;
    return null;
  }
}