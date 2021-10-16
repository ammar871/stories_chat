import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stories_chat/bissnus_logic/my_chat/my_chat_cubit.dart';
import 'package:stories_chat/domian/entityes/user_entity/user_entity.dart';
import 'package:stories_chat/helper/constans.dart';
import 'package:stories_chat/screens/chat_page/chat_page.dart';
import 'package:stories_chat/screens/chat_page/singel_item_chat.dart';

class ChatsScreen extends StatefulWidget {
  @override
  ChatsScreenState createState() {
    return ChatsScreenState();
  }
}

class ChatsScreenState extends State<ChatsScreen> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  UserEntity? userInfo;

  void getUserInfo() async {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      userInfo = UserEntity(
          name: value["name"],
          email: value["email"],
          phoneNumber: value["phoneNumber"],
          isOnline: value["isOnline"],
          uid: value["uid"],
          status: value["status"],
          image: value["image"]);
      BlocProvider.of<MyChatCubit>(context).getMyChat(uid: userInfo!.uid);
      print(userInfo!.name);
    });
  }

  @override
  void initState() {
  getUserInfo();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MyChatCubit, MyChatState>(
        builder: (_, myChatState) {
          if (myChatState is MyChatLoaded) {
            return _myChatList(myChatState);
          }
          return _loadingWidget();
        },
      ),

    );
  }

  Widget _emptyListDisplayMessageWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: greenColor.withOpacity(.5),
            borderRadius: BorderRadius.all(const Radius.circular(100)),
          ),
          child: Icon(
            Icons.message,
            color: Colors.white.withOpacity(.6),
            size: 40,
          ),
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "Start chat with your friends and family,\n on Multi Chat ",
              textAlign: TextAlign.center,
              style:
              TextStyle(fontSize: 14, color: Colors.black.withOpacity(.4)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _myChatList(MyChatLoaded myChatData) {
    return myChatData.myChat.isEmpty
        ? _emptyListDisplayMessageWidget()
        : ListView.builder(
      itemCount: myChatData.myChat.length,
      itemBuilder: (_, index) {
        final myChat=myChatData.myChat[index];

        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => ChatPage(
                senderPhoneNumber: myChat.senderPhoneNumber,
                senderUID: userInfo!.uid,
                senderName: myChat.senderName,
                recipientUID: myChat.recipientUID,
                recipientPhoneNumber: myChat.recipientPhoneNumber,
                recipientName: myChat.recipientName, recipientimage: myChat.profileURL,
              ),
            ));
          },
          child: SingleItemChatUserPage(
            name: myChat.recipientName,
            messageTyp: myChat.messageTyp,
            recentSendMessage: myChat.recentTextMessage,
            profileURL: myChat.profileURL,
            time: DateFormat('hh:mm a').format(myChat.time.toDate()),
          ),
        );
      },
    );
  }

  Widget _loadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

