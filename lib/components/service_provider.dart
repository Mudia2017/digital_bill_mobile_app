import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:number_display/number_display.dart';

class ServiceProvider extends ChangeNotifier {
  bool isShowBal = true;
  bool isLifeCycleState = true; // THIS IS USED ON THE LIFE-CYCLE-STATE
  static bool isEditProfile =
      false; // USED ON THE HOME PAGE TO CHECK IF PROFILE WAS EDITED
  static String acctBal = '0';
  static bool isAuthorizeTrans =
      true; // USED TO CHECK IF PIN IS REQUIRED WHEN PERFORMING TRANSACTIONS
  static String profileImgFrmServer = '';
  static Image? temporaryLocalImg;
  static String userAgreement = '';
  static String urReferralCode = '';

  static Color idColor = const Color(0xFF9ca2ac);
  static Color backGroundColor = const Color.fromRGBO(230, 233, 235, 1);
  static Color darkBlue = const Color.fromRGBO(2, 23, 48, 1);
  static Color darkBlueShade4 = const Color.fromRGBO(0, 38, 112, 1);
  static Color skyBlue = const Color.fromRGBO(0, 114, 244, 1);
  static Color selectBackGroundColor = const Color(0xFFf1f4f8);
  static Color lightBlueBackGroundColor = const Color.fromRGBO(34, 118, 173, 1);
  static Color innerBlueBackgroundColor = const Color.fromRGBO(55, 134, 180, 1);
  static Color redWarningColor = const Color.fromRGBO(188, 75, 77, 1);
  static Color lightgray2 = const Color.fromRGBO(132, 132, 132, 0.2);
  static Color lightBlueWriteColor = const Color.fromRGBO(136, 215, 244, 1);
  static Color greyBGbackArrow = const Color.fromRGBO(118, 123, 126, 0.7);

  // ADDITIONAL COLORS FOR DARK MODE
  static Color blueTrackColor = const Color.fromRGBO(22, 43, 68, 1);
  static Color whiteColorShade70 = Colors.white70;
  static Color darkNavyBGColor = const Color.fromRGBO(0, 22, 38, 1);

  // ==================== TEXT STYLING ====================
  static TextStyle greetUserFont1 = GoogleFonts.sarabun(
    fontWeight: FontWeight.w200,
    fontStyle: FontStyle.italic,
  ).copyWith(
    color: Colors.grey,
    fontSize: 23,
  );

  static TextStyle blueBgFontName = GoogleFonts.sarabun(
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  ).copyWith(
    color: Colors.white,
    fontSize: 16,
  );

  static TextStyle pageNameFont = GoogleFonts.sora().copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 22,
  );

  static TextStyle pageNameFontBlueBG = GoogleFonts.sora().copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: Colors.white,
  );

  static TextStyle pageInfoWithLightGreyFont = GoogleFonts.sarabun(
    fontWeight: FontWeight.w200,
    fontStyle: FontStyle.italic,
  ).copyWith(
    color: Colors.grey.withOpacity(0.6),
    fontSize: 23,
  );

  static TextStyle pageInfoWithDarkGreyFont = GoogleFonts.overlock().copyWith(
    color: Colors.grey,
    fontSize: 18,
    fontStyle: FontStyle.italic,
  );

  static TextStyle blueWriteOnBlueBgColorFont = GoogleFonts.sora().copyWith(
    fontSize: 13,
    color: const Color.fromRGBO(136, 215, 244, 1),
  );

  static TextStyle warningFont = GoogleFonts.sora().copyWith(
    color: Color.fromRGBO(241, 88, 75, 0.4),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static TextStyle contentFont = GoogleFonts.sora().copyWith();

  static TextStyle smallFontBlackContent = GoogleFonts.sora().copyWith(
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );

  static TextStyle smallFontGreyContent = GoogleFonts.sarabun().copyWith(
    fontSize: 10,
    color: Colors.grey,
  );

  static TextStyle smallFontWhiteContent = GoogleFonts.sarabun().copyWith(
    fontSize: 10,
    color: Colors.white,
  );

  static TextStyle redContentFont = GoogleFonts.sora()
      .copyWith(color: const Color.fromRGBO(242, 123, 128, 1));

  static TextStyle cardFontBold4 = GoogleFonts.chakraPetch().copyWith(
      fontWeight: FontWeight.w400,
      color: Colors.black45,
      fontSize: 26,
      letterSpacing: 4.0);

  static TextStyle cardFontBoldLight = GoogleFonts.chakraPetch().copyWith(
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontSize: 26,
      letterSpacing: 4.0);

  static TextStyle cardFontBold7 = GoogleFonts.chakraPetch().copyWith(
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontSize: 26,
  );

  //  ================ WIDGET CUSTOM STYLING =============
  static Container bottomSheetBarHeader = Container(
    width: 90,
    height: 5,
    decoration: BoxDecoration(
        color: Colors.grey, borderRadius: BorderRadius.circular(15)),
  );

  // === LOADING ICON DISPLAY WHEN WAITING FOR SERVER RESPONSE

  hudLoadingEffect(BuildContext context, bool isLoadDialogBox) {
    isLoadDialogBox
        ? showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black12,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                    elevation: 0,
                    backgroundColor: Colors.black54,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    title: Builder(builder: (context) {
                      return Column(
                        children: const [
                          CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Loading...",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      );
                    }));
              });
            },
          )
        : Navigator.of(context, rootNavigator: true).pop();
  }

  // == USED TO DISPLAY A WARNING OR ERROR MESSAGE WITH OK BUTTON ==
  Future popWarningErrorMsg(BuildContext context, String titleMsg, contentMsg) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.black38,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0.7),
              scrollable: true,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Center(
                child: Column(
                  children: [
                    Text(
                      titleMsg,
                      style: GoogleFonts.sora().copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow.shade800),
                    ),
                    const Divider(
                      color: Colors.white60,
                    ),
                  ],
                ),
              ),
              content: Text(
                contentMsg,
                style: GoogleFonts.sora()
                    .copyWith(fontSize: 15, color: Colors.white60),
                textAlign: TextAlign.center,
              ),
              actions: [
                Center(
                  child: MaterialButton(
                      color: Colors.blue.shade400,
                      child: const Text(
                        'Ok',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      onPressed: () {
                        Navigator.pop(context, true);
                      }),
                ),
              ],
            );
          });
        });
  }

  // ========= USED TO DISPLAY A POP UP MESSAGE ===========
  Future popDialogMsg(BuildContext context, String titleMsg, contentMsg) {
    return showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black38,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0.7),
              // backgroundColor: Colors.blue.shade100,
              scrollable: true,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Center(
                child: Column(
                  children: [
                    Text(
                      titleMsg,
                      style: GoogleFonts.sora().copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color.fromRGBO(0, 161, 213, 1)),
                    ),
                    const Divider(
                      color: Colors.white60,
                    ),
                  ],
                ),
              ),
              content: Text(
                contentMsg,
                style: GoogleFonts.sarabun()
                    .copyWith(fontSize: 15, color: Colors.white60),
                textAlign: TextAlign.center,
              ),
              actions: [
                Center(
                  child: MaterialButton(
                      color: Colors.blue.shade400,
                      elevation: 0,
                      child: const Text(
                        'Ok',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      onPressed: () {
                        Navigator.pop(context, true);
                      }),
                ),
              ],
            );
          });
        });
  }

  // ========= USED TO DISPLAY A POP UP MESSAGE ===========
  Future popDialogMsgAlignLeft(
      BuildContext context, String titleMsg, contentMsg) {
    return showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black38,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0.7),
              // backgroundColor: Colors.blue.shade100,
              scrollable: true,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Center(
                child: Column(
                  children: [
                    Text(
                      titleMsg,
                      style: GoogleFonts.sora().copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color.fromRGBO(0, 161, 213, 1)),
                    ),
                    const Divider(
                      color: Colors.white60,
                    ),
                  ],
                ),
              ),
              content: Text(
                contentMsg,
                style: GoogleFonts.sarabun()
                    .copyWith(fontSize: 15, color: Colors.white60),
              ),
              actions: [
                Center(
                  child: MaterialButton(
                      color: Colors.blue.shade400,
                      elevation: 0,
                      child: const Text(
                        'Ok',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      onPressed: () {
                        Navigator.pop(context, true);
                      }),
                ),
              ],
            );
          });
        });
  }

  // == USED TO DISPLAY A WARNING CONFIRMATION MESSAGE WITH YES OR NO ==
  Future popWarningConfirmActionYesNo(
      BuildContext context, String titleMsg, contentMsg, Color color) {
    return showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black38,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0.7),
              scrollable: true,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Column(
                children: [
                  Center(
                    child: Text(
                      titleMsg,
                      style: GoogleFonts.sora().copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow.shade800),
                    ),
                  ),
                  const Divider(
                    color: Colors.white60,
                  ),
                ],
              ),
              content: Text(
                contentMsg,
                style: GoogleFonts.sora().copyWith(fontSize: 15, color: color),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                        color: Colors.grey.shade700,
                        child: const Text(
                          'No',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        onPressed: () {
                          Navigator.pop(context, false);
                        }),
                    MaterialButton(
                        color: Colors.blue.shade400,
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        onPressed: () {
                          Navigator.pop(context, true);
                        }),
                  ],
                ),
              ],
            );
          });
        });
  }

  // SAVE USER PROFILE TO LOCAL DB
  saveUserInfoToLocalStorage(String name, email, token, mobile) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'userName', value: name);
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'mobile', value: mobile);
  }

  getUserInfo() async {
    const storage = FlutterSecureStorage();
    Map userData = {};
    var token = '';
    var email = '';
    var name = '';
    var mobile = '';
    bool isTokenKey = await storage.containsKey(key: 'token');
    bool isEmailKey = await storage.containsKey(key: 'email');
    bool isNameKey = await storage.containsKey(key: 'userName');
    bool isMobileKey = await storage.containsKey(key: 'mobile');
    if (isTokenKey && isEmailKey && isNameKey && isMobileKey) {
      token = (await storage.read(key: 'token')).toString();
      email = (await storage.read(key: 'email')).toString();
      name = (await storage.read(key: 'userName')).toString();
      mobile = (await storage.read(key: 'mobile')).toString();
    }
    // return {
    //   'token': token,
    //   'email': email,
    //   'name': name,
    //   'mobile': mobile,
    // };
    userData = {
      'token': token,
      'name': name,
      'email': email,
      'mobile': mobile,
    };
    return userData;
  }

  authenticateUser(context, name, email) async {
    const storage = FlutterSecureStorage();
    var tokenKey = await storage.read(key: 'token');
    bool isLoginCounter = await storage.containsKey(key: 'loginCounter');

    if (isLoginCounter) {
      storage.delete(key: 'loginCounter');
    }
    if (tokenKey == null) {
      Navigator.of(context)
          .pushReplacementNamed(RouteManager.loginWithPin, arguments: {
        'userName': name,
        'email': email,
      });
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //   RouteManager.loginWithPin,
      //   (Route<dynamic> route) => false,
      // );
    }
  }

  // USED TO GET USER NAME, TOKEN & EMAIL FROM LOCAL SECURE STORAGE
  getUserProfile(context) async {
    Map userData = {};
    var token, email, name, mobile;
    var storage = const FlutterSecureStorage();
    bool isTokenKey = await storage.containsKey(key: 'token');
    bool isEmailKey = await storage.containsKey(key: 'email');
    bool isNameKey = await storage.containsKey(key: 'userName');
    bool isMobileKey = await storage.containsKey(key: 'mobile');
    if (isTokenKey) {
      token = await storage.read(key: 'token');
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteManager.login,
        (Route<dynamic> route) => false,
        arguments: {'isLastStack': true},
      );
    }
    if (isEmailKey) {
      email = await storage.read(key: 'email');
    }
    if (isNameKey) {
      name = await storage.read(key: 'userName');
    }
    if (isMobileKey) {
      mobile = await storage.read(key: 'mobile');
    }
    userData = {
      'token': token,
      'name': name,
      'email': email,
      'mobile': mobile,
    };
    return userData;
  }

  logOutUser() async {
    const storage = FlutterSecureStorage();
    bool isTokenKey = await storage.containsKey(key: 'token');
    if (isTokenKey) {
      storage.delete(key: 'token');
    }
  }

  // DELETE ALL PROFILE INFO AND RETURN TO SIGN IN PAGE WITH EMAIL AND PASSWORD
  signOut() async {
    const storage = FlutterSecureStorage();
    bool isTokenKey = await storage.containsKey(key: 'token');
    bool isEmailKey = await storage.containsKey(key: 'email');
    bool isNameKey = await storage.containsKey(key: 'userName');
    bool isMobileKey = await storage.containsKey(key: 'mobile');
    if (isTokenKey) {
      storage.delete(key: 'token');
    }
    if (isEmailKey) {
      storage.delete(key: 'email');
    }
    if (isNameKey) {
      storage.delete(key: 'userName');
    }
    if (isMobileKey) {
      storage.delete(key: 'mobile');
    }

    // ERASE THIS LOCAL VARIABLE USED FOR PROFILE PICTURE
    ServiceProvider.temporaryLocalImg = null;
    ServiceProvider.profileImgFrmServer = '';
    ServiceProvider.urReferralCode = '';
    return true;
  }

  // ============ FIGURE FORMATTER TO TWO DECIMAL PLACES ===========
  numberFormater(double value) {
    var formatter = NumberFormat('#,###,000.00');
    String num = '';
    num = (formatter.format(value));
    // print(formatter.format(13876));
    // print(formatter.format(456786));
    return num;
  }
  // var f = NumberFormat('###.0#', 'en_US');

  final formattedNumber = createDisplay(
    length: 12,
    separator: ',',
    decimal: 2,
    decimalPoint: '.',
  );

  // =============== DATE FORMATTER ============
  String formatDateWithStroke(dateFormat) {
    final DateFormat dateFormater = DateFormat('yyyy/MM/dd');
    return dateFormater.format(dateFormat);
  }

  String formatDateWithDash(dateFormat) {
    final DateFormat dateFormater = DateFormat('yyyy-MM-dd');
    return dateFormater.format(dateFormat);
  }

  // DISABLE KEY PAD BUTTONS
  disableNumberKeyPad() {
    return Container(
      // alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                DisableKeyboardNumber(
                  n: 1,
                ),
                DisableKeyboardNumber(
                  n: 2,
                ),
                DisableKeyboardNumber(
                  n: 3,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                DisableKeyboardNumber(
                  n: 4,
                ),
                DisableKeyboardNumber(
                  n: 5,
                ),
                DisableKeyboardNumber(
                  n: 6,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                DisableKeyboardNumber(
                  n: 7,
                ),
                DisableKeyboardNumber(
                  n: 8,
                ),
                DisableKeyboardNumber(
                  n: 9,
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
                const DisableKeyboardNumber(
                  n: 0,
                ),
                Container(
                  width: 60.0,
                  child: MaterialButton(
                    highlightColor: Colors.blue,
                    height: 60.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    onPressed: null,
                    child: const Icon(
                      Icons.backspace_outlined,
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

  void showToast(BuildContext context, String contentMsg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.report_gmailerrorred_rounded,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(child: Text(contentMsg)),
          ],
        ),
      ),
    );
  }

  void showSuccessToast(BuildContext context, String contentMsg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(child: Text(contentMsg)),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showErrorToast(BuildContext context, String contentMsg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.nearby_error_outlined,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(child: Text(contentMsg)),
          ],
        ),
        backgroundColor: Colors.red.shade400,
      ),
    );
  }

  // SAVED LIFE CYCLE STATE OF ANY ACCT LOGGED IN.
  // IN CASES LIKE "PRINTING STATEMENT TO PDF" WHERE WE WILL GO
  // OUTSIDE THE LIFE CYCLE OF THE APP, THE LIFE CYCLE STATE
  // IS ALWAYS BEEN ALTER. ON RETURNING BACK TO THE APP, WE CAN
  // GET THE STATUS FROM SHARED PREF.

  Future<bool> isSetLifeCycleToPref(bool val) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool('prefLifeCycleState', val);
  }

  // GET BIOMETRIC VALUE FROM SHARED PREFERENCE
  Future getLifeCycleStateFrmPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool('prefLifeCycleState');
  }

  // TOGGLE USE OF BIOMETRIC TO SHARED PREFERENCE
  Future<bool> isBiometric(bool val) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool('biometric', val);
  }

  // GET BIOMETRIC VALUE FROM SHARED PREFERENCE
  Future getBiometric() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool('biometric');
  }

  // SAVE IMAGE FILE INTO SHARED PREFERENCES
  static const IMG_KEY = 'IMAGE_KEY';
  Future<bool> saveImageToPreferences(String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    // isUpdateProfilePix = true;
    // notifyListeners();
    return preferences.setString(IMG_KEY, value);
  }

  static Future<String?> getImageFromPreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey(IMG_KEY)) {
      return preferences.getString(IMG_KEY);
    }
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  Image? imageFromPreference;
  loadImageFromPreferences() {
    getImageFromPreferences().then((img) {
      if (null == img) {
        return imageFromPreference = null;
      }
      imageFromPreference = imageFromBase64String(img);
    });
    return imageFromPreference;
  }

  // FUNCTION TO DELETE IMAGE FROM SHARED PREFERENCE
  delProfilePixFrmPreference() async {
    final preference = await SharedPreferences.getInstance();
    if (preference.containsKey(IMG_KEY)) {
      print('ABOUT TO DELETE IMAGE KEY FROM PREF...');
      preference.remove(IMG_KEY);
      // isUpdateProfilePix = false;
      var prf = preference.getString(IMG_KEY);
      print('IMAGE KEY HAVE BEEN REMOVED FROM PREF');
      // notifyListeners();
    }
  }

  // FUNCTION TO SET DEFAULT NUMBER IN SHARED PREFERENCE
  saveDefaultDataNumToPref(dataNum) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('dataNum', dataNum);
  }

  saveDefaultAirtimeNumToPref(airtimeNum) async {
    final pref = await SharedPreferences.getInstance();

    pref.setString('airtimeNum', airtimeNum);
  }

  saveDefaultCableNumToPref(cableNum) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('cableNum', cableNum);
  }

  saveDefaultInternetNumToPref(internetNum) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('internetNum', internetNum);
  }

  saveDefaultMeterNumToPref(meterNum) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('meterNum', meterNum);
  }

  // GET DEFAULT NUMBER FROM SHARED PREF
  Future getDefaultNumFrmPref() async {
    Map data = {};
    final pref = await SharedPreferences.getInstance();
    data['dataNum'] = pref.getString('dataNum');
    data['airtimeNum'] = pref.getString('airtimeNum');
    data['cableNum'] = pref.getString('cableNum');
    data['internetNum'] = pref.getString('internetNum');
    data['meterNum'] = pref.getString('meterNum');

    return data;
  }

  // DELETE DEFAULT NUMBER FROM SHARED PREF WHEN SIGNING OUT
  Future deleteDefaultNumFrmPref() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove('dataNum');
    pref.remove('airtimeNum');
    pref.remove('cableNum');
    pref.remove('internetNum');
    pref.remove('meterNum');
  }

  Future getServiceProvider(String token) async {
    var serverResponse;
    var response = await http.get(
      Uri.parse('http://192.168.43.50:8000/api/v1/main/api_dataSubscription/'),
      // Uri.parse('http://192.168.100.88:8000/api/v1/main/api_dataSubscription/'),
      // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_dataSubscription/'),
      // body: json.encode(),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      // encoding: Encoding.getByName("utf-8")
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      serverResponse = json.decode(response.body);
    }
    return serverResponse;
  }

  // SIGN OUT USER ACCOUNT
  Future signOutAcct(String token) async {
    var serverResponse;
    var response = await http.post(
      Uri.parse('http://192.168.43.50:8000/api/v1/main/api_logoutUser/'),
      // Uri.parse('http://192.168.100.88:8000/api/v1/main/api_logoutUser/'),
      // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_logoutUser/'),
      // body: json.encode(),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      // encoding: Encoding.getByName("utf-8")
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      serverResponse = json.decode(response.body);
    }
    return serverResponse;
  }

  // GET ACCOUNT PROFILE
  Future acctProfile(String token) async {
    var serverResponse = {};
    var response = await http.post(
      Uri.parse('http://192.168.43.50:8000/api/v1/main/api_getProfileInfo/'),
      // Uri.parse('http://192.168.100.88:8000/api/v1/main/api_getProfileInfo/'),
      // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_getProfileInfo/'),
      // body: json.encode(),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      // encoding: Encoding.getByName("utf-8")
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      // serviceProvider.isLoadDialogBox = false;
      // serviceProvider.buildShowDialog(context);

      serverResponse = json.decode(response.body);
      if (serverResponse['isSuccess'] == true) {
        isShowBal = serverResponse['userProfile']['isBalVisible'];
        notifyListeners();
      }
    }
    return serverResponse;
  }

  // SET/UPDATE ACCOUNT PROFILE
  Future setUpdateAcct(context, String token, Map data) async {
    var serverResponse;
    // CALL THE DIALOG TO PREVENT USER PERFORM OPERATION ON THE UI
    hudLoadingEffect(context, true);

    // Map data = {'call': call, '_isShowAcctBal': isShowAcctBal};

    var response = await http
        .post(
          Uri.parse(
              'http://192.168.43.50:8000/api/v1/main/api_set_updateAcct/'),
          // Uri.parse(
          //     'http://192.168.100.88:8000/api/v1/main/api_set_updateAcct/'),
          // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_set_updateAcct/'),
          // body: json.encode(),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Token $token",
          },
          // encoding: Encoding.getByName("utf-8")
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      hudLoadingEffect(context, false);

      serverResponse = json.decode(response.body);
      isShowBal = serverResponse['isBalVisible'];
    } else {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      hudLoadingEffect(context, false);

      showErrorToast(context, 'Fail to update');
    }
    notifyListeners();
    return serverResponse;
  }

  // CHANGE SECURITY PIN
  Future changeUserPin(
      context, String token, email, name, oldPin, newPin) async {
    var serverResponse = {};
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    hudLoadingEffect(context, true);

    Map<String, dynamic> data = {
      'email': email,
      'userName': name,
      'oldPin': oldPin,
      'newPin': newPin,
    };

    var response = await http
        .post(
            Uri.parse('http://192.168.43.50:8000/api/v1/main/api_secure_pin/'),
            // Uri.parse('http://192.168.100.88:8000/api/v1/main/api_secure_pin/'),
            // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_secure_pin/'),
            body: json.encode(data),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Token $token",
            },
            encoding: Encoding.getByName("utf-8"))
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      hudLoadingEffect(context, false);

      var _serverResponse = json.decode(response.body);
      serverResponse = _serverResponse;
    } else {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      hudLoadingEffect(context, false);

      var _serverResponse = json.decode(response.body);
      serverResponse = _serverResponse;
    }
    return serverResponse;
  }

  // ============= CHANGE PASSWORD ============
  Future changePassword(context, token, email, name, oldPassword, newPassword1,
      newPassword2) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    hudLoadingEffect(context, true);
    Map serverResp = {};
    var data = {
      'old_password': oldPassword,
      'new_password1': newPassword1,
      'new_password2': newPassword2,
      'email': email,
      'userName': name,
    };
    var response = await http.post(
      Uri.parse('http://192.168.43.50:8000/api/v1/main/api_changePassword/'),
      // Uri.parse('http://192.168.100.88:8000/api/v1/main/api_changePassword/'),
      // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_changePassword/'),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    );

    try {
      if (response.statusCode == 200) {
        // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
        hudLoadingEffect(context, false);
        var serverResponse = json.decode(response.body);
        serverResp = serverResponse;
      }
    } catch (error) {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      hudLoadingEffect(context, false);
      rethrow;
    }
    return serverResp;
  }

  // ============= DELETE(DEACTIVATE) ACCOUNT ============
  Future deactivateAcct(context, token, email, password) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    hudLoadingEffect(context, true);
    Map serverResp = {};
    var data = {
      'password': password,
      'email': email,
    };
    var response = await http.post(
      Uri.parse('http://192.168.43.50:8000/api/v1/main/api_deactivateAccount/'),
      // Uri.parse(
      //     'http://192.168.100.88:8000/api/v1/main/api_deactivateAccount/'),
      // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_deactivateAccount/'),
      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    );

    try {
      if (response.statusCode == 200) {
        // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
        hudLoadingEffect(context, false);
        var serverResponse = json.decode(response.body);
        serverResp = serverResponse;
      }
    } catch (error) {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      hudLoadingEffect(context, false);
      rethrow;
    }
    return serverResp;
  }

  Future sendEmail(context, name, subject, emailBody) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    hudLoadingEffect(context, true);
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
                "to_name": name,
                "subject": subject,
                "message": emailBody,
                // "user_email": 'oskienterprises@gmail.com',
              }
            }),
          )
          .timeout(const Duration(seconds: 20));
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
    hudLoadingEffect(context, false);

    return serverResp;
  }

  // REQUEST TO LOGIN WITH BIOMETRICS
  // IF BIOMETRIC IS CORRECT, USE THE EMAIL & NAME TO GET TOKEN
  Future authenticateWithBiometrics(context, email, name) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    hudLoadingEffect(context, true);
    Map serverResp = {};
    var data = {
      'email': email,
      'userName': name,
    };
    var response = await http
        .post(
          Uri.parse(
              'http://192.168.43.50:8000/api/v1/main/api_authenticateWithBiometrics/'),
          // Uri.parse(
          //     'http://192.168.100.88:8000/api/v1/main/api_authenticateWithBiometrics/'),
          // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_authenticateWithBiometrics/'),
          body: jsonEncode(data),
          headers: {
            "Content-Type": "application/json",
          },
          encoding: Encoding.getByName("utf-8"),
        )
        .timeout(const Duration(seconds: 60));

    try {
      if (response.statusCode == 200) {
        // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
        hudLoadingEffect(context, false);
        var serverResponse = json.decode(response.body);
        serverResp = serverResponse;
      }
    } catch (error) {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      hudLoadingEffect(context, false);
      rethrow;
    }
    return serverResp;
  }

  // REQUEST TO AUTHENTICATE USER PIN
  Future processTransaction(
      context,
      token,
      email,
      name,
      pin,
      call,
      requestedAmt,
      mobileTransNo,
      providerChoice,
      subscriptionId,
      dataAmt,
      isNumSetAsDefault) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    hudLoadingEffect(context, true);
    Map serverResp = {};
    var data = {
      'email': email,
      'userName': name,
      'pin': pin,
      'call': call,
      'requestedAmt': double.parse(requestedAmt),
      'mobileTransNo': mobileTransNo,
      'providerChoice': providerChoice,
      'subscriptionId': subscriptionId,
      'dataAmt': dataAmt,
      'isNumSetAsDefault': isNumSetAsDefault,
    };
    var response = await http
        .post(
          Uri.parse(
              'http://192.168.43.50:8000/api/v1/main/api_processTransaction/'),
          // Uri.parse(
          //     'http://192.168.100.88:8000/api/v1/main/api_processTransaction/'),
          // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_processTransaction/'),
          body: jsonEncode(data),
          headers: {
            "Content-Type": "application/json",
          },
          encoding: Encoding.getByName("utf-8"),
        )
        .timeout(const Duration(seconds: 60));

    try {
      if (response.statusCode == 200) {
        // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
        hudLoadingEffect(context, false);
        var serverResponse = json.decode(response.body);
        serverResp = serverResponse;
      }
    } catch (error) {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      hudLoadingEffect(context, false);
      rethrow;
    }
    return serverResp;
  }

  // GET TRANSACTION
  Future transAcctHistory(context, String token) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    hudLoadingEffect(context, true);
    var serverResponse = {};
    var response = await http.post(
      Uri.parse(
          'http://192.168.43.50:8000/api/v1/main/api_acctTransactionLog/'),
      // Uri.parse('http://192.168.100.88:8000/api/v1/main/api_acctTransactionLog/'),
      // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_acctTransactionLog/'),
      // body: json.encode(),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      serverResponse = json.decode(response.body);
      if (serverResponse['isSuccess'] == true) {
        // isShowBal = serverResponse['userProfile']['isBalVisible'];
        // notifyListeners();
      }
    }
    // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
    hudLoadingEffect(context, false);
    return serverResponse;
  }

  // GET ACCOUNT STATEMENT
  Future getAcctStatement(context, String token, startDate, endDate) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    hudLoadingEffect(context, true);

    var data = {
      'startDate': formatDateWithDash(startDate),
      'endDate': formatDateWithDash(endDate),
    };
    var serverResponse = {};
    var response = await http.post(
      Uri.parse('http://192.168.43.50:8000/api/v1/main/api_acctStatement/'),
      // Uri.parse('http://192.168.100.88:8000/api/v1/main/api_acctStatement/'),
      // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_acctStatement/'),

      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      serverResponse = json.decode(response.body);
      if (serverResponse['isSuccess'] == true) {}
    }
    // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
    hudLoadingEffect(context, false);
    return serverResponse;
  }

  // MAKE PAYMENT (CUSTOMER CREDIT THEIR WALLET)
  Future creditCustomerWallet(context, Map record, token) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    hudLoadingEffect(context, true);

    var serverResponse = {};
    var response = await http.post(
      Uri.parse('http://192.168.43.50:8000/api/v1/main/api_creditCusWallet/'),
      // Uri.parse('http://192.168.100.88:8000/api/v1/main/api_creditCusWallet/'),
      // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_creditCusWallet/'),

      body: jsonEncode(record),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      serverResponse = json.decode(response.body);
      if (serverResponse['isSuccess'] == true) {}
    }
    // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
    hudLoadingEffect(context, false);
    return serverResponse;
  }

  // GET REFERRALS
  Future getReferrals(context, String token, email, val, call) async {
    // CALL THE DIALOG TO PREVENT USER FROM THE UI UNTIL DATA IS SAVED TO THE SERVER
    hudLoadingEffect(context, true);

    var data = {
      'email': email,
      'val': val,
      'call': call,
    };
    var serverResponse = {};
    var response = await http.post(
      Uri.parse('http://192.168.43.50:8000/api/v1/main/api_referrals/'),
      // Uri.parse('http://192.168.100.88:8000/api/v1/main/api_referrals/'),
      // Uri.parse('http://127.0.0.1:8000/api/v1/main/api_referrals/'),

      body: jsonEncode(data),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      serverResponse = json.decode(response.body);
      if (serverResponse['isSuccess'] == true) {}
    }
    // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
    hudLoadingEffect(context, false);
    return serverResponse;
  }
}

// =================== NUMBER KEYPAD =================

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;
  const KeyboardNumber({Key? key, required this.n, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: themeManager.currentTheme == ThemeMode.light
            ? Colors.blue.withOpacity(0.1)
            : ServiceProvider.whiteColorShade70,
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        splashColor: ServiceProvider.redWarningColor,
        highlightColor: themeManager.currentTheme == ThemeMode.light
            ? Colors.blue
            : ServiceProvider.blueTrackColor,
        padding: EdgeInsets.all(8.0),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
        height: 90.0,
        child: Text(
          "$n",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24 * MediaQuery.of(context).textScaleFactor,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// =================== DISABLE NUMBER KEYPAD==========

class DisableKeyboardNumber extends StatelessWidget {
  final int n;
  const DisableKeyboardNumber({Key? key, required this.n}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withOpacity(0.1),
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        disabledColor: Colors.grey.shade300,
        padding: EdgeInsets.all(8.0),
        onPressed: null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
        height: 90.0,
        child: Text(
          "$n",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24 * MediaQuery.of(context).textScaleFactor,
            color: Colors.black26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
