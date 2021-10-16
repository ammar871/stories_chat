import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:stories_chat/data/models/user_model.dart';
import 'dart:io';

import 'package:stories_chat/helper/constans.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future uploadImageToFirebase(
      BuildContext context, File? file, UserModel user,String uid) async {
    emit(LoadingUpload());
    CollectionReference usersData =
        FirebaseFirestore.instance.collection(usersTable);

    String fileName = basename(file!.path);

    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("uploads/$fileName")
        .putFile(file);

    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      if (snapshot.state == TaskState.success) {
        //

        snapshot.ref.getDownloadURL().then((value) => {
        usersData.doc(uid).get().then((userdoc) {
          final newUser = UserModel(
            status: user.status,
            isOnline: user.isOnline,
            uid: uid,
            phoneNumber: user.phoneNumber,
            email: user.email,
            name: user.name,
            image: value,
          ).toDocument();
          if (!userdoc.exists) {
            //create new user
            usersData.doc(uid).set(newUser);
            emit(Success());
          } else {
            //update user doc
            usersData.doc(uid).update(newUser);
            emit(Success());
          }

        })


          // usersData.add({
          //       'full_name': name, // John Doe
          //       'image': value, // Stokes and Sons
          //       'phone': phone ,
          //       "token":token,
          //       "isOnline":isOnline,
          //       "uid":uid// 42
          //     }).then((value) {
          //       emit(Success());
          //       print(value);
          //     }).catchError((error) => print("Failed to add user: $error"))
            });
      }
    }, onError: (e) {
      print(task.snapshot);
      emit(Error(task.snapshot.toString()));

      if (e.code == 'permission-denied') {
        emit(Error(
            'User does not have permission to upload to this reference.'));
        print('User does not have permission to upload to this reference.');
      }
    });
  }

  Future uploadImageChatToFirebase(
      BuildContext context, File? file,Function(String) image) async {
    emit(LoadingUpload());


    String fileName = basename(file!.path);

    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("uploads/$fileName")
        .putFile(file);

    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      if (snapshot.state == TaskState.success) {
        //

        snapshot.ref.getDownloadURL().then((value) {
          image(value);
          emit(Success());
        });


      }
    }, onError: (e) {
      print(task.snapshot);
      emit(Error(task.snapshot.toString()));

      if (e.code == 'permission-denied') {
        emit(Error(
            'User does not have permission to upload to this reference.'));
        print('User does not have permission to upload to this reference.');
      }
    });
  }





  Future uploadFileChatToFirebase(
      BuildContext context,  Uint8List fileBytese,String fileName,Function(String) image) async {
    emit(LoadingUpload());




    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("uploads/$fileName")
        .putData(fileBytese);

    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      if (snapshot.state == TaskState.success) {
        //

        snapshot.ref.getDownloadURL().then((value) {
          image(value);
          emit(Success());
        });


      }
    }, onError: (e) {
      print(task.snapshot);
      emit(Error(task.snapshot.toString()));

      if (e.code == 'permission-denied') {
        emit(Error(
            'User does not have permission to upload to this reference.'));
        print('User does not have permission to upload to this reference.');
      }
    });
  }

  Future uploadAudioChatToFirebase(
      BuildContext context, String filepath,Function(String) image) async {
    emit(LoadingUpload());




    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("profilepics/audio${DateTime.now().millisecondsSinceEpoch.toString()}}.jpg'")
        .putFile(File(filepath));
    assert(File(filepath).existsSync());
    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      if (snapshot.state == TaskState.success) {
        //

        snapshot.ref.getDownloadURL().then((value) {
          image(value);
          emit(Success());
        });


      }
    }, onError: (e) {
      print(task.snapshot);
      emit(Error(task.snapshot.toString()));

      if (e.code == 'permission-denied') {
        emit(Error(
            'User does not have permission to upload to this reference.'));
        print('User does not have permission to upload to this reference.');
      }
    });
  }


}
