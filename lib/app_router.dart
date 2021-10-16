import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stories_chat/bissnus_logic/profile/profile_cubit.dart';

import 'package:stories_chat/screens/examples/notifications.dart';
import 'package:stories_chat/screens/home_screen/home_screen.dart';
import 'package:stories_chat/screens/login/login_screen.dart';
import 'package:stories_chat/screens/otp_screen/otp_screen.dart';
import 'package:stories_chat/screens/profile_screen/profile_screen.dart';
import 'package:stories_chat/screens/splash/splash_screen.dart';
import 'package:stories_chat/screens/welcome_screen/welcome_screen.dart';

import 'bissnus_logic/cubit/phone_auth_cubit.dart';
import 'helper/constans.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;

  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) =>   SplashScreen(),
        );

      case welcome:
        return MaterialPageRoute(
          builder: (_) => WelcomeScreen(),
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) =>
          BlocProvider<ProfileCubit>.value(
                value: ProfileCubit(),
                child: const ProfileScreen(),
              ),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );

      case loginScreen:
        return MaterialPageRoute(
          builder: (_) =>
          BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: LoginScreen(),
          ),
        );

      case otpScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
          builder: (_) =>
          BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: OtpScreen(phoneNumber: phoneNumber),
          ),
        );

    }
  }
}