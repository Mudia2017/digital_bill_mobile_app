import 'dart:convert';
import 'dart:io';

import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:popover/popover.dart';
import 'package:path/path.dart' as path;

class Login extends StatefulWidget {
  final bool isLastStack;
  Login({Key? key, required this.isLastStack}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();

  bool hidePassword = true;
  final _formKey = GlobalKey<FormState>();

  // LOG IN REQUEST
  login(String email, password) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    serviceProvider.hudLoadingEffect(context, true);

    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    var response = await http
        .post(Uri.parse('http://192.168.43.50:8000/api/v1/main/api_login/'),
            // Uri.parse('http://192.168.100.88:8000/api/v1/main/api_login/'),
            // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_login/'),
            body: json.encode(data),
            headers: {"Content-Type": "application/json"},
            encoding: Encoding.getByName("utf-8"))
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      _response = response;
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      serviceProvider.hudLoadingEffect(context, false);

      var serverResponse = json.decode(response.body);
      if (serverResponse['isSuccess'] == false) {
        if (serverResponse['errorMsg'] != '') {
          password1Controller.clear();
          serviceProvider.popWarningErrorMsg(
              context, 'Error', serverResponse['errorMsg'].toString());
        }
      } else {
        if (serverResponse['otpConfirm'] == false) {
          // RE-DIRECT TO OTP PAGE TO CONFIRM OTP
          emailController.clear();
          password1Controller.clear();
          Navigator.of(context)
              .pushReplacementNamed(RouteManager.otpVerify, arguments: {
            'token': serverResponse['token'],
            'name': serverResponse['name'],
            'email': serverResponse['email'],
            'mobile': serverResponse['mobile'],
            'call': 'requestFromLogin',
          });
        } else if (serverResponse['security_pin'] == false) {
          // RE-DIRECT TO SECURITY PIN PAGE TO CREATE A PIN
          emailController.clear();
          password1Controller.clear();
          Navigator.of(context)
              .pushReplacementNamed(RouteManager.securityPin, arguments: {
            'token': serverResponse['token'],
            'name': serverResponse['name'],
            'email': serverResponse['email'],
            'mobile': serverResponse['mobile'],
          });
        } else {
          await saveNetworkImgToLocalStorage(
              serverResponse['serverProfileImg']);
          emailController.clear();
          password1Controller.clear();
          Navigator.of(context).pushNamedAndRemoveUntil(
              RouteManager.homePage, (Route<dynamic> route) => false,
              arguments: {
                'token': serverResponse['token'],
                'name': serverResponse['name'],
                'email': serverResponse['email'],
                'mobile': serverResponse['mobile'],
                'acctBal': serverResponse['acctBal']
              });
        }
      }
    }
  }

  var _response;
  saveNetworkImgToLocalStorage(String imgUrl) async {
    // final response = await http.get(Uri.parse('https://example.com/xyz.jpg)'));

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(path.join(documentDirectory.path, 'imagetest.png'));

    file.writeAsBytesSync(_response.bodyBytes);
    print(file);
    // return file;

    // Directory? externalStorageDirectory = await getExternalStorageDirectory();
    // File file =
    //     File(path.join(externalStorageDirectory!.path, path.basename(imgUrl)));
    // // await file.writeAsBytes(_response.bodyBytes);
    // bool isSaveToPref = await serviceProvider.saveImageToPreferences(
    //     serviceProvider.base64String(file.readAsBytesSync()));
    // print(isSaveToPref);
    // // bool isImgPrefSave = await serviceProvider.saveImageToPreferences(imgUrl);
    // print('Success');
  }

  var serviceProvider = ServiceProvider();
  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: ServiceProvider.backGroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: WillPopScope(
          onWillPop: () async {
            if (widget.isLastStack) {
              bool isResponse =
                  await serviceProvider.popWarningConfirmActionYesNo(
                      context,
                      'Warning',
                      'Do you want to exit the app?',
                      Colors.white60);
              if (isResponse == true) {
                SystemNavigator.pop();
              }
            } else {
              Navigator.pop(context);
            }
            return Future.value(false);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: screenH * 0.023,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 35, 30, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (widget.isLastStack) {
                              bool isResponse = await serviceProvider
                                  .popWarningConfirmActionYesNo(
                                      context,
                                      'Warning',
                                      'Do you want to exit the app?',
                                      Colors.white60);
                              if (isResponse == true) {
                                SystemNavigator.pop();
                              }
                              return Future.value(false);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            height: screenH * 0.053,
                            width: screenW * 0.12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color:
                                  themeManager.currentTheme == ThemeMode.light
                                      ? ServiceProvider.greyBGbackArrow
                                      : ServiceProvider.blueTrackColor,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          'Sign in',
                          style: ServiceProvider.pageNameFont,
                        ),
                        Container(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenH * 0.009,
                  ),
                  inputField(),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'Forgotten your password?',
                          style: GoogleFonts.almendra().copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          child: Text(
                            'Reset password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ServiceProvider.skyBlue,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(RouteManager.resetPassword);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: MaterialButton(
                        disabledColor: Colors.grey.shade300,
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        color: ServiceProvider.innerBlueBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        onPressed: emailController.text.isEmpty ||
                                !emailController.text.contains('@')
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  await login(emailController.text,
                                      password1Controller.text);
                                }
                              }),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member yet?',
                        style: GoogleFonts.almendra().copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        child: Text(
                          'Create an account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ServiceProvider.skyBlue,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RouteManager.register);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              style: Theme.of(context).textTheme.subtitle2,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                return null;
              },
              onChanged: (element) {
                if (element.isNotEmpty && element.contains('@')) {
                  setState(() {
                    emailController.text;
                  });
                } else if (!element.contains('@')) {
                  setState(() {
                    emailController.text;
                  });
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: password1Controller,
              style: Theme.of(context).textTheme.subtitle2,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  child: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                    color: themeManager.currentTheme == ThemeMode.light
                        ? Colors.black
                        : ServiceProvider.whiteColorShade70,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
              obscureText: hidePassword,
            ),
          ],
        ),
      ),
    );
  }
}
