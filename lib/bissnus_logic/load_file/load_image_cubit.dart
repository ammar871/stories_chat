import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:stories_chat/helper/cemmon.dart';
import 'dart:io';

import 'package:stories_chat/helper/constans.dart';

part 'load_image_state.dart';

class LoadImageCubit extends Cubit<LoadImageState> {
  LoadImageCubit() : super(LoadImageInitial());

  Future uploadImageToFirebase(
      BuildContext context, File? file,String toPhone) async {

    emit(LoadingUploadFile(0.0));

    CollectionReference usersData =
      FirebaseFirestore.instance
        .collection("chats")
        .doc(toPhone + Cemmen.userPhone)
        .collection("messagebetween");

    String fileName = basename(file!.path);

    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("uploads/$fileName")
        .putFile(file);

    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
    //  emit(LoadingUploadFile(snapshot.bytesTransferred.toDouble() / snapshot.totalBytes.toDouble()));
    //   progres=snapshot.bytesTransferred.toDouble() / snapshot.totalBytes.toDouble();
    //   emit(DawnloadUploadFile(progres));

       // progres = (progres * 100);



      if (snapshot.state == TaskState.success) {

        snapshot.ref.getDownloadURL().then((value) => {
          usersData.add({
            "sender": Cemmen.userPhone,
            "message": value,
            "time": DateTime.now(),
            "type":"image"// 42
          }).then((value) {
            emit(SuccessFile());
            print(value);
          }).catchError((error) => print("Failed to add user: $error"))
        });
      }
    }, onError: (e) {
      print(task.snapshot);
      emit(ErrorFile(task.snapshot.toString()));

      if (e.code == 'permission-denied') {
        emit(ErrorFile(
            'User does not have permission to upload to this reference.'));
        print('User does not have permission to upload to this reference.');
      }
    });



  }
}
