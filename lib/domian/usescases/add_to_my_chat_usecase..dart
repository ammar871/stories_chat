import 'package:stories_chat/domian/entityes/text_message_entity/my_chat_entity.dart';
import 'package:stories_chat/domian/repostory/firebase_repostory.dart';

class AddToMyChatUseCase{
  final FirebaseRepository repository;

  AddToMyChatUseCase({required this.repository});

  Future<void> call(MyChatEntity myChatEntity)async{
    return await repository.addToMyChat(myChatEntity);
  }
}