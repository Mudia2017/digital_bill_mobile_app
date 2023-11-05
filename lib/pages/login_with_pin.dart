import 'dart:async';
import 'dart:convert';

import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/pages/home_page.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class LoginWithPin extends StatefulWidget {
  final String userName, email;
  LoginWithPin({
    Key? key,
    required this.userName,
    required this.email,
  }) : super(key: key);

  @override
  _LoginWithPinState createState() => _LoginWithPinState();
}

class _LoginWithPinState extends State<LoginWithPin> {
  @override
  void initState() {
    super.initState();

    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );

    initialCall();
  }

  List<String> currentPin = ["", "", "", ""];
  int pinIndex = 0;

  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();
  int loginAttemptCount = 0;
  final storage = const FlutterSecureStorage();
  bool isActiveBtn = true;
  var isBiometric = false;
  late final LocalAuthentication auth;
  bool _supportState = false;

  // GET PROFILE PICTURE
  Future acctProfilePix(String email) async {
    Map data = {'email': email};
    var serverResponse = {};
    var response = await http.post(
      Uri.parse('http://192.168.43.50:8000/api/v1/main/api_acctProfilePix/'),
      // Uri.parse('http://192.168.100.88:8000/api/v1/main/api_acctProfilePix/'),
      // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_acctProfilePix/'),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json",
      },
      // encoding: Encoding.getByName("utf-8")
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      // serviceProvider.isLoadDialogBox = false;
      // serviceProvider.buildShowDialog(context);

      serverResponse = json.decode(response.body);
      if (serverResponse['isSuccess'] == true) {
        if (serverResponse['image'] == 'http://192.168.43.50:8000') {
          setState(() {
            ServiceProvider.profileImgFrmServer = '';
          });
        } else {
          setState(() {
            ServiceProvider.profileImgFrmServer = serverResponse['image'];
          });
        }
      }
    }
  }

  // SEND SECURITY PIN TO BACKEND
  authenticateUserPin(String email, userName, pin) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    serviceProvider.hudLoadingEffect(context, true);

    Map<String, dynamic> data = {
      'email': email,
      'userName': userName,
      'pin': pin,
    };

    var response = await http
        .post(
            Uri.parse(
                'http://192.168.43.50:8000/api/v1/main/api_login_with_pin/'),
            // Uri.parse(
            //     'http://192.168.100.88:8000/api/v1/main/api_login_with_pin/'),
            // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_login_with_pin/'),
            body: json.encode(data),
            headers: {
              "Content-Type": "application/json",
            },
            encoding: Encoding.getByName("utf-8"))
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      serviceProvider.hudLoadingEffect(context, false);

      var serverResponse = json.decode(response.body);
      if (serverResponse['isSuccess'] == false) {
        if (serverResponse['errorMsg'] != '') {
          if (serverResponse['errorMsg'] == 'Pin is incorrect') {
            await tooMuchLoginAttempt();
          }
          pinIndex = 0;
          pinOneController.clear();
          pinTwoController.clear();
          pinThreeController.clear();
          pinFourController.clear();
          if (loginAttemptCount > 4) {
            setState(() {
              isActiveBtn = false;
              _start = 10 * loginAttemptCount;
              startTimer();
            });
          } else if (loginAttemptCount > 2) {
            String count = '';
            if (loginAttemptCount == 3) {
              count = 'Two more';
            } else if (loginAttemptCount == 4) {
              count = 'One more';
            } else {
              count = 'Last';
            }
            serviceProvider.popWarningErrorMsg(context, 'Error',
                "Too many incorrect pin attempt. Click on 'Log in' to use your email and password. $count try with pin, you will experience login delay!");
          } else {
            serviceProvider.popWarningErrorMsg(
                context, 'Error', serverResponse['errorMsg'].toString());
          }
        }
      } else {
        bool isLoginCounter = await storage.containsKey(key: 'loginCounter');
        if (isLoginCounter) {
          storage.delete(key: 'loginCounter');
        }
        pinIndex = 0;
        pinOneController.clear();
        pinTwoController.clear();
        pinThreeController.clear();
        pinFourController.clear();

        // Get.offAndToNamed(RouteManager.homePage, arguments: {
        //   'token': serverResponse['token'],
        //   'name': serverResponse['name'],
        //   'email': serverResponse['email']
        // });
        Navigator.of(context)
            .pushReplacementNamed(RouteManager.homePage, arguments: {
          'token': serverResponse['token'],
          'name': serverResponse['name'],
          'email': serverResponse['email'],
          'mobile': serverResponse['mobile'],
          'acctBal': serverResponse['acctBal'],
        });
      }
    } else {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      serviceProvider.hudLoadingEffect(context, false);

      pinIndex = 0;
      pinOneController.clear();
      pinTwoController.clear();
      pinThreeController.clear();
      pinFourController.clear();

      serviceProvider.popWarningErrorMsg(
          context, 'Error', 'Something went wrong!!!');
    }
  }

  var serviceProvider = ServiceProvider();

  Future tooMuchLoginAttempt() async {
    bool isLoginCounter = await storage.containsKey(key: 'loginCounter');
    if (isLoginCounter) {
      var count = await storage.read(key: 'loginCounter');
      count ??= '0';
      loginAttemptCount = int.parse(count);
      loginAttemptCount++;
      await storage.write(
          key: 'loginCounter', value: loginAttemptCount.toString());
    } else {
      storage.write(key: 'loginCounter', value: '1');
      loginAttemptCount = 1;
    }
  }

  late Timer _timer = Timer(const Duration(milliseconds: 1), () {});
  int _start = 10;

  startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            isActiveBtn = true;
            loginAttemptCount = 4;
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

  initialCall() async {
    await acctProfilePix(widget.email);
    isBiometric = await serviceProvider.getBiometric();
    // CHECK IF MOBILE APP HAS FINGER PRINT SENSOR
    if (isBiometric != null && isBiometric == true) {
      if (_supportState) {
        print('DEVICE IS SUPPORTED...');
        await _getAvailableBiometrics();
      } else {
        print('NOT SUPPORTED');
      }
    }
  }

  // GET AVAILABLE BIOMETRICS
  Future _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    print("List of availableBiometrics : $availableBiometrics");
    await _authenticate();
    if (!mounted) {
      return;
    }
  }

  // AUTHENTICATE USER BIOMETRICS TO LOG IN
  Future<void> _authenticate() async {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);

    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authentication is required to log in',
        stickyAuth: true,
        biometricOnly: true,
      );

      print('Authenticated : $authenticated');

      if (authenticated) {
        var resp = await serviceProvider.authenticateWithBiometrics(
            context, widget.email, widget.userName);
        if (resp['isSuccess'] == false) {
          serviceProvider.popWarningErrorMsg(
              context, 'Error', resp['errorMsg'].toString());
        } else if (resp['isSuccess'] == true) {
          Navigator.of(context)
              .pushReplacementNamed(RouteManager.homePage, arguments: {
            'token': resp['token'],
            'name': resp['name'],
            'email': resp['email'],
            'mobile': resp['mobile'],
            'acctBal': resp['acctBal'],
          });
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool isResponse = await serviceProvider.popWarningConfirmActionYesNo(
            context, 'Warning', 'Do you want to exit the app?', Colors.white60);
        if (isResponse == true) {
          SystemNavigator.pop();
        }
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Builder(
            builder: (context) => Container(
              // color: ServiceProvider.backGroundColor,
              // color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  avatarIcon(),
                  getName(),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      'Authorization is required to access your account!',
                      style: ServiceProvider.pageInfoWithDarkGreyFont,
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
                  loginWithEmail(),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  if (loginAttemptCount > 4)
                    Text(
                      "Try again in $_start",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ServiceProvider.redWarningColor),
                    ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  if (isActiveBtn)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: numberKeyPad(),
                    ),
                  if (!isActiveBtn)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: serviceProvider.disableNumberKeyPad(),
                    ),
                  createAcct(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                if (isBiometric != null && isBiometric == true)
                  Container(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    width: 60.0,
                    child: IconButton(
                      onPressed: () async {
                        // CHECK IF MOBILE APP HAS FINGER PRINT SENSOR
                        if (_supportState) {
                          print('DEVICE IS SUPPORTED...');
                          await _getAvailableBiometrics();
                        } else {
                          print('NOT SUPPORTED');
                        }
                      },
                      icon: const Icon(
                        Icons.fingerprint,
                        color: Colors.blue,
                        size: 50,
                      ),
                    ),
                  )
                else
                  const SizedBox(
                    width: 60.0,
                    child: MaterialButton(
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
      // print(strPin);
      // AUTHENTICATE USER'S PIN IN THE SERVER

      await authenticateUserPin(widget.email, widget.userName, strPin);
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
              // hintText: '0',
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

  // AVATAR ICON
  Widget avatarIcon() {
    return Container(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (ServiceProvider.profileImgFrmServer != '')
            CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage(ServiceProvider.profileImgFrmServer))
          else
            CircleAvatar(
                radius: 30,
                backgroundColor: ServiceProvider.lightgray2,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey.shade600,
                )),
        ],
      ),
    );
  }

  Widget getName() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Hi ${widget.userName},',
            style: ServiceProvider.greetUserFont1,
          )
        ],
      ),
    );
  }

  Widget createAcct() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Not a member?',
            style: TextStyle(color: ServiceProvider.idColor),
          ),
          InkWell(
            child: Text(
              ' Create an account',
              style: TextStyle(
                color: ServiceProvider.skyBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Get.toNamed(
                RouteManager.register,
              );
              // Navigator.of(context).pushNamed(RouteManager.register);
            },
          )
        ],
      ),
    );
  }

  Widget loginWithEmail() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Forgotten your pin or switch account?',
            style: TextStyle(
              color: ServiceProvider.idColor,
            ),
          ),
          InkWell(
              child: Text(
                ' Log in',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ServiceProvider.skyBlue,
                ),
              ),
              onTap: () {
                Get.toNamed(
                  RouteManager.login,
                  arguments: {'isLastStack': false},
                );
                // Navigator.of(context).pushNamed(RouteManager.login);
              })
        ],
      ),
    );
  }
}
