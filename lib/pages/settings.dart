import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:digital_mobile_bill/widget/authenticate_pin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountSettings extends StatefulWidget {
  final String name, token, email;
  const AccountSettings(
      {Key? key, required this.name, required this.token, required this.email})
      : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  void initState() {
    super.initState();
    themeManager.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    initialCall();
  }

  bool value = false;
  Map serverRes = {};
  bool isBiometric = false;
  bool _isAuthorizeTrans = true;

  initialCall() async {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    // I LET THIS BECAUSE I NOTICE IT CONTROL BIOMETRIC AUTHENTICATION.
    // I NEED TO FIND OUT HOW AND WHY
    serverRes = await serviceProvider.acctProfile(widget.token);

    // GET THE STATE OF BIOMETRIC IF IT'S SAVED TO SHARED PREF
    bool _isBiometric = await serviceProvider.getBiometric() as bool;
    if (_isBiometric != null) {
      isBiometric = _isBiometric;
    }
  }

  toggleAuthorizeTrans() {
    Map data1 = {
      'isAuthorizeTrans': _isAuthorizeTrans,
      'call': 'authorizeTransactions',
    };
    return data1;
  }

  @override
  Widget build(BuildContext context) {
    var serviceProvider = Provider.of<ServiceProvider>(context);
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    TextTheme _textTheme = Theme.of(context).textTheme;
    Map data = {
      'isShowAcctBal': serviceProvider.isShowBal,
      'call': 'toggleAcctBal',
    };
    Map data1 = {
      'isLifeCycleState': serviceProvider.isLifeCycleState,
      'call': 'lifeCycleState',
    };

    return Scaffold(
      body: Container(
        // color: ServiceProvider.backGroundColor,
        // color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            SizedBox(
              height: screenH * 0.023,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 35, 30, 15),
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
                    'Settings',
                    style: ServiceProvider.pageNameFont,
                  ),
                  Container(),
                ],
              ),
            ),

            // =====================
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: screenH * 0.009,
                    ),
                    InkWell(
                      onTap: () {},
                      child: listTileLayout(
                        Icons.edit_notifications_sharp,
                        'Notification Setting',
                        themeManager.currentTheme == ThemeMode.light
                            ? Colors.black
                            : ServiceProvider.whiteColorShade70,
                        Icons.chevron_right,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      decoration: BoxDecoration(
                          color: themeManager.currentTheme == ThemeMode.light
                              ? Colors.black.withOpacity(0.05)
                              : ServiceProvider.blueTrackColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 1.0, end: 0.0),
                            curve: Curves.easeInOut,
                            duration: const Duration(seconds: 1),
                            child: ListTile(
                              leading: Icon(
                                Icons.light_mode,
                                color:
                                    themeManager.currentTheme == ThemeMode.light
                                        ? Colors.black
                                        : ServiceProvider.whiteColorShade70,
                              ),
                              title: Text(
                                'Dark Theme',
                                style: GoogleFonts.sora().copyWith(
                                    color: themeManager.currentTheme ==
                                            ThemeMode.light
                                        ? Colors.black
                                        : Colors.white70),
                              ),
                              trailing: Switch(
                                value:
                                    themeManager.currentTheme == ThemeMode.dark,
                                onChanged: (val) {
                                  setState(() {
                                    themeManager.toggleTheme();
                                  });
                                },
                              ),
                            ),
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(value * 150, 0.0),
                                child: child,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(12, 20, 12, 8),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              border: Border.all(
                                color: ServiceProvider.redWarningColor,
                                width: 0.7,
                              )),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
                                decoration: BoxDecoration(
                                    color: themeManager.currentTheme ==
                                            ThemeMode.light
                                        ? Colors.black.withOpacity(0.05)
                                        : ServiceProvider.blueTrackColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 1.0, end: 0.0),
                                      curve: Curves.easeInOut,
                                      duration: const Duration(seconds: 1),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.wallet_travel_outlined,
                                          color: themeManager.currentTheme ==
                                                  ThemeMode.light
                                              ? Colors.black
                                              : ServiceProvider
                                                  .whiteColorShade70,
                                        ),
                                        title: Text(
                                          'Show Wallet Balance',
                                          style: GoogleFonts.sora().copyWith(
                                              color:
                                                  themeManager.currentTheme ==
                                                          ThemeMode.light
                                                      ? Colors.black
                                                      : ServiceProvider
                                                          .whiteColorShade70),
                                        ),
                                        subtitle: Text(
                                          'Display account balance',
                                          style: GoogleFonts.sora().copyWith(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        trailing: Switch(
                                          inactiveTrackColor: Colors.grey,
                                          value: serviceProvider.isShowBal,
                                          onChanged: (val) async {
                                            var response = await serviceProvider
                                                .setUpdateAcct(
                                              context,
                                              widget.token,
                                              data,
                                              // serviceProvider.isShowBal,
                                              // 'toggleAcctBal',
                                            );
                                            if (response['isSuccess'] == true) {
                                              serviceProvider.isShowBal =
                                                  response['isBalVisible'];
                                              setState(() {
                                                serviceProvider.isShowBal = val;
                                              });

                                              serviceProvider.showSuccessToast(
                                                  context, 'Update successful');
                                            } else {
                                              serviceProvider.showErrorToast(
                                                  context, 'Failed');
                                            }
                                          },
                                        ),
                                      ),
                                      builder: (context, value, child) {
                                        return Transform.translate(
                                          offset: Offset(value * 150, 0.0),
                                          child: child,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     Navigator.of(context).pushNamed(
                              //         RouteManager.authenticatePin,
                              //         arguments: {
                              //           'name': widget.name,
                              //           'token': widget.token,
                              //           'email': widget.email,
                              //           'pageTitle': 'Pin',
                              //           'pageInfo1':
                              //               'Authentication is required to register your biometrics',
                              //         });
                              //   },
                              //   child: listTileLayout(
                              //     Icons.security_sharp,
                              //     'Biometrics Authentication',
                              //     Colors.black,
                              //     Icons.chevron_right,
                              //   ),
                              // ),

                              Container(
                                margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
                                decoration: BoxDecoration(
                                    color: themeManager.currentTheme ==
                                            ThemeMode.light
                                        ? Colors.black.withOpacity(0.05)
                                        : ServiceProvider.blueTrackColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 1.0, end: 0.0),
                                      curve: Curves.easeInOut,
                                      duration: const Duration(seconds: 1),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.screen_lock_portrait_sharp,
                                          color: themeManager.currentTheme ==
                                                  ThemeMode.light
                                              ? Colors.black
                                              : ServiceProvider
                                                  .whiteColorShade70,
                                        ),
                                        title: Text(
                                          'Lock Inactive Mode',
                                          style: GoogleFonts.sora().copyWith(
                                            color: themeManager.currentTheme ==
                                                    ThemeMode.light
                                                ? Colors.black
                                                : ServiceProvider
                                                    .whiteColorShade70,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Lock when the app is in an inactive state',
                                          style: GoogleFonts.sora().copyWith(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        trailing: Switch(
                                          inactiveTrackColor: Colors.grey,
                                          value:
                                              serviceProvider.isLifeCycleState,
                                          onChanged: (val) async {
                                            var response = await serviceProvider
                                                .setUpdateAcct(
                                              context,
                                              widget.token,
                                              data1,
                                            );
                                            if (response['isSuccess'] == true) {
                                              serviceProvider.isLifeCycleState =
                                                  response['isLifeCycleState'];
                                              await serviceProvider
                                                  .isSetLifeCycleToPref(
                                                      serviceProvider
                                                          .isLifeCycleState);
                                              setState(() {
                                                serviceProvider
                                                    .isLifeCycleState = val;
                                              });

                                              serviceProvider.showSuccessToast(
                                                  context, 'Update successful');
                                            } else {
                                              serviceProvider.showErrorToast(
                                                  context, 'Failed');
                                            }

                                            // var isBiomet = await serviceProvider
                                            //     .isBiometric(val);
                                            // if (isBiomet) {
                                            // setState(() {
                                            //   serviceProvider.isLifeCycleState = val;
                                            // });
                                            // }
                                          },
                                        ),
                                      ),
                                      builder: (context, value, child) {
                                        return Transform.translate(
                                          offset: Offset(value * 150, 0.0),
                                          child: child,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
                                decoration: BoxDecoration(
                                    color: themeManager.currentTheme ==
                                            ThemeMode.light
                                        ? Colors.black.withOpacity(0.05)
                                        : ServiceProvider.blueTrackColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 1.0, end: 0.0),
                                      curve: Curves.easeInOut,
                                      duration: const Duration(seconds: 1),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.security_sharp,
                                          color: themeManager.currentTheme ==
                                                  ThemeMode.light
                                              ? Colors.black
                                              : ServiceProvider
                                                  .whiteColorShade70,
                                        ),
                                        title: Text(
                                          'Biometric Authentication',
                                          style: GoogleFonts.sora().copyWith(
                                            color: themeManager.currentTheme ==
                                                    ThemeMode.light
                                                ? Colors.black
                                                : ServiceProvider
                                                    .whiteColorShade70,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Use finger or facial to log in',
                                          style: GoogleFonts.sora().copyWith(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        trailing: Switch(
                                          inactiveTrackColor: Colors.grey,
                                          value: isBiometric,
                                          onChanged: (val) async {
                                            var isBiomet = await serviceProvider
                                                .isBiometric(val);
                                            if (isBiomet) {
                                              setState(() {
                                                isBiometric = val;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      builder: (context, value, child) {
                                        return Transform.translate(
                                          offset: Offset(value * 150, 0.0),
                                          child: child,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                decoration: BoxDecoration(
                                    color: themeManager.currentTheme ==
                                            ThemeMode.light
                                        ? Colors.black.withOpacity(0.05)
                                        : ServiceProvider.blueTrackColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 1.0, end: 0.0),
                                      curve: Curves.easeInOut,
                                      duration: const Duration(seconds: 1),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.admin_panel_settings,
                                          color: themeManager.currentTheme ==
                                                  ThemeMode.light
                                              ? Colors.black
                                              : ServiceProvider
                                                  .whiteColorShade70,
                                        ),
                                        title: Text(
                                          'Authorize Transaction',
                                          // style: _textTheme.headline6,
                                          style: GoogleFonts.sora().copyWith(
                                            color: themeManager.currentTheme ==
                                                    ThemeMode.light
                                                ? Colors.black
                                                : ServiceProvider
                                                    .whiteColorShade70,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Pin will be required to complete transaction',
                                          // style: _textTheme.subtitle1,
                                          style: GoogleFonts.sora().copyWith(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        trailing: Switch(
                                          inactiveTrackColor: Colors.grey,
                                          value:
                                              ServiceProvider.isAuthorizeTrans,
                                          onChanged: (val) async {
                                            _isAuthorizeTrans = val;

                                            var response = await serviceProvider
                                                .setUpdateAcct(
                                              context,
                                              widget.token,
                                              toggleAuthorizeTrans(),
                                            );
                                            if (response['isSuccess'] == true) {
                                              setState(() {
                                                ServiceProvider
                                                    .isAuthorizeTrans = val;
                                              });
                                              serviceProvider.showSuccessToast(
                                                  context, 'Update successful');
                                            } else {
                                              serviceProvider.showErrorToast(
                                                  context, 'Failed');
                                            }
                                          },
                                        ),
                                      ),
                                      builder: (context, value, child) {
                                        return Transform.translate(
                                          offset: Offset(value * 150, 0.0),
                                          child: child,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      RouteManager.changePin,
                                      arguments: {
                                        'name': widget.name,
                                        'token': widget.token,
                                        'email': widget.email,
                                      });
                                },
                                child: listTileLayout(
                                  Icons.lock,
                                  'Change Pin',
                                  ServiceProvider.redWarningColor,
                                  Icons.chevron_right,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      RouteManager.changePassword,
                                      arguments: {
                                        'name': widget.name,
                                        'token': widget.token,
                                        'email': widget.email,
                                      });
                                },
                                child: listTileLayout(
                                  Icons.vpn_key_sharp,
                                  'Change Password',
                                  ServiceProvider.redWarningColor,
                                  Icons.chevron_right_outlined,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  bool isResponse = await serviceProvider
                                      .popWarningConfirmActionYesNo(
                                    context,
                                    'Warning!',
                                    'You are about to delete your account. All transactions related to this account will be lost. This action is irreversiable. Do you want to continue?',
                                    ServiceProvider.redWarningColor,
                                  );
                                  if (isResponse == true) {
                                    // DELETE ACCOUNT
                                    Navigator.of(context).pushNamed(
                                        RouteManager.deleteAcct,
                                        arguments: {
                                          'name': widget.name,
                                          'email': widget.email,
                                          'token': widget.token,
                                        });
                                  }
                                },
                                child: listTileLayout(
                                  Icons.no_accounts,
                                  'Delete Account',
                                  ServiceProvider.redWarningColor,
                                  Icons.chevron_right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            left: 50,
                            top: 12,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 1, left: 10, right: 10),
                              color:
                                  themeManager.currentTheme == ThemeMode.light
                                      ? ServiceProvider.backGroundColor
                                      : ServiceProvider.darkNavyBGColor,
                              child: Text(
                                'Security Setup',
                                style: TextStyle(
                                    color: themeManager.currentTheme ==
                                            ThemeMode.light
                                        ? Colors.black
                                        : ServiceProvider.whiteColorShade70,
                                    fontSize: 12),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listTileLayout(
      IconData icon, String listName, Color color, IconData trailingIcon) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
          color: themeManager.currentTheme == ThemeMode.light
              ? Colors.black.withOpacity(0.05)
              : ServiceProvider.blueTrackColor,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: 0.0),
            curve: Curves.easeInOut,
            duration: const Duration(seconds: 1),
            child: ListTile(
              leading: Icon(
                icon,
                color: color,
              ),
              title: Text(
                listName,
                style: GoogleFonts.sora().copyWith(color: color),
              ),
              trailing: Icon(trailingIcon,
                  color: themeManager.currentTheme == ThemeMode.light
                      ? Colors.black
                      : ServiceProvider.whiteColorShade70),
            ),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(value * 150, 0.0),
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }

  // FUNCTION TO
}
