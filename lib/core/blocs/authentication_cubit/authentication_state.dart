part of 'authentication_cubit.dart';

abstract class AuthenticationState{
  const AuthenticationState();
}
class AuthenticationStateInitial extends AuthenticationState{
}
class AuthenticationStateSuccess extends AuthenticationState{
  const AuthenticationStateSuccess();
}
class AuthenticationStateFail extends AuthenticationState{}