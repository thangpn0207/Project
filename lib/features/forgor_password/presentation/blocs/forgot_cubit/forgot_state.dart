part of 'forgot_cubit.dart';

@immutable
abstract class ForgotState {}

class ForgotInitial extends ForgotState {}

class SendEmailSuccess extends ForgotState {
  final String email;
  SendEmailSuccess({required this.email});
}

class SendEmailFail extends ForgotState {}
