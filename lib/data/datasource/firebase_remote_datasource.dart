import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stories_chat/data/models/mychat_model.dart';
import 'package:stories_chat/data/models/text_message_model.dart';
import 'package:stories_chat/data/models/user_model.dart';
import 'package:stories_chat/domian/entityes/text_message_entity/my_chat_entity.dart';
import 'package:stories_chat/domian/entityes/text_message_entity/text_message_entity.dart';
import 'package:stories_chat/domian/entityes/user_entity/user_entity.dart';

import 'firebase_remote_datasours.dart';

class FirebaseRemoteDatasourceImpl extends FirebaseRemoteDatasource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth auth;

  FirebaseRemoteDatasourceImpl(this.firebaseFirestore, this.auth);

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection("users");
    final uid = await getCurrentUid();

    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        status: user.status,
        image: user.image,
        isOnline: user.isOnline,
        uid: uid,
        phoneNumber: user.phoneNumber,
        email: user.email,
        name: user.name,
      ).toDocument();
      if (!userDoc.exists) {
        //create new user
        userCollection.doc(uid).set(newUser);
      } else {
        //update user doc
        userCollection.doc(uid).update(newUser);
      }
    });
  }

  @override
  Future<String> getCurrentUid() async {
    // TODO: implement getCurrentUid
    return await auth.currentUser!.uid;
  }

  @override
  Future<bool> isSignIn() async {
    // TODO: implement isSignIn
    return auth.currentUser != null;
  }

  @override
  Future<void> signOut() async {
    // TODO: implement signOut
    return await auth.signOut();
  }

  @override
  Future<void> addToMyChat(MyChatEntity myChatEntity) async{
    final myChatRef = firebaseFirestore
        .collection('users')
        .doc(myChatEntity.senderUID)
        .collection('myChat');

    final otherChatRef = firebaseFirestore
        .collection('users')
        .doc(myChatEntity.recipientUID)
        .collection('myChat');

    final myNewChat = MyChatModel(
      time: myChatEntity.time,
      senderName: myChatEntity.senderName,
      senderUID: myChatEntity.senderPhoneNumber,
      recipientUID: myChatEntity.recipientUID,
      recipientName: myChatEntity.recipientName,
      channelId: myChatEntity.channelId,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      profileURL: myChatEntity.profileURL,
      recentTextMessage: myChatEntity.recentTextMessage,
      recipientPhoneNumber: myChatEntity.recipientPhoneNumber,
      senderPhoneNumber: myChatEntity.senderPhoneNumber,
      messageTyp: myChatEntity.messageTyp,
    ).toDocument();
    final otherNewChat = MyChatModel(
      time: myChatEntity.time,
      senderName: myChatEntity.recipientName,
      senderUID: myChatEntity.recipientUID,
      recipientUID: myChatEntity.senderUID,
      recipientName: myChatEntity.senderName,
      channelId: myChatEntity.channelId,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      profileURL: myChatEntity.profileURL,
      recentTextMessage: myChatEntity.recentTextMessage,
      recipientPhoneNumber: myChatEntity.senderPhoneNumber,
      senderPhoneNumber: myChatEntity.recipientPhoneNumber,
      messageTyp: myChatEntity.messageTyp,
    ).toDocument();

    myChatRef.doc(myChatEntity.recipientUID).get().then((myChatDoc) {
      if (!myChatDoc.exists) {
        //Create
        myChatRef.doc(myChatEntity.recipientUID).set(myNewChat);
        otherChatRef.doc(myChatEntity.senderUID).set(otherNewChat);
        return;
      } else {
        //Update
        myChatRef.doc(myChatEntity.recipientUID).update(myNewChat);
        otherChatRef.doc(myChatEntity.senderUID).update(otherNewChat);
        return;
      }
    });
  }

  @override
  Future<void> createOneToOneChatChannel(String uid, String otherUid) async{
    final userCollectionRef = firebaseFirestore.collection("users");
    final oneToOneChatChannelRef = firebaseFirestore.collection('myChatChannel');

    userCollectionRef
        .doc(uid)
        .collection('engagedChatChannel')
        .doc(otherUid)
        .get()
        .then((chatChannelDoc) {
      if (chatChannelDoc.exists) {
        return;
      }
      //if not exists
      final _chatChannelId = oneToOneChatChannelRef.doc().id;
      var channelMap = {
        "channelId": _chatChannelId,
        "channelType": "oneToOneChat",
      };
      oneToOneChatChannelRef.doc(_chatChannelId).set(channelMap);

      //currentUser
      userCollectionRef
          .doc(uid)
          .collection("engagedChatChannel")
          .doc(otherUid)
          .set(channelMap);

      //OtherUser
      userCollectionRef
          .doc(otherUid)
          .collection("engagedChatChannel")
          .doc(uid)
          .set(channelMap);

      return;
    });
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
   // final userCollectionRef = firebaseFirestore.collection("users");

    return firebaseFirestore.collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map<UserEntity>((doc) => UserModel.fromFirestore(doc.data()))
    .toList());

  }

  @override
  Stream<List<TextMessageEntity>> getMessages(String channelId) {



    return firebaseFirestore
        .collection("myChatChannel")
        .doc(channelId)
        .collection('messages').orderBy('time')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map<TextMessageEntity>((doc) => TextMessageModel.fromSnapShot(doc.data()))
        .toList());

  }

  @override
  Stream<List<MyChatEntity>> getMyChat(String uid) {



    return  firebaseFirestore.collection('users').doc(uid).collection('myChat')
       .orderBy('time')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map<MyChatEntity>((doc) => MyChatModel.fromSnapShot(doc.data()))
        .toList());




  }


  @override
  Future<String> getOneToOneSingleUserChannelId(String uid, String otherUid) {
    final userCollectionRef = firebaseFirestore.collection('users');
    return userCollectionRef
        .doc(uid)
        .collection('engagedChatChannel')
        .doc(otherUid)
        .get()
        .then((engagedChatChannel) {
      if (engagedChatChannel.exists) {
        return engagedChatChannel.data()!['channelId'];
      }
      return Future.value(null);
    });
  }

  @override
  Future<void> sendTextMessage(TextMessageEntity textMessageEntity, String channelId) async{
    // TODO: implement sendTextMessage
    final messageRef = firebaseFirestore
        .collection('myChatChannel')
        .doc(channelId)
        .collection('messages');

    final messageId = messageRef.doc().id;

    final newMessage = TextMessageModel(
      message: textMessageEntity.message,
      messageId: messageId,
      messageType: textMessageEntity.messsageType,
      recipientName: textMessageEntity.recipientName,
      recipientUID: textMessageEntity.recipientUID,
      sederUID: textMessageEntity.sederUID,
      senderName: textMessageEntity.senderName,
      time: textMessageEntity.time,
    ).toDocument();

    messageRef.doc(messageId).set(newMessage);
  }
}
