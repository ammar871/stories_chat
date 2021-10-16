part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class LoadingUpload extends ProfileState {}

class Success extends ProfileState {


  Success();
}

class Error extends ProfileState{
  final String msgError;

  Error(this.msgError);
}