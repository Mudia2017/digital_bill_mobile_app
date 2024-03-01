import 'dart:convert';

import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();

  bool hidePassword = true;
  bool _hidePassword = true;
  final _formKey = GlobalKey<FormState>();

  var maskFormatter = MaskTextInputFormatter(
      mask: '#### ### ####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  registration(
      String name, email, mobile, password1, password2, urReferredCode) async {
    // GENERATE A UNIQUE REFERRAL CODE USING NAME & MILLISECOND TIME
    String uniqueReferralCode =
        DateTime.now().millisecondsSinceEpoch.toString();
    uniqueReferralCode = uniqueReferralCode.substring(9);
    uniqueReferralCode =
        "DBill_" + name.replaceAll(' ', '') + uniqueReferralCode;

    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    serviceProvider.hudLoadingEffect(context, true);

    Map<String, dynamic> resp = {};

    Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'mobile_no': mobile,
      'password1': password1,
      'password2': password2,
      'unique_referral_code':
          uniqueReferralCode, // THIS IS GENERATED BY THE SYSTEM AT THE POINT OF REGISTRATION
      'ur_referred_code':
          urReferredCode, // THIS IS THE ONE GIVEN TO YOU BY AN EXISTING USER. IT'S OPTIONAL AND ENTERED DURING REGISTRATION FORM
    };

    var response = await http
        .post(
            Uri.parse(
                '${dotenv.env['URL_ENDPOINT']}/api/v1/main/api_registration/'),
            body: json.encode(data),
            headers: {"Content-Type": "application/json"},
            encoding: Encoding.getByName("utf-8"))
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      var userProfile = json.decode(response.body);

      if (userProfile['isSuccess'] == false) {
        // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
        serviceProvider.hudLoadingEffect(context, false);

        if (userProfile['errorMsg'].containsKey('email')) {
          serviceProvider.popWarningErrorMsg(
              context, 'Error', userProfile['errorMsg']['email'][0].toString());
        } else if (userProfile['errorMsg'].containsKey('mobile_no')) {
          serviceProvider.popWarningErrorMsg(context, 'Error',
              userProfile['errorMsg']['mobile_no'][0].toString());
        } else if (userProfile['errorMsg'].containsKey('password2')) {
          serviceProvider.popWarningErrorMsg(context, 'Error',
              userProfile['errorMsg']['password2'][0].toString());
        } else if (userProfile['errorMsg']['referral_code'] != '') {
          serviceProvider.popWarningErrorMsg(context, 'Error',
              userProfile['errorMsg']['referral_code'].toString());
        }
      } else {
        var isEmail = await sendEmail(
            userProfile['name'],
            userProfile['otp_code'],
            'OTP Verification Code',
            userProfile['email']);

        // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
        serviceProvider.hudLoadingEffect(context, false);

        resp = userProfile;
        return resp;
      }
    } else {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      // serviceProvider.isLoadDialogBox = false;
      // serviceProvider.buildShowDialog(context);

      var userProfile = json.decode(response.body);
      if (userProfile['isSuccess'] == true) {
        resp = userProfile;
        return resp;
      } else {
        serviceProvider.popWarningErrorMsg(
            context, 'Error', userProfile['errorMsg'][0].toString());
      }
    }
  }

  Future sendEmail(String toName, otpCode, subject, replyTo) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    // setState(() {
    //   serviceProvider.isLoadDialogBox = true;
    //   serviceProvider.buildShowDialog(context);
    // });
    Map serverResp = {};
    try {
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
      var serviceId = 'service_8nivyd8';
      var templateId = 'template_2a1kv1h';
      var userId = 'C12pPOURw70lG3sZY';
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              "service_id": serviceId,
              "template_id": templateId,
              "user_id": userId,
              "template_params": {
                "to_name": toName,
                "subject": subject,
                "message": 'Your one time verification code is $otpCode',
                "reply_to": replyTo,
              }
            }),
          )
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        serverResp['errorMsg'] = '';
        serverResp['statusCode'] = 200;
      }
    } on Exception catch (e) {
      serverResp['errorMsg'] = e;
      serverResp['statusCode'] = '';
    } catch (error) {
      serverResp['errorMsg'] = error;
      serverResp['statusCode'] = '';
    }

    // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
    // serviceProvider.isLoadDialogBox = false;
    // serviceProvider.buildShowDialog(context);

    return serverResp;
  }

  var serviceProvider = ServiceProvider();

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: ServiceProvider.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          physics: const BouncingScrollPhysics(),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 35, 30, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
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
                          'Register',
                          style: ServiceProvider.pageNameFont,
                        ),
                        Container(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenH * 0.009,
                  ),
                  Text(
                    "Hi, let's guide you throught the process as a new user by filling the registration form.",
                    style: GoogleFonts.overlock().copyWith(
                      color: Colors.grey,
                      fontSize: 22,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  Text(
                    "Note: OTP code will be sent to the email supplied",
                    style: GoogleFonts.overlock().copyWith(
                      color: ServiceProvider.redWarningColor,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    style: Theme.of(context).textTheme.subtitle2,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
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
                    onChanged: (value) {
                      if (value.isNotEmpty && value.contains('@')) {
                        setState(() {
                          emailController.text;
                        });
                      } else if (!value.contains('@')) {
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
                    keyboardType: TextInputType.phone,
                    controller: mobileController,
                    style: Theme.of(context).textTheme.subtitle2,
                    inputFormatters: [maskFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Mobile No',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mobile number is required';
                      }
                      return null;
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
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
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
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: password2Controller,
                    style: Theme.of(context).textTheme.subtitle2,
                    decoration: InputDecoration(
                      labelText: 'Re-enter Password',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                        child: Icon(
                          _hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
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
                    obscureText: _hidePassword,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: referralCodeController,
                    style: Theme.of(context).textTheme.subtitle2,
                    decoration: const InputDecoration(
                      labelText: 'Referral Code (Optional)',
                    ),
                    validator: (value) {
                      // if (value == null || value.isEmpty) {
                      //   return 'Name is required';
                      // }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: MaterialButton(
                        disabledColor: Colors.grey.shade300,
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        color: ServiceProvider.innerBlueBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        onPressed: !emailController.text.contains('@')
                            ? null
                            : () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_formKey.currentState!.validate()) {
                                  if (mobileController.text.length != 13) {
                                    serviceProvider.popWarningErrorMsg(
                                        context,
                                        'Warning',
                                        'Mobile number is not complete!');
                                  } else if (password1Controller.text !=
                                      password2Controller.text) {
                                    serviceProvider.popWarningErrorMsg(
                                        context,
                                        'Warning',
                                        'The two password does not match!');
                                  } else {
                                    var responseData = await registration(
                                        nameController.text,
                                        emailController.text,
                                        mobileController.text
                                            .replaceAll(' ', ''),
                                        password1Controller.text,
                                        password2Controller.text,
                                        referralCodeController.text
                                            .replaceAll(' ', ''));

                                    if (responseData != null) {
                                      if (responseData['isSuccess'] == true) {
                                        nameController.clear();
                                        emailController.clear();
                                        mobileController.clear();
                                        password1Controller.clear();
                                        password2Controller.clear();
                                        referralCodeController.clear();

                                        serviceProvider.showToast(context,
                                            'OTP code sent to your email');

                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                RouteManager.otpVerify,
                                                (Route<dynamic> route) => false,
                                                arguments: {
                                              'name': responseData['name'],
                                              'email': responseData['email'],
                                              'token': responseData['token'],
                                              'otpSecretKey': responseData[
                                                  'otp_secret_key'],
                                              'otpValidDate': responseData[
                                                  'otp_valid_date'],
                                              'call': '',
                                              'mobile': responseData['mobile'],
                                            });
                                      }
                                    }
                                  }
                                }
                              }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
