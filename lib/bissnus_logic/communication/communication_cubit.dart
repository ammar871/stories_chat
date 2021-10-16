
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stories_chat/domian/entityes/text_message_entity/my_chat_entity.dart';
import 'package:stories_chat/domian/entityes/text_message_entity/text_message_entity.dart';
import 'package:stories_chat/domian/usescases/add_to_my_chat_usecase..dart';
import 'package:stories_chat/domian/usescases/get_one_to_one_single_user_chat_channel_usecase.dart';
import 'package:stories_chat/domian/usescases/get_text_messages_usecase.dart';
import 'package:stories_chat/domian/usescases/send_text_message_usecase.dart';

import '../../app_const.dart';


part 'communication_state.dart';

class CommunicationCubit extends Cubit<CommunicationState> {
  final SendTextMessageUseCase sendTextMessageUseCase;
  final GetOneToOneSingleUserChatChannelUseCase
      getOneToOneSingleUserChatChannelUseCase;
  final GetTextMessagesUseCase getTextMessagesUseCase;
  final AddToMyChatUseCase addToMyChatUseCase;

  CommunicationCubit({
    required this.getTextMessagesUseCase,
    required this.addToMyChatUseCase,
    required this.getOneToOneSingleUserChatChannelUseCase,
    required this.sendTextMessageUseCase,
  }) : super(CommunicationInitial());



  Future<void> sendTextMessage({
    required String senderName,
    required String senderId,
    required String recipientId,
    required String recipientName,
    required String message,
    required String recipientPhoneNumber,
    required String senderPhoneNumber,
    required String imageUrl,
    required String typMessage
  }) async {
    try {
      final channelId = await getOneToOneSingleUserChatChannelUseCase.call(
          senderId, recipientId);
      await sendTextMessageUseCase.sendTextMessage(
        TextMessageEntity(
          recipientName: recipientName,
          recipientUID: recipientId,
          senderName: senderName,
          time: Timestamp.now(),
          sederUID: senderId,
          message: message,
          messageId: "",
          messsageType: typMessage,

        ),
        channelId,
      );
      await addToMyChatUseCase.call(MyChatEntity(
        time: Timestamp.now(),
        senderName: senderName,
        senderUID: senderId,
        senderPhoneNumber: senderPhoneNumber,
        recipientName: recipientName,
        recipientUID: recipientId,
        recipientPhoneNumber: recipientPhoneNumber,
        recentTextMessage: message,
        profileURL: imageUrl,
        isRead: true,
        isArchived: false,
        channelId: channelId,
        messageTyp: typMessage,
      ));
    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }

  Future<void> getMessages({required String senderId,required String recipientId})async{
    emit(CommunicationLoading());
    try{

      final channelId=await getOneToOneSingleUserChatChannelUseCase.call(senderId, recipientId);

      final messagesStreamData=getTextMessagesUseCase.call(channelId);
      messagesStreamData.listen((messages) {
        emit(CommunicationLoaded(messages: messages));
      });

    }on SocketException catch(_){
      emit(CommunicationFailure());
    }catch(_){
      emit(CommunicationFailure());
    }
  }

  Future<void> signOut(String userId) async {
    emit(CommunicationLoadingLogout());
   final auth= FirebaseAuth.instance;
     await auth.signOut().then((value){
       FirebaseFirestore.instance.collection("users").doc(userId).delete().then((value){


       });
       emit(CommunicationLoadedLogout());

     });
  }
}
