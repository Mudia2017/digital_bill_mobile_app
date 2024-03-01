import 'dart:convert';

import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SecurityPin extends StatefulWidget {
  final String name, token, email, mobile;
  const SecurityPin({
    Key? key,
    required this.name,
    required this.token,
    required this.email,
    required this.mobile,
  }) : super(key: key);

  @override
  _SecurityPinState createState() => _SecurityPinState();
}

class _SecurityPinState extends State<SecurityPin> {
  List<String> currentPin = ["", "", "", ""];
  int pinIndex = 0;
  String pin1 = '';
  String pin2 = '';

  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();

  // SEND SECURITY PIN TO BACKEND
  saveUserPin(String token, pin) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    serviceProvider.hudLoadingEffect(context, true);

    Map<String, dynamic> data = {
      'pin': pin,
    };

    var response = await http
        .post(
            Uri.parse(
                '${dotenv.env['URL_ENDPOINT']}/api/v1/main/api_secure_pin/'),
            body: json.encode(data),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Token $token",
            },
            encoding: Encoding.getByName("utf-8"))
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      serviceProvider.hudLoadingEffect(context, false);

      var serverResponse = json.decode(response.body);
      if (serverResponse['isSuccess'] == false) {
        if (serverResponse['errorMsg'] != '') {
          serviceProvider.popWarningErrorMsg(
              context, 'Error', serverResponse['errorMsg'].toString());
        }
      } else {
        addBiometricOtherOption();
        // Navigator.of(context)
        //     .pushReplacementNamed(RouteManager.homePage, arguments: {
        //   'token': widget.token,
        //   'name': widget.name,
        //   'email': widget.email,
        //   'mobile': widget.mobile,
        //   'acctBal': '0',
        // });
      }
    } else {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      serviceProvider.hudLoadingEffect(context, false);

      serviceProvider.popWarningErrorMsg(
          context, 'Error', 'Something went wrong!!!');
    }
  }

  var serviceProvider = ServiceProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                'Security Pin',
                style: ServiceProvider.pageNameFont,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                'Create your four digit security pin. It can be used to log into your account and it will also be needed in your daily transactions.',
                style: GoogleFonts.overlock().copyWith(
                  color: Colors.grey,
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                pinField(pinOneController),
                pinField(pinTwoController),
                pinField(pinThreeController),
                pinField(pinFourController),
              ],
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: numberKeyPad(),
            )
          ],
        ),
      )),
    );
  }

  addBiometricOtherOption() {
    bool isBiometric = false;
    return showModalBottomSheet(
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        backgroundColor: themeManager.currentTheme == ThemeMode.light
            ? Colors.white
            : ServiceProvider.darkNavyBGColor,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setstate) {
              return SizedBox(
                height: 200,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ServiceProvider.bottomSheetBarHeader,
                    const SizedBox(height: 50),
                    SwitchListTile(
                        inactiveTrackColor: Colors.grey,
                        secondary: Icon(
                          Icons.fingerprint,
                          color: ServiceProvider.innerBlueBackgroundColor,
                          size: 40,
                        ),
                        value: isBiometric,
                        title: Text(
                          'Enable Authentication with Biometrics',
                          style: GoogleFonts.overlock().copyWith(
                            color: Colors.grey,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        onChanged: (val) async {
                          // var isBiomet = await serviceProvider.isBiometric(val);
                          // if (isBiomet) {
                          setstate(() {
                            isBiometric = val;
                            serviceProvider.isBiometric(isBiometric);
                          });
                          // }
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                      child: MaterialButton(
                        disabledColor: Colors.grey.shade300,
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        color: ServiceProvider.innerBlueBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }).then((value) {
      Navigator.of(context)
          .pushReplacementNamed(RouteManager.profilePhoto, arguments: {
        'token': widget.token,
        'name': widget.name,
        'email': widget.email,
        'mobile': widget.mobile,
        'acctBal': '0',
      });
    });
  }

  numberKeyPad() {
    return Container(
      // alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    highlightColor: Colors.blue,
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
    } else if (pinIndex < 4) {
      pinIndex++;
    }

    setPin(pinIndex, text);

    currentPin[pinIndex - 1] = text;
    String strPin = "";
    currentPin.forEach((element) {
      strPin += element;
    });
    if (pinIndex == 4) {
      if (pin1 == '') {
        pin1 = strPin;
        serviceProvider.popDialogMsg(
            context, 'Info', 'Repeat your security pin again.');
        pinIndex = 0;
        pinOneController.clear();
        pinTwoController.clear();
        pinThreeController.clear();
        pinFourController.clear();
      } else {
        pin2 = strPin;

        if (pin1.toString().length == 4 && pin2.toString().length == 4) {
          if (pin1.compareTo(pin2) == 0) {
            // SAVE THE PIN TO THE DATA BASE
            await saveUserPin(widget.token, strPin);
            strPin = '';
            pinIndex = 0;
            pin1 = '';
            pin2 = '';
            pinOneController.clear();
            pinTwoController.clear();
            pinThreeController.clear();
            pinFourController.clear();
          } else {
            serviceProvider.popWarningErrorMsg(context, 'Warning',
                'The two pin did not match. Kindly start again.');
            pinIndex = 0;
            pin1 = '';
            pin2 = '';
            pinOneController.clear();
            pinTwoController.clear();
            pinThreeController.clear();
            pinFourController.clear();
          }
        } else {
          serviceProvider.popWarningErrorMsg(
              context, 'Warning', 'The two pin did not match. Start again.');
          pinIndex = 0;
          pin1 = '';
          pin2 = '';
          pinOneController.clear();
          pinTwoController.clear();
          pinThreeController.clear();
          pinFourController.clear();
        }
      }
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
    }
  }

  // PIN INPUT FIELD
  pinField(controllerIndex) {
    return Container(
      child: SizedBox(
        height: 60,
        width: 55,
        child: PhysicalModel(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          elevation: 5,
          shadowColor: Colors.black,
          child: TextFormField(
            obscureText: true,
            controller: controllerIndex,
            enabled: false,
            // onChanged: (value) {
            //   if (value.length == 1) {
            //     // FocusScope.of(context).nextFocus();
            //   }
            // },
            // onSaved: (pin4) {},
            decoration: InputDecoration(
              hintText: '*',
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
            // style: Theme.of(context).textTheme.headline6,
            // keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            // inputFormatters: [
            //   LengthLimitingTextInputFormatter(1),
            //   FilteringTextInputFormatter.digitsOnly,
            // ],
          ),
        ),
      ),
    );
  }
}
