import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:stories_chat/app_const.dart';
import 'package:stories_chat/bissnus_logic/communication/communication_cubit.dart';
import 'package:stories_chat/bissnus_logic/profile/profile_cubit.dart';
import 'package:path/path.dart' as path;
import 'package:stories_chat/domian/entityes/text_message_entity/text_message_entity.dart';
import 'package:stories_chat/domian/entityes/user_entity/user_entity.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:stories_chat/helper/constans.dart';

import 'package:bubble/bubble.dart';
import 'package:stories_chat/screens/sub_pages/timer_page/text_timer.dart';
import 'package:stories_chat/uitls/sound_recorder.dart';

import 'comonts/item_audio.dart';

class ChatPage extends StatefulWidget {
  final String recipientName,
      recipientPhoneNumber,
      recipientUID,
      senderName,
      senderUID,
      senderPhoneNumber,
      recipientimage;

  ChatPage(
      {required this.recipientName,
      required this.recipientPhoneNumber,
      required this.recipientUID,
      required this.senderName,
      required this.senderUID,
      required this.senderPhoneNumber,
      required this.recipientimage});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //recorder
  FlutterSoundRecorder? _myRecorder;

  // final _soundRecording = SoundRecorder();
  // final timerController = TimeController();

//  final audioPlayer = AssetsAudioPlayer();
  String? filePath;

  String _recorderTxt = '00:00:00';

  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController(initialScrollOffset: 50.0);

  bool isPlayingMsg = false, isRecording = false, isSending = false;

  String keyChat = "";
  UserEntity? userInfo;

  Uint8List? fileBytes;
  String? fileName;

  // storage
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _file1;

  //late File _imageTwo;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // _soundRecording.inIt();

    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
    BlocProvider.of<CommunicationCubit>(context).getMessages(
      senderId: widget.senderUID,
      recipientId: widget.recipientUID,
    );

    getUserInfo();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _soundRecording.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: greenColor,
        title: const Text(""),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          margin: const EdgeInsets.only(top: 30),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22,
                  )),
              SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(widget.recipientimage)),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.recipientName,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<CommunicationCubit, CommunicationState>(
        builder: (_, communicationState) {
          if (communicationState is CommunicationLoaded) {
            return _bodyWidget(communicationState);
          }

          return const Center(
            child: CircularProgressIndicator(
              color: greenColor,
            ),
          );
        },
      ),
    );
  }

  Widget _bodyWidget(CommunicationLoaded communicationState) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Image.asset(
            "assets/images/background_wallpaper.png",
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            _messagesListWidget(communicationState),
            _sendMessageTextField(),
          ],
        )
      ],
    );
  }

  Widget _messagesListWidget(CommunicationLoaded messages) {
    Timer(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInQuad,
      );
    });
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: messages.messages.length,
        itemBuilder: (_, index) {
          final message = messages.messages[index];

          if (message.messsageType == AppConst.audio) {
            return ItemAudio(
                message: message,
                userUid: userInfo!.uid,
                senderUid: widget.senderUID);
          } else if (message.messsageType == AppConst.image) {
            if (message.sederUID == widget.senderUID) {
              return _ImageLayout(
                color: Colors.lightGreen[400],
                time: DateFormat('hh:mm a').format(message.time.toDate()),
                align: TextAlign.left,
                boxAlign: CrossAxisAlignment.start,
                crossAlign: CrossAxisAlignment.end,
                nip: BubbleNip.rightTop,
                text: message.message,
              );
            } else {
              return _ImageLayout(
                color: Colors.white,
                time: DateFormat('hh:mm a').format(message.time.toDate()),
                align: TextAlign.left,
                boxAlign: CrossAxisAlignment.start,
                crossAlign: CrossAxisAlignment.start,
                nip: BubbleNip.leftTop,
                text: message.message,
              );
            }
          } else {
            if (message.sederUID == widget.senderUID) {
              return _messageLayout(
                color: Colors.lightGreen[400],
                time: DateFormat('hh:mm a').format(message.time.toDate()),
                align: TextAlign.left,
                boxAlign: CrossAxisAlignment.start,
                crossAlign: CrossAxisAlignment.end,
                nip: BubbleNip.rightTop,
                text: message.message,
              );
            } else {
              return _messageLayout(
                color: Colors.white,
                time: DateFormat('hh:mm a').format(message.time.toDate()),
                align: TextAlign.left,
                boxAlign: CrossAxisAlignment.start,
                crossAlign: CrossAxisAlignment.start,
                nip: BubbleNip.leftTop,
                text: message.message,
              );
            }
          }
        },
      ),
    );
  }

  Widget _sendMessageTextField() {
    // bool isRecording = _soundRecording.isRecording;
    // timerController.value =_soundRecording.isRecording;
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 4, right: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.2),
                        offset: const Offset(0.0, 0.50),
                        spreadRadius: 1,
                        blurRadius: 1),
                  ]),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.insert_emoticon,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 60,
                      ),
                      child: Scrollbar(
                        child: isRecording
                            ? Container(
                                height: 45,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Center(
                                  child: Text("0:0"),
                                ),
                              )
                            : TextField(
                                maxLines: null,
                                style: const TextStyle(fontSize: 14),
                                controller: _controller,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message",
                                ),
                              ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (builder) => bottomSheet());
                          },
                          child: const Icon(Icons.link)),
                      const SizedBox(
                        width: 10,
                      ),
                      _controller.text.isEmpty
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  _choseImage(ImageSource.camera)
                                      .whenComplete(() {
                                    if (_file1 != null) {
                                      BlocProvider.of<ProfileCubit>(context)
                                          .uploadImageChatToFirebase(
                                              context, _file1, (value) {
                                        print(value);
                                        _sendFileMessage(AppConst.image, value);
                                      });
                                    }
                                  });
                                });
                              },
                              child: const Icon(Icons.camera_alt))
                          : const Text(""),
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            height: 45,
            width: 45,
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: _controller.text.isEmpty
                ? InkWell(
                    onTap: () async {
                      if (isRecording) {
                        stopRecord();
                        setState(() {
                          isRecording = false;
                        });
                      } else {
                        startRecord();
                        setState(() {
                          isRecording = true;
                        });
                      }

                      // final isRecordings =
                      //     await _soundRecording.toggleRecording();
                      // setState(() {});
                      // final isPlaying = _soundRecording.isRecording;
                      // if (isPlaying) {
                      //   timerController.startTimer();
                      // } else {
                      //   timerController.stopTimer();
                      // }
                      setState(() {});
                    },
                    child: Icon(
                      isRecording ? Icons.pause : Icons.mic,
                      color: Colors.white,
                    ))
                : InkWell(
                    onTap: () {
                      if (_controller.text.isNotEmpty) {
                        _sendTextMessage(AppConst.text);
                      }
                    },
                    child: const Icon(Icons.send, color: Colors.white)),
          ),
          _buildProfileSubmitedBloc(context)
        ],
      ),
    );
  }

  Widget _messageLayout({
    text,
    time,
    color,
    align,
    boxAlign,
    nip,
    crossAlign,
  }) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(3),
            child: Bubble(
              color: color,
              nip: nip,
              child: Column(
                crossAxisAlignment: crossAlign,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    textAlign: align,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    time,
                    textAlign: align,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(
                        .4,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _ImageLayout({
    text,
    time,
    color,
    align,
    boxAlign,
    nip,
    crossAlign,
  }) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.90,
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(3),
            child: Bubble(
              color: color,
              nip: nip,
              child: Column(
                crossAxisAlignment: crossAlign,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 200,
                    child: Image.network(
                      text,
                      height: 195,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    time,
                    textAlign: align,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(
                        .4,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void _sendTextMessage(String typMessage) {
    if (_controller.text.isNotEmpty) {
      BlocProvider.of<CommunicationCubit>(context).sendTextMessage(
          recipientId: widget.recipientUID,
          senderId: widget.senderUID,
          recipientPhoneNumber: widget.recipientPhoneNumber,
          recipientName: widget.recipientName,
          senderPhoneNumber: widget.senderPhoneNumber,
          senderName: widget.senderName,
          message: _controller.text,
          imageUrl: widget.recipientimage,
          typMessage: typMessage);
      _controller.clear();
    }
  }

  void _sendFileMessage(String typMessage, String message) {
    BlocProvider.of<CommunicationCubit>(context).sendTextMessage(
        recipientId: widget.recipientUID,
        senderId: widget.senderUID,
        recipientPhoneNumber: widget.recipientPhoneNumber,
        recipientName: widget.recipientName,
        senderPhoneNumber: widget.senderPhoneNumber,
        senderName: widget.senderName,
        message: message,
        imageUrl: widget.recipientimage,
        typMessage: typMessage);
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
          Navigator.of(context).pop();
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

  void showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog =  AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)
          ),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
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

  Widget bottomSheet() {
    return SizedBox(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _pickFiles().whenComplete(() {
                          if (fileBytes != null) {
                            BlocProvider.of<ProfileCubit>(context)
                                .uploadFileChatToFirebase(
                                    context, fileBytes!, fileName!, (value) {
                              print(value);
                              _sendFileMessage(AppConst.file, value);
                            });
                          }
                        });
                      });
                    },
                    child: iconCreation(
                        Icons.insert_drive_file, Colors.indigo, "Document"),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  InkWell(
                      onTap: () {
                        _choseImage(ImageSource.camera).whenComplete(() {
                          if (_file1 != null) {
                            BlocProvider.of<ProfileCubit>(context)
                                .uploadImageChatToFirebase(context, _file1,
                                    (value) {
                              print(value);
                              _sendFileMessage(AppConst.image, value);
                            });
                          }
                          setState(() {});
                        });
                      },
                      child: iconCreation(
                          Icons.camera_alt, Colors.pink, "Camera")),
                  const SizedBox(
                    width: 40,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      _choseImage(ImageSource.gallery).whenComplete(() {
                        if (_file1 != null) {
                          BlocProvider.of<ProfileCubit>(context)
                              .uploadImageChatToFirebase(context, _file1,
                                  (value) {
                            print(value);
                            _sendFileMessage(AppConst.image, value);
                          });
                        }
                        setState(() {});
                      });
                    },
                    child: iconCreation(
                        Icons.insert_photo, Colors.purple, "Gallery"),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(
            icons,
            // semanticLabel: "Help",
            size: 29,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            // fontWeight: FontWeight.w100,
          ),
        )
      ],
    );
  }

  void _logException(String message) {
    print(message);
    // _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _pickFiles() async {
    fileBytes = null;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc'],
          withData: true);
      print(result);

      if (result != null) {
        fileBytes = result.files.first.bytes;
        fileName = result.files.first.name;

        print(fileBytes);
      } else {
        // User canceled the picker
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
  }

  _choseImage(ImageSource source) async {
    try {
      _file1 = null;
      final pickedFile = await _picker.getImage(source: source);
      // file = pickedFile!;
      setState(() {
        _file1 = File(pickedFile!.path);
      });
    } catch (e) {
      print(e);
    }
  }

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

      print(userInfo!.name);
    });
  }

  String? recordFilePath;

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();

      RecordMp3.instance.start(recordFilePath!, (type) {
        setState(() {});
      });
    } else {}
    setState(() {});
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  int i = 0;

  void stopRecord() async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      setState(() {
        isSending = true;
      });
      if (recordFilePath != null) {
        BlocProvider.of<ProfileCubit>(context)
            .uploadAudioChatToFirebase(context, recordFilePath!, (value) {
          print(value);
          _sendFileMessage(AppConst.audio, value);
          recordFilePath = null;
        });
      }

      print(recordFilePath);
      setState(() {
        isPlayingMsg = false;
      });
    }
  }



  Future<void> play() async {
    if (recordFilePath != null && File(recordFilePath!).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(
        recordFilePath!,
        isLocal: true,
      );
    }
  }
}

class ItemImage extends StatelessWidget {
  final TextMessageEntity massege;
  final String userUid;
  final String senderUid;

  const ItemImage(
      {required this.massege, required this.userUid, required this.senderUid});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            top: 8,
            bottom: 3,
            left: ((massege.sederUID == userUid) ? 64 : 10),
            right: ((massege.sederUID == senderUid) ? 10 : 64)));
  }
}

