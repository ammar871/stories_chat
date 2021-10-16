import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stories_chat/bissnus_logic/cubit/phone_auth_cubit.dart';
import 'package:stories_chat/helper/constans.dart';
import 'package:stories_chat/screens/otp_screen/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _phoneFormKey = GlobalKey();

  Country? countrySelected;
  late String phoneNumber;
  String countryCode = "+20";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _phoneFormKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text(""),
                  Text(
                    "اكد على رقم هاتفك او جوالك",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(Icons.more_vert)
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "سيرسل رسالة نصية قصيرة (قد يتم فرض رسوم على شركة الاتصالات) للتحقق من رقم هاتفك. أدخل رمز بلدك ورقم هاتفك:",
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // ListTile(
              //   onTap: _openFilteredCountryPickerDialog,
              //   title: _buildDialogItem(_countryCode),
              // ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        // optional. Shows phone code before the country name.
                        onSelect: (Country country) {
                          countrySelected = country;
                          countryCode = "+${country.phoneCode}";
                          setState(() {});
                          print(countrySelected!.name);
                        },
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        width: 1.50,
                        color: Colors.green,
                      ))),
                      width: 80,
                      height: 42,
                      alignment: Alignment.center,
                      child: Text(countryCode),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextFormField(
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 18,
                          letterSpacing: 2.0,
                        ),

                        decoration:
                            const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green,width: 2)
                              ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green)
                                ),

                                border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                            )),
                        cursorColor: Colors.green,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          phoneNumber = value!;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MaterialButton(
                    color: Colors.green,
                    onPressed: () {
                      showProgressIndicator(context);
                      _register(context);
                    }, // _submitVerifyPhoneNumber,
                    child: const Text(
                      "التالى ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              _buildPhoneNumberSubmitedBloc()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    if (!_phoneFormKey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _phoneFormKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context)
          .submitPhoneNumber(countryCode+phoneNumber);
    }
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

  Widget _buildPhoneNumberSubmitedBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is Loading) {
          showProgressIndicator(context);
        }

        if (state is PhoneNumberSubmited) {
          Navigator.pop(context);
          Navigator.of(context).pushNamed(otpScreen, arguments: phoneNumber);
        }

        if (state is ErrorOccurred) {
          Navigator.pop(context);
          String errorMsg = (state).errorMsg;
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
