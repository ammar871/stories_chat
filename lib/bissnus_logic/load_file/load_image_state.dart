part of 'load_image_cubit.dart';

@immutable
abstract class LoadImageState {}

class LoadImageInitial extends LoadImageState {}
class LoadingUploadFile extends LoadImageState {
 final double progress;

 LoadingUploadFile(this.progress);
}

class DawnloadUploadFile extends LoadImageState {
  final double progress;

  DawnloadUploadFile(this.progress);
}

class SuccessFile extends LoadImageState {


  SuccessFile();
}

class ErrorFile extends LoadImageState{
  final String msgError;

  ErrorFile(this.msgError);}