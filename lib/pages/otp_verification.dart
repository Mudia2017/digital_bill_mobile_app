import 'dart:async';
import 'dart:convert';

import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class OTPVerification extends StatefulWidget {
  final String name, email, token, mobile;
  String otpSecretKey, otpValidDate, call;
  OTPVerification({
    Key? key,
    required this.name,
    required this.email,
    required this.token,
    required this.otpSecretKey,
    required this.otpValidDate,
    required this.call,
    required this.mobile,
  }) : super(key: key);

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  @override
  void initState() {
    super.initState();
    // SchedulerBinding.instance!.addPersistentFrameCallback((_) {
    // _requestFrmLogin();
    // serviceProvider.showToast(context, 'OTP code sent to your email.');
    // });
  }

  List<String> currentPin = ["", "", "", "", ""];
  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();
  TextEditingController pinFiveController = TextEditingController();
  int otpAttemptCount = 0;
  bool isOtpLinkBtn = true;
  int _start = 0;

  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.transparent),
  );

  int pinIndex = 0;

  // REQUEST TO RE-GENERATE OTP VERIFICATION CODE
  resendOTPCode(String name, email, token) async {
    try {
      // CHECK IF THERE IS INTERNET CONNECTION
      if (Provider.of<InternetConnectionStatus>(context, listen: false) ==
          InternetConnectionStatus.connected) {
        // JUST TO ENSURE THE NUMBER OF ATTEMPT TO ENTER OPT IS RESET TO ZERO
        otpAttemptCount = 0;
        // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
        serviceProvider.hudLoadingEffect(context, true);

        Map<String, dynamic> data = {
          'name': name,
          'email': email,
        };

        var response = await http
            .post(
                Uri.parse(
                    '${dotenv.env['URL_ENDPOINT']}/api/v1/main/api_re_generate_otp/'),
                body: json.encode(data),
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": "Token $token",
                },
                encoding: Encoding.getByName("utf-8"))
            .timeout(const Duration(seconds: 60));

        if (response.statusCode == 200) {
          var serverResponse = json.decode(response.body);
          if (serverResponse['isSuccess'] == false) {
            // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
            serviceProvider.hudLoadingEffect(context, false);

            if (serverResponse['errorMsg'] != '') {
              serviceProvider.popWarningErrorMsg(
                  context, 'Error', serverResponse['errorMsg'].toString());
            }
          } else {
            var isEmail = await sendEmail(
                widget.name,
                serverResponse['otp_code'],
                'OTP Verification Code',
                widget.email);

            // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
            serviceProvider.hudLoadingEffect(context, false);

            setState(() {
              widget.otpSecretKey = serverResponse['otp_secret_key'];
              widget.otpValidDate = serverResponse['otp_valid_date'];
            });
          }
        } else {
          // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
          serviceProvider.hudLoadingEffect(context, false);
          serviceProvider.showErrorToast(
              context, 'Unable to connect with the server!');
        }
      } else {
        serviceProvider.popWarningErrorMsg(
            context, 'Warning', ServiceProvider.noInternetMsg);
      }
    } catch (error) {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      serviceProvider.hudLoadingEffect(context, false);
      serviceProvider.popWarningErrorMsg(context, 'Error', error.toString());
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
        setState(() {
          serviceProvider.showToast(context, 'OTP code sent to your email.');
        });
      } else {
        // UNABLE TO SEND EMAIL
        serviceProvider.showErrorToast(
            context, 'We were unable to send OTP code to the email provided!');
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

  // REQUEST TO CONFIRM OTP VERIFICATION CODE
  confirmOTPCode(String otp, token, otpSecretKey, otpValidDate) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    serviceProvider.hudLoadingEffect(context, true);

    Map<String, dynamic> data = {
      'otp': otp,
      'otp_secret_key': otpSecretKey,
      'otp_valid_date': otpValidDate,
    };
    print('OTP PIN: $otp');
    var response = await http.post(
        Uri.parse('${dotenv.env['URL_ENDPOINT']}/api/v1/main/api_confirm_otp/'),
        body: json.encode(data),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      serviceProvider.hudLoadingEffect(context, false);

      var serverResponse = json.decode(response.body);
      if (serverResponse['isSuccess'] == false) {
        if (serverResponse['errorMsg'] != '') {
          serviceProvider.popWarningErrorMsg(
              context, 'Error', serverResponse['errorMsg'].toString());
        }
        pinIndex = 0;
        pinOneController.clear();
        pinTwoController.clear();
        pinThreeController.clear();
        pinFourController.clear();
        pinFiveController.clear();

        setState(() {
          otpAttemptCount = 1;
          isOtpLinkBtn = false;
          _start = 60;
          startTimer();
        });
      } else {
        Navigator.of(context)
            .pushReplacementNamed(RouteManager.securityPin, arguments: {
          'name': widget.name,
          'token': widget.token,
          'email': widget.email,
          'mobile': widget.mobile,
        });
      }
    } else {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      serviceProvider.hudLoadingEffect(context, false);

      serviceProvider.popWarningErrorMsg(
          context, 'Error', 'Something went wrong!!!');
    }
  }

  _requestFrmLogin() {
    if (widget.call == 'requestFromLogin') {
      print('ABOUT TO SEND EMAIL');
      serviceProvider.showToast(context, "Click on 'Regenerate OTP'");
      // resendOTPCode(widget.name, widget.email, widget.token);
      widget.call = '';
      print('AFTER SENDING EMAIL');
    }
  }

  late Timer _timer = Timer(const Duration(milliseconds: 1), () {});

  startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            isOtpLinkBtn = true;
            otpAttemptCount = 0;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  var serviceProvider = ServiceProvider();

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: themeManager.currentTheme == ThemeMode.light
                        ? const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(0, 161, 213, 0.6),
                              Color.fromRGBO(167, 215, 232, 1),
                              // Colors.white,
                              Colors.white70
                            ],
                          )
                        : const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(0, 22, 38, 1),
                              Color.fromRGBO(0, 22, 38, 1),
                              Color.fromRGBO(0, 22, 38, 1),
                            ],
                          ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: (screenH * 5) / 100,
                      ),
                      Icon(
                        Icons.email,
                        size: 80,
                        color: Colors.lightBlue.shade200,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: themeManager.currentTheme == ThemeMode.light
                      ? Colors.white70
                      : ServiceProvider.darkNavyBGColor,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(35, 25, 35, 0),
                        child: Text(
                          'Hello ${widget.name}, your one time OTP verification code have been sent to your email',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue.shade200,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        widget.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                      if (otpAttemptCount > 0)
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Re-generate another OTP in $_start",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ServiceProvider.redWarningColor),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (isOtpLinkBtn)
                        InkWell(
                          child: const Text(
                            'Resend OPT code',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(0, 114, 244, 1),
                                fontStyle: FontStyle.italic),
                          ),
                          onTap: () {
                            resendOTPCode(
                                widget.name, widget.email, widget.token);
                          },
                        ),
                      if (!isOtpLinkBtn)
                        InkWell(
                          child: Text(
                            'Resend OPT code',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ServiceProvider.idColor,
                                fontStyle: FontStyle.italic),
                          ),
                          onTap: null,
                        ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Form(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              pinField(pinOneController),
                              pinField(pinTwoController),
                              pinField(pinThreeController),
                              pinField(pinFourController),
                              pinField(pinFiveController),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      if (isOtpLinkBtn) buildNumberPad(),
                      if (!isOtpLinkBtn) serviceProvider.disableNumberKeyPad(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildNumberPad() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KeyboardNumber(
                  n: 1,
                  onPressed: () {
                    pinIndexSetup("1");
                  },
                ),
                KeyboardNumber(
                  n: 2,
                  onPressed: () {
                    pinIndexSetup("2");
                  },
                ),
                KeyboardNumber(
                  n: 3,
                  onPressed: () {
                    pinIndexSetup("3");
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KeyboardNumber(
                  n: 4,
                  onPressed: () {
                    pinIndexSetup("4");
                  },
                ),
                KeyboardNumber(
                  n: 5,
                  onPressed: () {
                    pinIndexSetup("5");
                  },
                ),
                KeyboardNumber(
                  n: 6,
                  onPressed: () {
                    pinIndexSetup("6");
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KeyboardNumber(
                  n: 7,
                  onPressed: () {
                    pinIndexSetup("7");
                  },
                ),
                KeyboardNumber(
                  n: 8,
                  onPressed: () {
                    pinIndexSetup("8");
                  },
                ),
                KeyboardNumber(
                  n: 9,
                  onPressed: () {
                    pinIndexSetup("9");
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 60.0,
                  child: const MaterialButton(
                    onPressed: null,
                    child: SizedBox(),
                  ),
                ),
                KeyboardNumber(
                  n: 0,
                  onPressed: () {
                    pinIndexSetup("0");
                  },
                ),
                Container(
                  width: 60.0,
                  child: MaterialButton(
                    splashColor: ServiceProvider.redWarningColor,
                    height: 60.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    onPressed: () {
                      clearPin();
                    },
                    child: Icon(
                      Icons.backspace_outlined,
                      color: themeManager.currentTheme == ThemeMode.light
                          ? Colors.black
                          : ServiceProvider.whiteColorShade70,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == 5) {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    } else {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  pinIndexSetup(String text) async {
    if (pinIndex == 0) {
      pinIndex = 1;
    } else if (pinIndex < 5) {
      pinIndex++;
    }

    setPin(pinIndex, text);

    currentPin[pinIndex - 1] = text;
    String strPin = "";
    currentPin.forEach((element) {
      strPin += element;
    });
    if (pinIndex == 5) {
      print(strPin);
      await confirmOTPCode(
        strPin,
        widget.token,
        widget.otpSecretKey,
        widget.otpValidDate,
      );
    }
  }

  setPin(int n, String text) {
    switch (n) {
      case 1:
        pinOneController.text = text;
        break;
      case 2:
        pinTwoController.text = text;
        break;
      case 3:
        pinThreeController.text = text;
        break;
      case 4:
        pinFourController.text = text;
        break;
      case 5:
        pinFiveController.text = text;
        break;
    }
  }

  // PIN INPUT FIELD
  pinField(controllerIndex) {
    return SizedBox(
      height: 60,
      width: 55,
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        elevation: 6,
        shadowColor: Colors.lightBlue,
        child: TextFormField(
          controller: controllerIndex,
          enabled: false,
          // onChanged: (value) {
          //   if (value.length == 1) {
          //     FocusScope.of(context).nextFocus();
          //   }
          // },
          // onSaved: (pin1) {},
          decoration: InputDecoration(
            hintText: '0',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            fillColor: Colors.grey.shade300,
            filled: true,
            contentPadding: const EdgeInsets.only(
              top: 15,
            ),
          ),
          style: const TextStyle(
            fontSize: 35,
            color: Colors.black,
          ),
          // style: Theme.of(context).textTheme.headline4,
          // keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          // inputFormatters: [
          //   LengthLimitingTextInputFormatter(1),
          //   FilteringTextInputFormatter.digitsOnly,
          // ],
        ),
      ),
    );
  }
}
