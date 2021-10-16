import 'package:stories_chat/domian/entityes/text_message_entity/my_chat_entity.dart';
import 'package:stories_chat/domian/entityes/text_message_entity/text_message_entity.dart';
import 'package:stories_chat/domian/entityes/user_entity/user_entity.dart';

abstract class FirebaseRemoteDatasource{

  Future <bool> isSignIn();
  Future<void> signOut();
  Future<String> getCurrentUid();
  Future<void> getCreateCurrentUser(UserEntity userEntity);

  Stream<List<UserEntity>> getAllUsers();
  Stream<List<TextMessageEntity>> getMessages(String channelId);
  Stream<List<MyChatEntity>> getMyChat(String uid);

  Future<void> createOneToOneChatChannel(String uid,String otherUid);
  Future<String> getOneToOneSingleUserChannelId(String uid,String otherUid);
  Future<void> addToMyChat(MyChatEntity myChatEntity);
  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,String channelId);
}