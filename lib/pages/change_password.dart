import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  final name, email, token;
  ChangePassword({
    Key? key,
    required this.name,
    required this.email,
    required this.token,
  }) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordController = TextEditingController();

  TextEditingController password1Controller = TextEditingController();

  TextEditingController password2Controller = TextEditingController();

  bool hideOldPwd = true;

  bool hidePassword = true;

  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    var serviceProvider = Provider.of<ServiceProvider>(context);
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
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
                    padding: const EdgeInsets.fromLTRB(30, 0, 13, 0),
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
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            'Change Password',
                            style: ServiceProvider.pageNameFont,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            children: [
                              if (ServiceProvider.profileImgFrmServer != '' &&
                                  ServiceProvider.profileImgFrmServer !=
                                      dotenv.env['URL_ENDPOINT'])
                                serviceProvider.displayProfileImg(context)
                              // CircleAvatar(
                              //     radius: 30,
                              //     backgroundImage: NetworkImage(
                              //         ServiceProvider.profileImgFrmServer))
                              else if (ServiceProvider.temporaryLocalImg !=
                                  null)
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: (ServiceProvider
                                      .temporaryLocalImg!.image),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
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
                              color:
                                  themeManager.currentTheme == ThemeMode.light
                                      ? Colors.black87
                                      : Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenH * 0.019,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "${widget.name}, you are about to change your password, if it's successful, will be required to access your account the next time you want to login with your email.",
                      style: ServiceProvider.pageInfoWithDarkGreyFont,
                    ),
                  ),
                  SizedBox(
                    height: screenH * 0.049,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenH * 0.01,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: oldPasswordController,
                              style: Theme.of(context).textTheme.subtitle2,
                              decoration: InputDecoration(
                                labelText: 'Old Password',
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      hideOldPwd = !hideOldPwd;
                                    });
                                  },
                                  child: Icon(
                                      hideOldPwd
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: themeManager.currentTheme ==
                                              ThemeMode.light
                                          ? Colors.black
                                          : ServiceProvider.whiteColorShade70),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Old Password is required';
                                }
                                return null;
                              },
                              obscureText: hideOldPwd,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    oldPasswordController.text;
                                  });
                                } else {
                                  setState(() {
                                    oldPasswordController.text;
                                  });
                                }
                              },
                            ),
                            SizedBox(
                              height: screenH * 0.04,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: password1Controller,
                              style: Theme.of(context).textTheme.subtitle2,
                              decoration: InputDecoration(
                                labelText: 'New Password',
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
                                      color: themeManager.currentTheme ==
                                              ThemeMode.light
                                          ? Colors.black
                                          : ServiceProvider.whiteColorShade70),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'New Password is required';
                                }
                                return null;
                              },
                              obscureText: hidePassword,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    password1Controller.text;
                                  });
                                } else {
                                  setState(() {
                                    password1Controller.text;
                                  });
                                }
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: password2Controller,
                              style: Theme.of(context).textTheme.subtitle2,
                              decoration: InputDecoration(
                                labelText: 'Re-enter New Password',
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
                                      color: themeManager.currentTheme ==
                                              ThemeMode.light
                                          ? Colors.black
                                          : ServiceProvider.whiteColorShade70),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
                              obscureText: _hidePassword,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    password2Controller.text;
                                  });
                                } else {
                                  setState(() {
                                    password2Controller.text;
                                  });
                                }
                              },
                            ),
                            SizedBox(
                              height: screenH * 0.04,
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
                                  color:
                                      ServiceProvider.innerBlueBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  onPressed: (oldPasswordController
                                              .text.isEmpty ||
                                          password1Controller.text.isEmpty ||
                                          password2Controller.text.isEmpty)
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            if (password1Controller.text !=
                                                password2Controller.text) {
                                              serviceProvider.popWarningErrorMsg(
                                                  context,
                                                  'Warning',
                                                  'The two password does not match!');
                                            } else {
                                              var serverResp =
                                                  await serviceProvider
                                                      .changePassword(
                                                          context,
                                                          widget.token,
                                                          widget.email,
                                                          widget.name,
                                                          oldPasswordController
                                                              .text,
                                                          password1Controller
                                                              .text,
                                                          password2Controller
                                                              .text);
                                              if (serverResp['isSuccess']) {
                                                oldPasswordController.clear();
                                                password1Controller.clear();
                                                password2Controller.clear();

                                                bool isOkay = await serviceProvider
                                                    .popDialogMsg(
                                                        context,
                                                        'Info',
                                                        'You have successfully change your password.');
                                                if (isOkay) {
                                                  Navigator.of(context).pop();
                                                }
                                              } else {
                                                if (serverResp['errorMsg'] !=
                                                    '') {
                                                  serviceProvider
                                                      .popWarningErrorMsg(
                                                          context,
                                                          'Error',
                                                          serverResp['errorMsg']
                                                              .toString());
                                                } else {
                                                  serviceProvider
                                                      .popWarningErrorMsg(
                                                          context,
                                                          'Error',
                                                          'Something went wrong!!!');
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
