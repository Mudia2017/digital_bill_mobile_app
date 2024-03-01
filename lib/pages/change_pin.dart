import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChangePin extends StatefulWidget {
  final name, email, token;
  ChangePin({
    Key? key,
    required this.name,
    required this.email,
    required this.token,
  }) : super(key: key);

  @override
  _ChangePinState createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  List<String> currentPin = ["", "", "", ""];
  int pinIndex = 0;
  String oldPin = '';
  String pin1 = '';
  String pin2 = '';

  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var serviceProvider = Provider.of<ServiceProvider>(context);
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) => Container(
            // color: ServiceProvider.backGroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: screenH * 0.023,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        height: screenH * 0.053,
                        width: screenW * 0.12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: themeManager.currentTheme == ThemeMode.light
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
                      'Change Pin',
                      style: ServiceProvider.pageNameFont,
                    ),
                    avatarIcon(),
                  ],
                ),
                getName(),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    'If pin is successfully changed, the new pin will be required to access your account & daily transactions.',
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
                if (oldPin == '')
                  Text(
                    'Key in old pin',
                    style: ServiceProvider.redContentFont,
                  )
                else
                  Text(
                    'Key in new pin',
                    style: ServiceProvider.redContentFont,
                  ),
                // if (loginAttemptCount > 4)
                //   Text(
                //     "Try again in $_start",
                //     style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold,
                //         color: ServiceProvider.redWarningColor),
                //   ),
                const Expanded(
                  child: SizedBox(),
                ),
                // if (isActiveBtn)
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: numberKeyPad(),
                ),
                // if (!isActiveBtn)
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 30),
                //   child: serviceProvider.disableNumberKeyPad(),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
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
          if (ServiceProvider.profileImgFrmServer != '' &&
              ServiceProvider.profileImgFrmServer != dotenv.env['URL_ENDPOINT'])
            CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage(ServiceProvider.profileImgFrmServer))
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
            )
        ],
      ),
    );
  }

  Widget getName() {
    double screenW = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(child: Container()),
        Container(
          padding: const EdgeInsets.only(right: 13),
          width: screenW * 0.7,
          child: Text(
            widget.name,
            style: GoogleFonts.sarabun(
              fontWeight: FontWeight.w200,
            ).copyWith(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: themeManager.currentTheme == ThemeMode.light
                    ? Colors.black87
                    : Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
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

      // GET THE OLD PIN
      if (oldPin == '') {
        print('OLD PIN');
        oldPin = strPin;
        serviceProvider.popDialogMsg(context, 'Info', 'Enter your new pin.');
        pinIndex = 0;
        pinOneController.clear();
        pinTwoController.clear();
        pinThreeController.clear();
        pinFourController.clear();
        setState(() {});
      } else if (pin1 == '') {
        pin1 = strPin;
        print('PIN 1');
        serviceProvider.popDialogMsg(
            context, 'Info', 'Repeat your security pin again.');
        pinIndex = 0;
        pinOneController.clear();
        pinTwoController.clear();
        pinThreeController.clear();
        pinFourController.clear();
      } else {
        pin2 = strPin;
        print('PIN 2');
        if (pin1.toString().length == 4 && pin2.toString().length == 4) {
          if (pin1.compareTo(pin2) == 0) {
            // SAVE THE PIN TO THE DATA BASE
            pinOneController.clear();
            pinTwoController.clear();
            pinThreeController.clear();
            pinFourController.clear();
            // SAVE THE PIN TO THE DATA BASE
            var serverResp = await serviceProvider.changeUserPin(
                context, widget.token, widget.email, widget.name, oldPin, pin1);
            strPin = '';
            pinIndex = 0;
            oldPin = '';
            pin1 = '';
            pin2 = '';
            if (serverResp['isSuccess'] == false) {
              if (serverResp['errorMsg'] != '') {
                serviceProvider.popWarningErrorMsg(
                    context, 'Error', serverResp['errorMsg'].toString());
              } else {
                serviceProvider.popWarningErrorMsg(
                    context, 'Error', 'Something went wrong!!!');
              }
            } else {
              bool isOkay = await serviceProvider.popDialogMsg(context, 'Info',
                  'Your security pin was successfully changed.');
              if (isOkay) {
                Navigator.of(context).pop();
              }
            }
          } else {
            serviceProvider.popWarningErrorMsg(context, 'Warning',
                'The two pin did not match. Kindly start again.');
            pinIndex = 0;
            oldPin = '';
            pin1 = '';
            pin2 = '';
            pinOneController.clear();
            pinTwoController.clear();
            pinThreeController.clear();
            pinFourController.clear();
            print('PIN DID NOT MATCH');
          }
        } else {
          serviceProvider.popWarningErrorMsg(
              context, 'Warning', 'The two pin did not match. Start again.');
          pinIndex = 0;
          oldPin = '';
          pin1 = '';
          pin2 = '';
          pinOneController.clear();
          pinTwoController.clear();
          pinThreeController.clear();
          pinFourController.clear();
          print('NOT THE SAME LENGHT');
        }
        setState(() {});
      }
    }
  }
}
