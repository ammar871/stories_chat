import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
class UserEntity extends Equatable{
late final String name;
late final String email;
late final String phoneNumber;
late final bool isOnline;
late final String uid;
late final String status;
late final String image;

 UserEntity(
      {required this.name,
      required this.email,
      required this.phoneNumber,
      required this.isOnline,
      required this.uid,
      required this.status,
      required this.image});

  @override
  // TODO: implement props
  List<Object?> get props => [name,email,phoneNumber,isOnline,uid,status,image];



}

