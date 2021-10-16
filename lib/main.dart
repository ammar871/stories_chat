import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:stories_chat/bissnus_logic/profile/profile_cubit.dart';

import 'app_router.dart';
import 'bissnus_logic/communication/communication_cubit.dart';
import 'bissnus_logic/get_divice_number/get_device_numbers_cubit.dart';
import 'bissnus_logic/my_chat/my_chat_cubit.dart';
import 'bissnus_logic/user/user_cubit.dart';
import 'helper/constans.dart';
import 'injection_container.dart' as di;

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
//  FirebaseMessaging.onMessageOpenedApp;
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'chat',
            channelDescription: "Notification example",
            defaultColor: Color(0XFF9050DD),
            ledColor: Colors.white,

            playSound: true,
            enableLights:true,
            enableVibration: false
        )
      ]
  );

  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({
    Key? key,
    required this.appRouter,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));

    return MultiBlocProvider(
      providers: [

        BlocProvider<UserCubit>(
          create: (_) => di.sl<UserCubit>()..getAllUsers(),
        ),
        BlocProvider<GetDeviceNumbersCubit>(
          create: (_) => di.sl<GetDeviceNumbersCubit>(),
        ),
        BlocProvider<CommunicationCubit>(
          create: (_) => di.sl<CommunicationCubit>(),
        ),
        BlocProvider<MyChatCubit>(
          create: (_) => di.sl<MyChatCubit>(),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => di.sl<ProfileCubit>(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: greenColor,
          accentColor: greenColor
        ),
        onGenerateRoute: appRouter.generateRoute,

      ),
    );
  }
}
