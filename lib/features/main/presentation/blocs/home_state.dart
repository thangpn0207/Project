part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}
class Loaded extends HomeState{
  UserModel userModel;
  Loaded({required this.userModel});
}
class Loading extends HomeState{}