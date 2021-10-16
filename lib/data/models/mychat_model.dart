import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stories_chat/domian/entityes/text_message_entity/my_chat_entity.dart';

class MyChatModel extends MyChatEntity {
  MyChatModel(
      {required String senderName,
      required String senderUID,
      required String recipientName,
      required String recipientUID,
      required String channelId,
      required String profileURL,
      required String recipientPhoneNumber,
      required String senderPhoneNumber,
      required String recentTextMessage,
      required bool isRead,
      required bool isArchived,
      required Timestamp time,
      required String messageTyp})
      : super(
          senderName: senderName,
          senderUID: senderUID,
          recipientName: recipientName,
          recipientUID: recipientUID,
          channelId: channelId,
          profileURL: profileURL,
          recipientPhoneNumber: recipientPhoneNumber,
          senderPhoneNumber: senderPhoneNumber,
          recentTextMessage: recentTextMessage,
          isRead: isRead,
          isArchived: isArchived,
          time: time,
          messageTyp: messageTyp,
        );

  factory MyChatModel.fromSnapShot(Map<String, dynamic> snapshot) {
    return MyChatModel(
        senderName: snapshot['senderName'],
        senderUID: snapshot['senderUID'],
        senderPhoneNumber: snapshot['senderPhoneNumber'],
        recipientName: snapshot['recipientName'],
        recipientUID: snapshot['recipientUID'],
        recipientPhoneNumber: snapshot['recipientPhoneNumber'],
        channelId: snapshot['channelId'],
        time: snapshot['time'],
        isArchived: snapshot['isArchived'],
        isRead: snapshot['isRead'],
        recentTextMessage: snapshot['recentTextMessage'],
        profileURL: snapshot['profileURL'],
        messageTyp: snapshot['messageTyp']);
  }

  Map<String, dynamic> toDocument() {
    return {
      "senderName": senderName,
      "senderUID": senderUID,
      "recipientName": recipientName,
      "recipientUID": recipientUID,
      "channelId": channelId,
      "profileURL": profileURL,
      "recipientPhoneNumber": recipientPhoneNumber,
      "senderPhoneNumber": senderPhoneNumber,
      "recentTextMessage": recentTextMessage,
      "isRead": isRead,
      "isArchived": isArchived,
      "time": time,
      "messageTyp": messageTyp,
    };
  }
}
