// import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:image/image.dart' as Img;
// import 'package:path_provider/path_provider.dart';

class AccountProfile extends StatefulWidget {
  const AccountProfile({Key? key}) : super(key: key);

  @override
  _AccountProfileState createState() => _AccountProfileState();
}

class _AccountProfileState extends State<AccountProfile> {
  @override
  void initState() {
    initalCall();
    // _getDataUser();
    super.initState();
  }

  File? imageFile;
  var profilePix = '';
  var name, email, token, mobile;
  // Image? imageFromPreference;
  // Map profileData = {};

  // _getDataUser() async {
  //   Map _userProfile = {};
  //   _userProfile = await serviceProvider.getUserInfo();

  //   if (_userProfile['token'] == '' || _userProfile['token'] == null) {
  //     serviceProvider.logOutUser();
  //     serviceProvider.authenticateUser(
  //         context, _userProfile['name'], _userProfile['email']);
  //     profileData = _userProfile;
  //   } else {
  //     Navigator.of(context).pushNamedAndRemoveUntil(
  //         RouteManager.login, (Route<dynamic> route) => false);
  //   }
  // }

  initalCall() async {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    Map userRec = await serviceProvider.getUserProfile(context);
    if (userRec.isNotEmpty) {
      setState(() {
        token = userRec['token'];
        name = userRec['name'];
        email = userRec['email'];
        mobile = userRec['mobile'];
      });
      // IF THERE IS NO IMAGE FROM THE SHARED PREFERENCE,
      // CHECK THE DATABASE.
      // if (imageFromPreference == null) {
      //   // getProfilePic();
      // }
    }
  }

  // getProfilePic() async {
  //   var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
  //   var serverResponse = await serviceProvider.acctProfile(token);
  //   if (serverResponse['isSuccess'] == false) {
  //     if (serverResponse['errorMsg'] != '') {
  //       serviceProvider.popWarningErrorMsg(
  //           context, 'Error', serverResponse['errorMsg'].toString());
  //     }
  //   } else {
  //     setState(() {
  //       serviceProvider.isProfilePix = true;
  //       profilePix = serverResponse['image'];
  //     });
  //   }
  // }

  // USED TO DELETE PROFILE PICTURE.
  // THE LOADING EFFECT DISPLAY ERROR WHILE POPPING, WHILE TO TOAST MESSAGE
  // ALSO DISPLAY AN ERROR. THIS IS WHY IT'S NOT IN THE SERVICE PROVIDER FILE.
  Future setUpdateAcct(context, String token, Map data) async {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    var serverResponse;
    // CALL THE DIALOG TO PREVENT USER PERFORM OPERATION ON THE UI
    // serviceProvider.hudLoadingEffect(context, true);

    // Map data = {'call': call, '_isShowAcctBal': isShowAcctBal};

    var response = await http
        .post(
          Uri.parse(
              '${dotenv.env['URL_ENDPOINT']}/api/v1/main/api_set_updateAcct/'),
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
      // serviceProvider.hudLoadingEffect(context, false);

      serverResponse = json.decode(response.body);
      serviceProvider.isShowBal = serverResponse['isBalVisible'];
    } else {
      // CALL THE DIALOG TO ALLOW USER PERFORM OPERATION ON THE UI
      // serviceProvider.hudLoadingEffect(context, false);

      serviceProvider.showErrorToast(context, 'Fail to update');
    }
    // notifyListeners();
    return serverResponse;
  }

  FutureOr _refreshData() async {
    await initalCall();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var serviceProvider = Provider.of<ServiceProvider>(context);
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;

    // imageFromPreference = serviceProvider.loadImageFromPreferences();
    // if (serviceProvider.name != '') {}
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          bool isResponse = await serviceProvider.popWarningConfirmActionYesNo(
              context,
              'Warning',
              'Do you want to exit the app?',
              Colors.white60);
          if (isResponse == true) {
            SystemNavigator.pop();
          }
          return Future.value(false);
        },
        child: Container(
          // color: ServiceProvider.backGroundColor,
          height: screenH,
          width: screenW,
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Column(
            children: [
              Text(
                'Profile Settings',
                style: ServiceProvider.pageNameFont,
              ),
              SizedBox(
                height: screenH * 0.04,
              ),
              Text(
                'Hello $name, personalize your account content',
                style: ServiceProvider.greetUserFont1,
              ),
              _avatarIcon(),
              SizedBox(
                height: screenH * 0.02,
              ),
              Divider(
                color: themeManager.currentTheme == ThemeMode.light
                    ? Colors.black38
                    : Colors.white38,
                height: 0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.editProfile, arguments: {
                          'name': name,
                          'email': email,
                          'token': token,
                          'mobile': mobile,
                        }).then((_) {
                          _refreshData();
                        });
                      },
                      child: profileListTileStructure(
                        Icons.person,
                        themeManager.currentTheme == ThemeMode.light
                            ? Colors.black
                            : ServiceProvider.whiteColorShade70,
                        'Profile',
                        themeManager.currentTheme == ThemeMode.light
                            ? Colors.black
                            : ServiceProvider.whiteColorShade70,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            RouteManager.referralCode,
                            arguments: {'name': name});
                      },
                      child: profileListTileStructure(
                        Icons.group_add,
                        themeManager.currentTheme == ThemeMode.light
                            ? Colors.black
                            : ServiceProvider.whiteColorShade70,
                        'Referral',
                        themeManager.currentTheme == ThemeMode.light
                            ? Colors.black
                            : ServiceProvider.whiteColorShade70,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.helpContact, arguments: {
                          'name': name,
                          'email': email,
                          'token': token,
                          'mobile': mobile,
                        });
                      },
                      child: profileListTileStructure(
                        Icons.help,
                        themeManager.currentTheme == ThemeMode.light
                            ? Colors.black
                            : ServiceProvider.whiteColorShade70,
                        'Customer Service',
                        themeManager.currentTheme == ThemeMode.light
                            ? Colors.black
                            : ServiceProvider.whiteColorShade70,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.settings, arguments: {
                          'name': name,
                          'email': email,
                          'token': token,
                        }).then((_) {
                          setState(() {});
                        });
                      },
                      child: profileListTileStructure(
                        Icons.settings_applications,
                        themeManager.currentTheme == ThemeMode.light
                            ? Colors.black
                            : ServiceProvider.whiteColorShade70,
                        'Settings',
                        themeManager.currentTheme == ThemeMode.light
                            ? Colors.black
                            : ServiceProvider.whiteColorShade70,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.userAgreement);
                      },
                      child: profileListTileStructure(
                        Icons.document_scanner,
                        themeManager.currentTheme == ThemeMode.light
                            ? Colors.black
                            : ServiceProvider.whiteColorShade70,
                        'Legal',
                        themeManager.currentTheme == ThemeMode.light
                            ? Colors.black
                            : ServiceProvider.whiteColorShade70,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        // ======== DIALOG POP UP CONTEXT FOR SIGN OUT ===============
                        bool isResponse =
                            await serviceProvider.popWarningConfirmActionYesNo(
                                context,
                                'Warning',
                                'Do you want to log out?',
                                Colors.white60);
                        if (isResponse) {
                          var response =
                              await serviceProvider.signOutAcct(token);
                          if (response['isSuccess']) {
                            await serviceProvider.deleteDefaultNumFrmPref();
                            bool isSignOut = await serviceProvider.signOut();
                            if (isSignOut) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteManager.login,
                                (Route<dynamic> route) => false,
                                arguments: {'isLastStack': true},
                              );
                            }
                          }
                          // switch (response['isSuccess']) {

                          // case true:
                          //   print('LOGGED OUT FROM SERVER');
                          //   bool isSignOut =
                          //       await serviceProvider.signOut();
                          //   if (isSignOut) {
                          //     Navigator.of(context).pushNamedAndRemoveUntil(
                          //       RouteManager.login,
                          //       (Route<dynamic> route) => false,
                          //     );
                          //   }
                          //   break;
                          // case false:
                          //   print('NOT LOG OUT');
                          //   break;

                          // default:
                          //   print('ERROR MESSAGE');
                          // }
                        }
                      },
                      child: profileListTileStructure(
                        Icons.logout_rounded,
                        ServiceProvider.redWarningColor,
                        'Sign Out',
                        ServiceProvider.redWarningColor,
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    try {
      final image = await ImagePicker().pickImage(source: source);
      bool isCycleState = await serviceProvider.getLifeCycleStateFrmPref();
      serviceProvider.isLifeCycleState =
          isCycleState; // THIS IS USED ON THE LIFE-CYCLE-STATE
      if (image == null) return;
      final imageTemperary = File(image.path);
      serviceProvider.isLifeCycleState =
          isCycleState; // THIS IS USED ON THE LIFE-CYCLE-STATE
      var response = await serviceProvider.uploadProfilePix(
          context, token, imageTemperary);
      if (response == '{"isSuccess": true}') {
        // serviceProvider.isProfilePix = true;
        setState(() {
          imageFile = imageTemperary;
          ServiceProvider.temporaryLocalImg = Image.file(imageTemperary);
          ServiceProvider.profileImgFrmServer = '';
        });

        // bool isImgPrefSave = await serviceProvider.saveImageToPreferences(
        //     serviceProvider.base64String(imageFile!.readAsBytesSync()));
        // if (isImgPrefSave) {
        //   imageFromPreference =
        //       await serviceProvider.loadImageFromPreferences();
        // }
        serviceProvider.showSuccessToast(context, 'Profile photo updated');
      } else {
        serviceProvider.showErrorToast(context, 'Error uploading image!');
      }
    } on PlatformException catch (error) {
      // rethrow;
    }
  }

  // saveImgToDisk(String path, Directory directory) {
  //   try {
  //     File tempFile = File(path);
  //     Img.Image? image = Img.decodeImage(tempFile.readAsBytesSync());
  //     Img.Image? mImage = Img.copyResize(image!, width: 512);
  //     String imgType = path.split('.').last;
  //     String mPath =
  //         '${directory.path.toString()}/image_${DateTime.now()}.$imgType';
  //     if (imgType == 'jpg' || imgType == 'jpeg') {
  //       tempFile.writeAsBytesSync(Img.encodeJpg(mImage));
  //     } else {
  //       tempFile.writeAsBytesSync(Img.encodePng(mImage));
  //     }
  //     return tempFile;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  _avatarIcon() {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      duration: const Duration(seconds: 2),
      curve: Curves.bounceOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            0.0,
            -value * 150,
          ),
          child: child,
        );
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            '$email',
            style: ServiceProvider.pageInfoWithDarkGreyFont,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          width: 70,
          margin: const EdgeInsets.only(left: 10.0),
          child: InkWell(
            onTap: () {
              Map data = {
                'isShowAcctBal': false,
                'call': 'removeProfilePhoto',
              };
              showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30.0)),
                  ),
                  backgroundColor: themeManager.currentTheme == ThemeMode.light
                      ? ServiceProvider.backGroundColor
                      : ServiceProvider.darkNavyBGColor,
                  context: context,
                  builder: (builder) {
                    return StatefulBuilder(builder: (context, setstate) {
                      return SizedBox(
                        height: 230,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ServiceProvider.bottomSheetBarHeader,
                            const SizedBox(height: 30),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(''),
                                  Text(
                                    'Profile Photo',
                                    style: ServiceProvider.pageNameFont,
                                  ),
                                  // if (serviceProvider.isProfilePix &&
                                  //     imageFile == null &&
                                  //     profilePix != 'http://192.168.43.50:8000')
                                  if (
                                  // serviceProvider.isUpdateProfilePix ||
                                  ServiceProvider.temporaryLocalImg != null ||
                                      ServiceProvider.profileImgFrmServer !=
                                              '' &&
                                          ServiceProvider.profileImgFrmServer !=
                                              dotenv.env['URL_ENDPOINT'])
                                    IconButton(
                                        onPressed: () async {
                                          bool isResponse = await serviceProvider
                                              .popWarningConfirmActionYesNo(
                                                  context,
                                                  'Warning',
                                                  'You want to remove profile photo?',
                                                  Colors.white60);

                                          Navigator.of(context).pop();
                                          setState(() {});
                                          if (isResponse) {
                                            var response = await setUpdateAcct(
                                              context,
                                              token,
                                              data,
                                            );

                                            if (response['isSuccess'] == true) {
                                              print('IMAGE DELETED FROM DB');
                                              // await serviceProvider
                                              //     .delProfilePixFrmPreference();
                                              setState(() {
                                                imageFile = null;
                                                ServiceProvider
                                                    .temporaryLocalImg = null;
                                                ServiceProvider
                                                    .profileImgFrmServer = '';
                                              });

                                              // serviceProvider.showToast(context,
                                              //     'Profile picture updated');
                                            }
                                            print('REMOVE PHOTO');
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.grey,
                                          size: 30,
                                        ))
                                  else
                                    const Text('')
                                ]),
                            Divider(
                              color:
                                  themeManager.currentTheme == ThemeMode.light
                                      ? Colors.black38
                                      : Colors.white38,
                              height: 0,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    serviceProvider.isLifeCycleState =
                                        false; // THIS IS USED ON THE LIFE-CYCLE-STATE)
                                    Navigator.of(context).pop();
                                    pickImage(ImageSource.camera);
                                  },
                                  child: structureGalleryCam(
                                      Icons.linked_camera, 'Camera'),
                                ),
                                InkWell(
                                  onTap: () async {
                                    serviceProvider.isLifeCycleState =
                                        false; // THIS IS USED ON THE LIFE-CYCLE-STATE)
                                    Navigator.of(context).pop();
                                    pickImage(ImageSource.gallery);
                                  },
                                  child: structureGalleryCam(
                                      Icons.picture_in_picture, 'Gallery'),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    });
                  });
            },
            child: Stack(
              children: [
                if (imageFile != null)
                  CircleAvatar(
                    radius: 40,
                    // backgroundColor: ServiceProvider.lightgray2,
                    backgroundImage: FileImage(imageFile!),
                  )
                else if (ServiceProvider.profileImgFrmServer != '' &&
                    ServiceProvider.profileImgFrmServer !=
                        dotenv.env['URL_ENDPOINT'])
                  CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          NetworkImage(ServiceProvider.profileImgFrmServer))
                else if (ServiceProvider.temporaryLocalImg != null)
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: (ServiceProvider.temporaryLocalImg!.image),
                  )
                else
                  CircleAvatar(
                      radius: 40,
                      backgroundColor: ServiceProvider.lightgray2,
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.grey.shade600,
                      )),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: ServiceProvider.innerBlueBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.photo_camera,
                        color: ServiceProvider.backGroundColor,
                      )),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget profileListTileStructure(
    IconData icon,
    Color iconColor,
    String listName,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      decoration: BoxDecoration(
          color: themeManager.currentTheme == ThemeMode.light
              ? Colors.black.withOpacity(0.05)
              : ServiceProvider.blueTrackColor,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: 0.0),
            curve: Curves.bounceOut,
            duration: const Duration(seconds: 2),
            child: ListTile(
              leading: Icon(icon, color: iconColor),
              title: Text(
                listName,
                // style: Theme.of(context).textTheme.subtitle2,
                style: GoogleFonts.sora().copyWith(color: color),
              ),
            ),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(value * 150, 0.0),
                child: child,
              );
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.84,
            child: Divider(
              color: themeManager.currentTheme == ThemeMode.light
                  ? Colors.black
                  : Colors.white24,
              thickness: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget structureGalleryCam(IconData icon, String name) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 70,
            color: ServiceProvider.innerBlueBackgroundColor,
          ),
          Text(
            name,
            style: ServiceProvider.contentFont,
          )
        ],
      ),
    );
  }
}
