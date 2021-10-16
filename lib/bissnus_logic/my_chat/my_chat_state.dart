part of 'my_chat_cubit.dart';

@immutable
abstract class MyChatState {
  const MyChatState();
}

class MyChatInitial extends MyChatState {
  @override
  List<Object> get props => [];
}
class MyChatLoaded extends MyChatState {
  final List<MyChatEntity> myChat;

  MyChatLoaded({required this.myChat});
  @override
  List<Object> get props => [myChat];
}