import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stories_chat/bissnus_logic/load_file/load_image_cubit.dart';
import 'package:stories_chat/bissnus_logic/user/user_cubit.dart';
import 'package:stories_chat/bissnus_logic/users/users_cubit.dart';
import 'package:stories_chat/data/models/user_data.dart';
import 'package:stories_chat/domian/entityes/user_entity/user_entity.dart';
import 'package:stories_chat/helper/cemmon.dart';
import 'package:stories_chat/helper/constans.dart';
import 'package:stories_chat/screens/chat_page/chat_page.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<UserData> users = [];
  UserEntity? userInfo;
  String? phonNumer;

  void getUserInfo() async {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;
    Cemmen.userPhone= auth.currentUser!.phoneNumber!;
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      userInfo = UserEntity(
          name: value["name"],
          email: value["email"],
          phoneNumber: value["phoneNumber"],
          isOnline: value["isOnline"],
          uid: value["uid"],
          status: value["status"],
          image: value["image"]);

      print(userInfo!.name);
    });
  }
  @override
  void initState() {

    super.initState();

    getUserInfo();
  }



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users')
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Colors.grey,),
            itemBuilder: (_, i) {
              final data = docs[i].data();
              // print(data["phoneNumber"] + userInfo!.phoneNumber);
              if (data["phoneNumber"] == Cemmen.userPhone) {
                return Container(height: 0,);
              }
              return  InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => ChatPage(
                        recipientName: data["name"],
                        recipientimage: data["image"],
                        recipientPhoneNumber: data["phoneNumber"],
                        recipientUID: data["uid"],
                        senderName: userInfo!.name,
                        senderUID: userInfo!.uid,
                        senderPhoneNumber: userInfo!.phoneNumber,
                      )
                  ));
                  BlocProvider.of<UserCubit>(context).createChatChannel(
                      uid:userInfo!.uid, otherUid: data["uid"]);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10),
                  child: ListTile(

                    title: Text(data['name']),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(data['image'], height: 50,
                        width: 50,
                        fit: BoxFit.cover,),
                    ),

                  ),
                ),
              );
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );

    showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }


}
