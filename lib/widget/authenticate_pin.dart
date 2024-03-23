import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class AuthenticatePin extends StatefulWidget {
  final name, email, token, call;
  Image? prefImage;
  String? pageTitle,
      pageInfo1,
      pageInfo2,
      requestedAmt,
      mobileTransNo,
      providerChoice,
      subscriptionId,
      dataAmt;
  bool? isNumSetAsDefault;
  String? serviceProvided;

  AuthenticatePin({
    Key? key,
    required this.name,
    required this.email,
    required this.token,
    required this.call,
    this.prefImage,
    this.pageTitle,
    this.pageInfo1,
    this.pageInfo2,
    this.requestedAmt,
    this.mobileTransNo,
    this.providerChoice,
    this.subscriptionId,
    this.dataAmt,
    this.isNumSetAsDefault,
    this.serviceProvided,
  }) : super(key: key);

  @override
  _AuthenticatePinState createState() => _AuthenticatePinState();
}

class _AuthenticatePinState extends State<AuthenticatePin> {
  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }

  List<String> currentPin = ["", "", "", ""];
  int pinIndex = 0;
  String pin1 = '';

  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();

  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  Widget build(BuildContext context) {
    var serviceProvider = Provider.of<ServiceProvider>(context);
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Builder(
            builder: (context) => Column(
                  children: [
                    Visibility(
                      child: serviceProvider.noInternetConnectionBadge(context),
                      visible: Provider.of<InternetConnectionStatus>(context) ==
                          InternetConnectionStatus.disconnected,
                    ),
                    SizedBox(
                      height: screenH * 0.023,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.only(left: 0),
                              height: screenH * 0.053,
                              width: screenW * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: themeManager.currentTheme ==
                                        ThemeMode.light
                                    ? const Color.fromRGBO(118, 123, 126, 0.7)
                                    : ServiceProvider.blueTrackColor,
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            widget.pageTitle!,
                            style: ServiceProvider.pageNameFont,
                          ),
                          avatarIcon(),
                        ],
                      ),
                    ),
                    getName(),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Center(
                      child: Text(
                        widget.pageInfo1!,
                        style: ServiceProvider.pageInfoWithDarkGreyFont,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          pinField(pinOneController),
                          pinField(pinTwoController),
                          pinField(pinThreeController),
                          pinField(pinFourController),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 30, left: 12, right: 12),
                      child: numberKeyPad(),
                    ),
                  ],
                )),
      ),
    );
  }

  // AVATAR ICON
  Widget avatarIcon() {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (ServiceProvider.profileImgFrmServer != '')
          serviceProvider.displayProfileImg(context)
        // CircleAvatar(
        //     radius: 30,
        //     backgroundImage:
        //         NetworkImage(ServiceProvider.profileImgFrmServer))
        else if (ServiceProvider.temporaryLocalImg != null)
          CircleAvatar(
            radius: 30,
            backgroundImage: (ServiceProvider.temporaryLocalImg!.image),
          )
        else
          CircleAvatar(
            radius: 30,
            backgroundColor: ServiceProvider.lightgray2,
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.grey.shade600,
            ),
          ),
      ],
    );
  }

  Widget getName() {
    return Container(
      padding: const EdgeInsets.only(right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${widget.name}',
            style: ServiceProvider.greetUserFont1,
          )
        ],
      ),
    );
  }

  // PIN INPUT FIELD
  pinField(controllerIndex) {
    return SizedBox(
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

  pinIndexSetup(String text) async {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
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
      print(strPin);

      // AUTHENTICATE USER'S PIN IN THE SERVER
      var resp = await serviceProvider.processTransaction(
        context,
        widget.token,
        widget.email,
        widget.name,
        strPin,
        widget.call,
        widget.requestedAmt,
        widget.mobileTransNo,
        widget.providerChoice,
        widget.subscriptionId,
        widget.dataAmt,
        widget.isNumSetAsDefault,
        widget.serviceProvided,
      );

      if (resp['isSuccess'] == true) {
        // CHECK IF MOBILE APP HAS FINGER PRINT SENSOR
        if (_supportState) {
          print('DEVICE IS SUPPORTED...');
          // await _getAvailableBiometrics();
        } else {
          print('NOT SUPPORTED');
        }

        // ServiceProvider.acctBal = resp['closingBal'];

        print(ServiceProvider.acctBal);
        Navigator.pop(context, resp);
      } else {
        // if (resp['errorMsg'] == 'Account is not verified') {
        pinIndex = 0;
        pin1 = '';
        pinOneController.clear();
        pinTwoController.clear();
        pinThreeController.clear();
        pinFourController.clear();
        serviceProvider.popWarningErrorMsg(
            context, 'Error', resp['errorMsg'].toString());
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   RouteManager.login,
        //   (Route<dynamic> route) => false,
        // );
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

  // AUTHENTICATE USER BIOMETRICS
  Future<void> _authenticate() async {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);

    try {
      bool authenticated = await auth.authenticate(
        localizedReason:
            'Subscribe or you will never find any stack overflow answer',
        stickyAuth: true,
        biometricOnly: true,
      );

      print('Authenticated : $authenticated');
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
