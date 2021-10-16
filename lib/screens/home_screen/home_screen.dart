import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stories_chat/bissnus_logic/communication/communication_cubit.dart';
import 'package:stories_chat/bissnus_logic/user/user_cubit.dart';
import 'package:stories_chat/domian/entityes/user_entity/user_entity.dart';
import 'package:stories_chat/fcm/notification_api.dart';
import 'package:stories_chat/helper/cemmon.dart';
import 'package:stories_chat/helper/constans.dart';
import 'package:stories_chat/screens/home_screen/pages_home/chate_screen/chate_screen.dart';
import 'package:stories_chat/screens/home_screen/pages_home/users_page/users_screen.dart';
import 'package:stories_chat/screens/select_contact_screen/select_contact_page.dart';

late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class HomeScreen extends StatefulWidget {
  static String id = "HomeScreen";

  HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool showFab = true;
  UserEntity? userInfo;

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
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

  late FirebaseMessaging messaging;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? _token;

  void setToken(String? token) {
    print('FCM Token: $token');
    setState(() {
      _token = token;
      Cemmen.userToken = _token!;
      print(Cemmen.userToken);
    });
  }

  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then(setToken);
    super.initState();
    initNoty();
    getUserInfo();
    Cemmen.userPhone = FirebaseAuth.instance.currentUser!.phoneNumber!;
    topices();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        NotificationApi.showNotification(
            title: message.notification!.title,
            body: message.notification!.body,
            payload: 'ammar.abs');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      // NotifyAowsome(notification!.title!,notification.body!);
      if (notification != null && android != null && !kIsWeb) {
        NotifyAowsome(notification.title!, notification.body!);
        /* flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,

            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));*/

        print(message.data["phone"]);
        setState(() {});
      }
    });

    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
    _tabController!.addListener(() {
      if (_tabController!.index == 1) {
        showFab = true;
      } else {
        showFab = false;
      }
      setState(() {});

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print("message recieved");
        print(message.notification!.body);
        NotificationApi.showNotification(
            title: message.notification!.title,
            body: message.notification!.body,
            payload: 'ammar.abs');
        setState(() {});
      });
    });
  }

  notiyForground() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void topices() async {
    print(Cemmen.userToken.replaceAll(RegExp(r'[^\w\s]+'), ''));
    await FirebaseMessaging.instance
        .subscribeToTopic(
            '${Cemmen.userToken.replaceAll(RegExp(r'[^\w\s]+'), '')}')
        .whenComplete(() => print("ok"));
  }

  void NotifyAowsome(String title, String body) async {
    String timezom = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: title,
          body: body,
          bigPicture:
              'https://protocoderspoint.com/wp-content/uploads/2021/05/Monitize-flutter-app-with-google-admob-min-741x486.png',
          notificationLayout: NotificationLayout.BigPicture),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: greenColor,
          title: const Text("Multi Chat"),
          elevation: 0.7,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: const <Widget>[
              // Tab(icon: Icon(Icons.camera_alt)),
              Tab(text: "CHATS"),
              Tab(
                text: "Groups",
              ),
              Tab(
                text: "Users",
              ),
            ],
          ),
          actions: <Widget>[
            const Icon(Icons.search),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (ctc) {
                return [
                  PopupMenuItem(
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            BlocProvider.of<CommunicationCubit>(context)
                                .signOut(userInfo!.uid)
                                .whenComplete(() {
                              setState(() {
                                Navigator.of(context).pushNamed(loginScreen);
                              });
                            });
                          },
                          child: Text("Log Out")))
                ];
              },
              onSelected: (value) {},
            )
          ],
        ),
        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: <Widget>[
                ChatsScreen(),
                Container(),
                const UsersScreen(),
              ],
            ),
            _buildProfileSubmitedBloc(context)
          ],
        ),
        floatingActionButton: showFab
            ? FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) => SelectContactPage(
                  //           userInfo!,
                  //         )));
                },
              )
            : null);
  }

  Widget _buildProfileSubmitedBloc(BuildContext context) {
    return BlocListener<CommunicationCubit, CommunicationState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is CommunicationLoadingLogout) {
          showProgressIndicator(context);
        }

        if (state is CommunicationLoadedLogout) {
          Navigator.of(context).pop();
          print("ok");
        }
      },
      child: Container(),
    );
  }

  initNoty() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await notiyForground();
    }
  }

  void showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
}

/* FirebaseMessaging.instance
        .getToken(
        vapidKey:
        'AAAARWFZ2zQ:APA91bEJ7wT0KO9MdhfYDkkC4RI_kPsy4SKduQr0N_a_LURCeoEOTuRDybZs6cnG-0rgr5_3XS1vSPseDdZW8CeOqJuMhYFEQTlOKgxbLCtvIAUf5Q8wTaqH6s7nC-eX8EBiUwpAHg-L')
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      NotificationApi.showNotification(

        title: event.notification!.title,
        body: event.notification!.body,
        payload: 'ammar.abs'
      );
      setState(() {

      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }*/
