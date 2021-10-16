import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app_const.dart';

class SingleItemChatUserPage extends StatelessWidget {
  final String time;
  final String recentSendMessage;
  final String name;
  final String profileURL;
final String messageTyp;
  const SingleItemChatUserPage(
      {required this.messageTyp, required this.time, required this.recentSendMessage, required this.name,required this.profileURL});

 String getText(){

   if(messageTyp==AppConst.image){
     return "Image sent";
   }else if(messageTyp==AppConst.audio){
     return "Audio sent";
   }else{
     return recentSendMessage;
   }

 }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 55,
                    width: 55,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      child: Image.network(profileURL),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$name",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 200,
                        child: Text(
                          getText(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Text("$time")
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 60, right: 10),
            child: Divider(
              thickness: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}