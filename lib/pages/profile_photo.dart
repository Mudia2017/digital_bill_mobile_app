import 'dart:io';

import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePhoto extends StatefulWidget {
  final String name, token, email, mobile;
  const ProfilePhoto({
    Key? key,
    required this.name,
    required this.token,
    required this.email,
    required this.mobile,
  }) : super(key: key);

  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  File? imageFile;
  var serviceProvider = ServiceProvider();
  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: WillPopScope(
          onWillPop: () async {
            bool isResponse =
                await serviceProvider.popWarningConfirmActionYesNo(context,
                    'Warning', 'Do you want to exit the app?', Colors.white60);
            if (isResponse == true) {
              SystemNavigator.pop();
            }

            return Future.value(false);
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(30, 35, 30, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Text(
                      'Profile Photo',
                      style: ServiceProvider.pageNameFont,
                    ),
                    Container(),
                  ],
                ),
              ),
              SizedBox(
                height: screenH * 0.08,
              ),
              if (imageFile != null)
                Stack(
                  children: [
                    CircleAvatar(
                      radius: screenW * 0.35,
                      backgroundImage: FileImage(imageFile!),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 0,
                      child: InkWell(
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: ServiceProvider.innerBlueBackgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.task_alt_rounded,
                            size: 60,
                            color: ServiceProvider.backGroundColor,
                          ),
                        ),
                        splashColor: Colors.black54,
                        borderRadius: BorderRadius.circular(25),
                        onTap: () async {
                          // UPLOAD PROFILE IMAGE TO SERVER.
                          var serverRes =
                              await serviceProvider.uploadProfilePix(
                                  context, widget.token, imageFile!);
                          if (serverRes == '{"isSuccess": true}') {
                            setState(() {
                              ServiceProvider.temporaryLocalImg =
                                  Image.file(imageFile!);
                              ServiceProvider.profileImgFrmServer = '';
                            });
                            Navigator.of(context).pushReplacementNamed(
                                RouteManager.homePage,
                                arguments: {
                                  'token': widget.token,
                                  'name': widget.name,
                                  'email': widget.email,
                                  'mobile': widget.mobile,
                                  'acctBal': '0',
                                });
                          } else {
                            serviceProvider.showErrorToast(
                                context, 'Error uploading image!');
                          }
                        },
                      ),
                    )
                  ],
                )
              else
                Container(
                  child: CircleAvatar(
                    radius: screenW * 0.35,
                    backgroundColor:
                        themeManager.currentTheme == ThemeMode.light
                            ? Colors.black26
                            : ServiceProvider.blueTrackColor,
                    child: IconButton(
                      icon: const Icon(Icons.add_a_photo_outlined),
                      color: ServiceProvider.backGroundColor,
                      iconSize: screenW * 0.3,
                      onPressed: () {
                        bottomSheetPhotoOptions();
                      },
                    ),
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Hi ${widget.name} edit your profile photo',
                  style: themeManager.currentTheme == ThemeMode.light
                      ? GoogleFonts.sarabun(
                          fontWeight: FontWeight.w200,
                          fontStyle: FontStyle.italic,
                        ).copyWith(
                          color: Colors.black.withOpacity(1),
                          fontSize: 23,
                        )
                      : ServiceProvider.pageInfoWithLightGreyFont,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: screenW * 0.35,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                              RouteManager.homePage,
                              arguments: {
                                'token': widget.token,
                                'name': widget.name,
                                'email': widget.email,
                                'mobile': widget.mobile,
                                'acctBal': '0',
                              });
                        },
                        child: Text(
                          'Skip & Continue',
                          style: TextStyle(
                              color:
                                  themeManager.currentTheme == ThemeMode.light
                                      ? Colors.grey
                                      : Colors.white70),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey)),
                      ),
                    ),
                    SizedBox(
                      width: screenW * 0.35,
                      child: MaterialButton(
                        disabledColor: Colors.grey.shade300,
                        child: const Text(
                          'Add Photo',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        color: ServiceProvider.innerBlueBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        onPressed: () {
                          bottomSheetPhotoOptions();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bottomSheetPhotoOptions() {
    double screenH = MediaQuery.of(context).size.height;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        backgroundColor: themeManager.currentTheme == ThemeMode.light
            ? ServiceProvider.backGroundColor
            : ServiceProvider.darkNavyBGColor,
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context, setstate) {
            return SizedBox(
                height: screenH * 0.28,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    ServiceProvider.bottomSheetBarHeader,
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Profile Photo',
                          style: ServiceProvider.pageNameFont,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Divider(
                      color: themeManager.currentTheme == ThemeMode.light
                          ? Colors.black38
                          : Colors.white38,
                      height: 0,
                    ),
                    const SizedBox(
                      height: 8.0,
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
                ));
          });
        });
  }

  Future pickImage(ImageSource source) async {
    // var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    try {
      final image = await ImagePicker().pickImage(source: source);
      // bool isCycleState = await serviceProvider.getLifeCycleStateFrmPref();
      // serviceProvider.isLifeCycleState =
      //     isCycleState; // THIS IS USED ON THE LIFE-CYCLE-STATE
      if (image == null) return;
      final imageTemperary = File(image.path);
      // serviceProvider.isLifeCycleState =
      //     isCycleState; // THIS IS USED ON THE LIFE-CYCLE-STATE

      setState(() {
        imageFile = imageTemperary;
      });
    } on PlatformException catch (error) {
      // rethrow;
    }
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
