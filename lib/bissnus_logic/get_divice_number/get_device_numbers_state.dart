part of 'get_device_numbers_cubit.dart';

@immutable
abstract class GetDeviceNumbersState {}
class GetDeviceNumbersInitial extends GetDeviceNumbersState {
  @override
  List<Object> get props => [];
}

class GetDeviceNumbersLoading extends GetDeviceNumbersState {
  @override
  List<Object> get props => [];
}
class GetDeviceNumbersLoaded extends GetDeviceNumbersState {
  final List<ContactEntity> contacts;

  GetDeviceNumbersLoaded({required this.contacts});

  List<Object> get props => [];
}
class GetDeviceNumbersFailure extends GetDeviceNumbersState {
  @override
  List<Object> get props => [];
}