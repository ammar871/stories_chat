part of 'users_cubit.dart';

@immutable
abstract class UsersState {}

class UsersInitial extends UsersState {}
class Loading extends UsersState {}

class Success extends UsersState {
late List<UserData>users;

  Success(this.users);
}

class Error extends UsersState{
  final String msgError;

  Error(this.msgError);
}