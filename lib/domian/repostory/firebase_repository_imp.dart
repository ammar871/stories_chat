import 'package:stories_chat/data/datasource/firebase_remote_datasours.dart';
import 'package:stories_chat/domian/entityes/text_message_entity/my_chat_entity.dart';
import 'package:stories_chat/domian/entityes/text_message_entity/text_message_entity.dart';
import 'package:stories_chat/domian/entityes/user_entity/user_entity.dart';

import 'firebase_repostory.dart';

class FirebaseRepositoryImpl implements FirebaseRepository{
  final FirebaseRemoteDatasource remoteDataSource;


  FirebaseRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async =>
      await remoteDataSource.getCreateCurrentUser(user);

  @override
  Future<String> getCurrentUid()async =>
      await remoteDataSource.getCurrentUid();
  @override
  Future<bool> isSignIn()async =>
      await remoteDataSource.isSignIn();

  @override
  Future<void> signOut() async =>
      await remoteDataSource.signOut();

  @override
  Future<void> addToMyChat(MyChatEntity myChatEntity) async{
    return remoteDataSource.addToMyChat(myChatEntity);
  }

  @override
  Future<void> createOneToOneChatChannel(String uid, String otherUid) async
  => remoteDataSource.createOneToOneChatChannel(uid, otherUid);

  @override
  Stream<List<UserEntity>> getAllUsers() =>
      remoteDataSource.getAllUsers();

  @override
  Stream<List<TextMessageEntity>> getMessages(String channelId) {
    return remoteDataSource.getMessages(channelId);
  }

  @override
  Stream<List<MyChatEntity>> getMyChat(String uid) {
    return remoteDataSource.getMyChat(uid);
  }

  @override
  Future<String> getOneToOneSingleUserChannelId(String uid, String otherUid) =>
      remoteDataSource.getOneToOneSingleUserChannelId(uid, otherUid);

  @override
  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,String channelId)async {
    return remoteDataSource.sendTextMessage(textMessageEntity, channelId);
  }

}







