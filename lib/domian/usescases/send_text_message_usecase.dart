import 'package:stories_chat/domian/entityes/text_message_entity/text_message_entity.dart';
import 'package:stories_chat/domian/repostory/firebase_repostory.dart';

class SendTextMessageUseCase{
  final FirebaseRepository repository;

  SendTextMessageUseCase({required this.repository});

  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,String channelId)async{
    return await repository.sendTextMessage(textMessageEntity,channelId);
  }

}