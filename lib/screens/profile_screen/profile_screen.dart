import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:stories_chat/bissnus_logic/profile/profile_cubit.dart';
import 'package:stories_chat/data/models/user_model.dart';
import 'package:stories_chat/helper/cemmon.dart';
import 'package:stories_chat/helper/constans.dart';
import 'package:stories_chat/helper/shard_editor.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final auth = FirebaseAuth.instance;
  String? userUid;

  Future<void> getUserUid() async {
    userUid = auth.currentUser!.uid;
    print("user Uid : $userUid");
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _file1;
  bool isLoading = false;
  String? phone;

  @override
  void initState() {
    super.initState();
    getPhoneNumber();
    getUserUid();
  }

  getPhoneNumber() async {
    phone = FirebaseAuth.instance.currentUser!.phoneNumber;
    ShardEditor().setPhone(phone!);
  }

  //late File _imageTwo;
  final ImagePicker _picker = ImagePicker();

  _choseImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      // file = pickedFile!;
      setState(() {
        _file1 = File(pickedFile!.path);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Profile Info",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Please provide your name and an optional Profile photo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              _rowWidget(context),
              const SizedBox(
                height: 20,
              ),
              _file1 != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        File(_file1!.path),
                        fit: BoxFit.cover,
                        height: 70,
                        width: 70,
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MaterialButton(
                    color: Colors.green,
                    onPressed: () {
                      if (_nameController.text.isEmpty || _file1 == null) {
                        print("no");
                      } else {
                        final user = UserModel(
                            name: _nameController.text,
                            email: "hsghjsan",
                            phoneNumber: phone!,
                            isOnline: true,
                            uid: Cemmen.userToken,
                            status: "status",
                            image: "image");
                        //showProgressIndicator(context);
                        BlocProvider.of<ProfileCubit>(context)
                            .uploadImageToFirebase(
                                context, _file1, user, userUid!);
                      }
                    }, //_submitProfileInfo,
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              _buildProfileSubmitedBloc(context)
            ],
          ),
        ),
      ),
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

  showBottomSheetImage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    _choseImage(ImageSource.gallery);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.photo,
                        size: 50,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("From Gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ))
                    ],
                  ),
                )),
                const VerticalDivider(
                  width: 1,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    _choseImage(ImageSource.camera);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.camera_alt,
                        size: 50,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("From Camera",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ))
                    ],
                  ),
                ))
              ],
            ),
          );
        });
  }

  Widget _rowWidget(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showBottomSheetImage(context);
            setState(() {});
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
                color: Color(0xffE0E0E0),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: const Icon(Icons.camera_alt),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: "Enter your name",
            ),
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Container(
          width: 35,
          height: 35,
          decoration: const BoxDecoration(
              color: Color(0xffE0E0E0),
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: const Icon(Icons.insert_emoticon),
        )
      ],
    );
  }

  Widget _buildProfileSubmitedBloc(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is LoadingUpload) {
          showProgressIndicator(context);
        }

        if (state is Success) {
          Navigator.pop(context);
          Navigator.of(context).pushReplacementNamed(home);
          print("ok");
        }

        if (state is Error) {
          Navigator.pop(context);
          String errorMsg = (state).msgError;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.black,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Container(),
    );
  }
}
