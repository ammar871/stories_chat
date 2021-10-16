
import 'package:stories_chat/domian/entityes/text_message_entity/my_chat_entity.dart';
import 'package:stories_chat/domian/repostory/firebase_repostory.dart';

class GetMyChatUseCase{
  final FirebaseRepository repository;

  GetMyChatUseCase({required this.repository});

  Stream<List<MyChatEntity>> call(String uid){
    return repository.getMyChat(uid);
  }
}
