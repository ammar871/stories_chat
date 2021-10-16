import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stories_chat/domian/entityes/user_entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String name,
    required String email,
    required String phoneNumber,
    required bool isOnline,
    required String uid,
    required String status,
    required String image,
  }) : super(
    name: name,
    email: email,
    phoneNumber: phoneNumber,
    isOnline: isOnline,
    uid: uid,
    status: status,
    image: image,
  );

  factory UserModel.fromFirestore(Map<String, dynamic> snapshot) {

    return UserModel(
      name: snapshot['name'],
      email: snapshot['email']??'',
      phoneNumber:snapshot['phoneNumber']??'',
      uid: snapshot['uid']??"",
      isOnline: snapshot['isOnline']??'',
      image: snapshot['image']??'',
      status: snapshot['status']??'',
    );
  }



  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "uid": uid,
      "isOnline": isOnline,
      "image": image,
      "status": status,
    };
  }
}