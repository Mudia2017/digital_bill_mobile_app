// import 'package:digital_mobile_bill/components/database_helper.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/pages/acct_profile.dart';
import 'package:digital_mobile_bill/pages/airtime_page.dart';
import 'package:digital_mobile_bill/pages/history.dart';
import 'package:digital_mobile_bill/pages/service_page.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:digital_mobile_bill/widget/bottom_nav_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String token, name, email, mobile, acctBal;
  const HomePage({
    Key? key,
    required this.token,
    required this.name,
    required this.email,
    required this.mobile,
    required this.acctBal,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      getSizeAndPosition();
    });

    getProfileInfo();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    if (serviceProvider.isLifeCycleState) {
      switch (state) {
        case AppLifecycleState.resumed:
          serviceProvider.authenticateUser(context, widget.name, widget.email);
          break;
        case AppLifecycleState.inactive:
          serviceProvider.logOutUser();
          break;
        case AppLifecycleState.paused:
          serviceProvider.logOutUser();
          break;
        case AppLifecycleState.detached:
          serviceProvider.logOutUser();
          break;
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  GlobalKey _widgetKey = GlobalKey();
  GlobalKey _widgetKey2 = GlobalKey();
  static double screenW = 0;
  static double screenH = 0;
  // Size size = Size(0, 0);
  Offset position = const Offset(100, 100);
  Offset position2 = const Offset(100, 100);
  // double _size = 0.0;
  // double _size2 = 0.0;
  double positionDy = 0;
  double positionDy2 = 0;
  List userProfile = [];
  int _selectIndex = 0;
  String name = '';
  String mobile = '';
  // Image? imageFromPreference;
  int _count = 0;
  List recentTranLog = [];

  getScreenSize(h, w) {
    screenH = h;
    screenW = w;
  }

  getSizeAndPosition() {
    RenderBox _widgetBox =
        _widgetKey.currentContext!.findRenderObject() as RenderBox;
    RenderBox _widgetBox2 =
        _widgetKey2.currentContext!.findRenderObject() as RenderBox;

    // size = _widgetBox.size;
    position = _widgetBox.localToGlobal(Offset.zero);
    position2 = _widgetBox2.localToGlobal(Offset.zero);

    positionDy = position.dy;
    positionDy2 = position2.dy;
  }

  // THE SCREEN OF BOTTOM NAV BAR
  // ignore: prefer_final_fields
  static List<Widget> _widgetOptions = <Widget>[
    const Text(''),
    Services(),
    History(),
    const AccountProfile(),
  ];

  getProfileInfo() async {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    await serviceProvider.saveUserInfoToLocalStorage(widget.name, widget.email,
        widget.token, widget.mobile); // SAVE PROFILE INFO TO LOCAL DB.

    var serverResponse = await serviceProvider.acctProfile(widget.token);
    if (serverResponse['isSuccess'] == false) {
      await serviceProvider.signOut();
      serviceProvider.showErrorToast(
          context, 'User account was not valid. Kindly login');
      Navigator.of(context).pushNamed(RouteManager.login);
      // if (serverResponse['errorMsg'] != '') {
      //   serviceProvider.popWarningErrorMsg(
      //       context, 'Error', serverResponse['errorMsg'].toString());
      // }
    } else {
      setState(() {
        name = serverResponse['userProfile']['name'];
        serviceProvider.isShowBal =
            serverResponse['userProfile']['isBalVisible'];
        serviceProvider.isLifeCycleState =
            serverResponse['userProfile']['is_lock_inactive_mode'];
        if (serverResponse['userProfile']['image'] ==
            'http://192.168.43.50:8000') {
          ServiceProvider.profileImgFrmServer = '';
        } else {
          ServiceProvider.profileImgFrmServer =
              serverResponse['userProfile']['image'];
        }
        recentTranLog = serverResponse['tranLog'];
      });
      await serviceProvider
          .isSetLifeCycleToPref(serviceProvider.isLifeCycleState);

      ServiceProvider.isAuthorizeTrans =
          serverResponse['userProfile']['authorize_all_trans'];
      // SAVE DEFAULT TRANSACTION NUMBER TO SHARED PREF
      if (serverResponse['userProfile']['data_default_no'] != null) {
        await serviceProvider.saveDefaultDataNumToPref(
            serverResponse['userProfile']['data_default_no']);
      }
      if (serverResponse['userProfile']['airtime_default_no'] != null) {
        await serviceProvider.saveDefaultAirtimeNumToPref(
            serverResponse['userProfile']['airtime_default_no']);
      }
      if (serverResponse['userProfile']['cable_iuc_default'] != null) {
        await serviceProvider.saveDefaultCableNumToPref(
            serverResponse['userProfile']['cable_iuc_default']);
      }
      if (serverResponse['userProfile']['internet_default_no'] != null) {
        await serviceProvider.saveDefaultInternetNumToPref(
            serverResponse['userProfile']['internet_default_no']);
      }
      if (serverResponse['userProfile']['meter_default_no'] != null) {
        await serviceProvider.saveDefaultMeterNumToPref(
            serverResponse['userProfile']['meter_default_no']);
      }

      ServiceProvider.urReferralCode =
          serverResponse['userProfile']['unique_referral_code'];

      ServiceProvider.userAgreement =
          serverResponse['compAgreement']['compAgreementRecord'];
    }
    setState(() {
      ServiceProvider.acctBal = widget.acctBal;
    });
  }

  loadImageFromPreferences() async {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    Image _imageFromPreference =
        await serviceProvider.loadImageFromPreferences();
    setState(() {
      // imageFromPreference = _imageFromPreference;
    });
  }

  FutureOr _refreshData() async {
    Map data = {};
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    data = await serviceProvider.getUserInfo();
    name = data['name'];
  }

  @override
  Widget build(BuildContext context) {
    var serviceProvider = Provider.of<ServiceProvider>(context);

    // getSizeAndPosition();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // isToggle = serviceProvider.isShowBal;
    Map data = {
      'isShowAcctBal': serviceProvider.isShowBal,
      'call': 'toggleAcctBal',
    };

    if (ServiceProvider.isEditProfile) {
      _refreshData();
      ServiceProvider.isEditProfile = false;
    }

    if (_count < 2) {
      // loadImageFromPreferences();
      _count++;
    } else {
      _count = 0;
    }

    getScreenSize(h, w);
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottomNavigationBar: bottomNavBar(),
        body: AnimatedSwitcher(
          duration: const Duration(seconds: 60),
          child: SafeArea(
              child: SizedBox(
            height: h,
            child: Stack(
              children: [
                if (_selectIndex == 0) _headSection(data),
                if (_selectIndex == 0) _detailSection(),
                if (_selectIndex > 0) _widgetOptions.elementAt(_selectIndex),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget bottomNavBar() {
    return Material(
      elevation: 22,
      child: Container(
        color: themeManager.currentTheme == ThemeMode.light
            ? ServiceProvider.backGroundColor
            : ServiceProvider.darkNavyBGColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
          child: GNav(
            gap: 8,
            activeColor: ServiceProvider.lightBlueBackGroundColor,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                iconColor: themeManager.currentTheme == ThemeMode.light
                    ? Colors.black
                    : ServiceProvider.whiteColorShade70,
              ),
              GButton(
                icon: Icons.dashboard_rounded,
                text: 'Service',
                iconColor: themeManager.currentTheme == ThemeMode.light
                    ? Colors.black
                    : ServiceProvider.whiteColorShade70,
              ),
              GButton(
                icon: Icons.history,
                text: 'History',
                iconColor: themeManager.currentTheme == ThemeMode.light
                    ? Colors.black
                    : ServiceProvider.whiteColorShade70,
              ),
              GButton(
                icon: Icons.manage_accounts,
                text: 'Settings',
                iconColor: themeManager.currentTheme == ThemeMode.light
                    ? Colors.black
                    : ServiceProvider.whiteColorShade70,
              ),
            ],
            selectedIndex: _selectIndex,
            onTabChange: (index) {
              setState(() {
                _selectIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  _headSection(data) {
    return SizedBox(
      height: (screenH * 40) / 100,
      child: Stack(
        children: [
          _mainBackground(),
          _headerElementContainer(data),
        ],
      ),
    );
  }

  static _mainBackground() {
    return Positioned(
      child: Container(
        decoration: BoxDecoration(
            color: themeManager.currentTheme == ThemeMode.light
                ? ServiceProvider.lightBlueBackGroundColor
                : ServiceProvider.blueTrackColor
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //   image: AssetImage(
            //     "images/image_header.png",
            //   ),
            // ),
            ),
      ),
    );
  }

  _headerElementContainer(data) {
    var serviceProvider = Provider.of<ServiceProvider>(context);

    return Positioned(
      left: (screenW * 6) / 100,
      top: (screenH * 2) / 100,
      bottom: (screenH * 5) / 100,
      right: (screenW * 6) / 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: 0.0),
            duration: const Duration(seconds: 2),
            curve: Curves.bounceOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(
                  0.0,
                  -value * 100,
                ),
                child: child,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _displayBalance(),
                IconButton(
                    onPressed: () async {
                      var response = await serviceProvider.setUpdateAcct(
                        context,
                        widget.token,
                        data,
                      );
                      if (response['isSuccess'] == true) {
                        // setState(() {
                        // serviceProvider.isShowBal = response['isBalVisible'];
                        // serviceProvider.isShowBal = isToggle;
                        // });
                        serviceProvider.showSuccessToast(
                            context, 'Update successful');
                        print(serviceProvider.isShowBal);
                      }
                    },
                    icon: Icon(
                      serviceProvider.isShowBal
                          ? Icons.visibility
                          : Icons.visibility_off_outlined,
                      color: Colors.white,
                    )),
                const SizedBox(
                  width: 20,
                ),
                _notifybellAvatarIcon(),
              ],
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: 0.0),
            duration: const Duration(seconds: 2),
            curve: Curves.bounceOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(
                  0.0,
                  -value * 100,
                ),
                child: child,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Balance',
                  style: ServiceProvider.blueWriteOnBlueBgColorFont,
                ),
                SizedBox(
                  width: screenW * 0.55,
                  child: Text(
                    'Welcome $name !',
                    style: ServiceProvider.blueBgFontName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: 0.0),
            duration: const Duration(seconds: 2),
            curve: Curves.bounceOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(
                  0.0,
                  -value * 100,
                ),
                child: child,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _depositButton(),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Row(
            key: _widgetKey2,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  showModalBottomSheet<dynamic>(
                      isDismissible: false,
                      isScrollControlled: true,
                      enableDrag: false,
                      barrierColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext cxt) {
                        return SizedBox(
                          height: screenH - positionDy2,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: themeManager.currentTheme ==
                                            ThemeMode.light
                                        ? const Color(0xFFeef1f4)
                                            .withOpacity(0.7)
                                        : const Color.fromRGBO(0, 22, 38, 0.7),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(35),
                                      topRight: Radius.circular(35),
                                    ),
                                  ),
                                  width: screenW,
                                  height: screenH - positionDy,
                                ),
                              ),
                              Positioned(
                                left: (screenW * 6) / 100,
                                child: Container(
                                  width: (screenW * 17) / 100,
                                  height: 300,
                                  decoration: BoxDecoration(
                                      color: ServiceProvider.darkBlueShade4,
                                      borderRadius: BorderRadius.circular(13)),
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Transform.rotate(
                                          angle: 150.0,
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushNamed(
                                              RouteManager.dataPage,
                                              arguments: {
                                                'balance': '3000',
                                                'providerChoice': 'mtnData'
                                              });
                                        },
                                        child: Hero(
                                          tag: 'mtn_logo',
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            width: 50,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      "images/mtn_logo.png")),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Text(''),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushNamed(
                                              RouteManager.dataPage,
                                              arguments: {
                                                'balance': '3000',
                                                'providerChoice': 'gloData'
                                              });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          width: 50,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    "images/glo.png")),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(''),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushNamed(
                                              RouteManager.dataPage,
                                              arguments: {
                                                'balance': '3000',
                                                'providerChoice': 'airtelData'
                                              });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          width: 50,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    "images/airtel.png")),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(''),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushNamed(
                                              RouteManager.dataPage,
                                              arguments: {
                                                'balance': '3000',
                                                'providerChoice': '9mobileData'
                                              });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          width: 50,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    "images/9mobile.png")),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(''),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: _quickActionTemplate(Icons.wifi_tethering, 'Data'),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet<dynamic>(
                      isDismissible: false,
                      isScrollControlled: true,
                      enableDrag: false,
                      barrierColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext cxt) {
                        return SizedBox(
                          height: screenH - positionDy2,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: themeManager.currentTheme ==
                                            ThemeMode.light
                                        ? const Color(0xFFeef1f4)
                                            .withOpacity(0.7)
                                        : const Color.fromRGBO(0, 22, 38, 0.7),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(35),
                                      topRight: Radius.circular(35),
                                    ),
                                  ),
                                  width: screenW,
                                  height: screenH - positionDy,
                                ),
                              ),
                              Positioned(
                                left: (screenW - ((screenW * 12.6) / 100)) / 3,
                                child: Container(
                                  width: (screenW * 17) / 100,
                                  height: 300,
                                  decoration: BoxDecoration(
                                      color: ServiceProvider.darkBlueShade4,
                                      borderRadius: BorderRadius.circular(13)),
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Transform.rotate(
                                          angle: 150.0,
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushNamed(
                                              RouteManager.airtimePage,
                                              arguments: {
                                                'providerChoice': 'mtnAirtime'
                                              });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          width: 50,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    "images/mtn_logo.png")),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(''),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushNamed(
                                              RouteManager.airtimePage,
                                              arguments: {
                                                'providerChoice': 'gloAirtime'
                                              });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          width: 50,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    "images/glo.png")),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(''),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushNamed(
                                              RouteManager.airtimePage,
                                              arguments: {
                                                'providerChoice':
                                                    'airtelAirtime'
                                              });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          width: 50,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    "images/airtel.png")),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(''),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushNamed(
                                              RouteManager.airtimePage,
                                              arguments: {
                                                'providerChoice':
                                                    '9mobileAirtime'
                                              });
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          width: 50,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    "images/9mobile.png")),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(''),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
                child: _quickActionTemplate(Icons.cell_wifi, 'AirTime'),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet<dynamic>(
                      isDismissible: false,
                      isScrollControlled: true,
                      enableDrag: false,
                      barrierColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext cxt) {
                        return SizedBox(
                          height: screenH - positionDy2,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: themeManager.currentTheme ==
                                            ThemeMode.light
                                        ? const Color(0xFFeef1f4)
                                            .withOpacity(0.7)
                                        : const Color.fromRGBO(0, 22, 38, 0.7),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(35),
                                      topRight: Radius.circular(35),
                                    ),
                                  ),
                                  width: screenW,
                                  height: screenH - positionDy,
                                ),
                              ),
                              Positioned(
                                  right:
                                      (screenW - ((screenW * 39.4) / 100)) / 2,
                                  child: Container(
                                    width: (screenW * 17) / 100,
                                    height: 300,
                                    decoration: BoxDecoration(
                                        color: ServiceProvider.darkBlueShade4,
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    child: Column(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: Transform.rotate(
                                            angle: 150.0,
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pushNamed(
                                                RouteManager.cableTV,
                                                arguments: {
                                                  'providerChoice': 'dstv'
                                                });
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            width: 50,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      "images/dstv.png")),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Text(''),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pushNamed(
                                                RouteManager.cableTV,
                                                arguments: {
                                                  'providerChoice': 'gotv'
                                                });
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            width: 50,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      "images/gotv.png")),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Text(''),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pushNamed(
                                                RouteManager.cableTV,
                                                arguments: {
                                                  'providerChoice': 'startimes'
                                                });
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            width: 50,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      "images/startimes.png")),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Text(''),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pushNamed(
                                                RouteManager.cableTV,
                                                arguments: {
                                                  'providerChoice': 'showmax'
                                                });
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            width: 50,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      "images/showmax.png")),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Text(''),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        );
                      });
                },
                child: _quickActionTemplate(Icons.connected_tv, 'Cable TV'),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectIndex = 1;
                  });
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     RouteManager.services, (Route<dynamic> route) => false,
                  //     arguments: {
                  //       'token': widget.token,
                  //       'name': widget.name,
                  //       'email': widget.email,
                  //     });
                },
                child: _quickActionTemplate(Icons.more_horiz, 'More'),
              ),
            ],
          )
        ],
      ),
    );
  }

  _displayBalance() {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    return Container(
      child: Flexible(
        child: Text(
          serviceProvider.isShowBal
              ? "₦ ${serviceProvider.numberFormater(double.parse(ServiceProvider.acctBal))}"
              : '****',
          style: GoogleFonts.sarabun().copyWith(
            color: Colors.white,
            fontSize: 25,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }

  _notifybellAvatarIcon() {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    return Row(children: [
      InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(RouteManager.notification,
              arguments: {
                'name': name,
                'email': widget.email,
                'token': widget.token
              });
        },
        child: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              border: Border.all(
                color: ServiceProvider.lightBlueWriteColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: const Icon(
            Icons.notifications_active,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Container(
        margin: const EdgeInsets.only(left: 10.0),
        child: Column(
          children: [
            if (ServiceProvider.profileImgFrmServer != '')
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
                  backgroundColor: ServiceProvider.innerBlueBackgroundColor,
                  child: const Icon(
                    Icons.person,
                    size: 60,
                  ))

            // if (profileImg == "" || profileImg == "http://192.168.43.50:8000")
            //   CircleAvatar(
            //       radius: 25,
            //       backgroundColor: ServiceProvider.innerBlueBackgroundColor,
            //       child: const Icon(
            //         Icons.person,
            //         size: 50,
            //       ))
            // // else if (serviceProvider.isUpdateProfilePix)
            // //   CircleAvatar(
            // //     radius: 30,
            // //     backgroundColor: ServiceProvider.innerBlueBackgroundColor,
            // //     backgroundImage: imageFromPreference!.image,
            // //   )
            // else
            //   CircleAvatar(
            //     radius: 30,
            //     backgroundColor: ServiceProvider.innerBlueBackgroundColor,
            //     backgroundImage: NetworkImage(profileImg),
            //   ),
          ],
        ),
      ),
    ]);
  }

  _depositButton() {
    return Container(
      margin: EdgeInsets.only(
        bottom: (screenH * 2) / 100,
      ),
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteManager.fundWallet, arguments: {
            'name': name,
            'token': widget.token,
            'email': widget.email,
          }).then((value) {
            setState(() {});
          });
        },
        child: Row(
          children: const [
            Text(
              'Deposit Fund',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Icon(
              Icons.add,
              color: Colors.white,
            )
          ],
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: ServiceProvider.lightBlueWriteColor,
          ),
        ),
      ),
    );
  }

  _quickActionTemplate(IconData icon, String textName) {
    return Column(
      children: [
        Container(
          width: (screenW * 15) / 100,
          height: (screenH * 8) / 100,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: Colors.lightBlue.shade900,
              )),
          child: Icon(
            icon,
            color: themeManager.currentTheme == ThemeMode.light
                ? ServiceProvider.lightBlueBackGroundColor
                : ServiceProvider.blueTrackColor,
            size: 40,
          ),
        ),
        Text(
          textName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  // DETAIL SECTION START HERE
  _detailSection() {
    return Positioned(
      top: (screenH * 35) / 100,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        key: _widgetKey,
        decoration: BoxDecoration(
          color: themeManager.currentTheme == ThemeMode.light
              ? ServiceProvider.backGroundColor
              : ServiceProvider.darkNavyBGColor,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(35), topLeft: Radius.circular(35)),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
          child: Column(
            children: [
              _detailHeader(),
              TransactionDetails(
                recentTranLog: recentTranLog,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _detailHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Recent Transaction',
            style: TextStyle(
              color: themeManager.currentTheme == ThemeMode.light
                  ? ServiceProvider.darkBlue
                  : ServiceProvider.whiteColorShade70,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _selectIndex = 2;
              });
            },
            child: Text(
              'See all',
              style: TextStyle(
                color: ServiceProvider.lightBlueBackGroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TransactionDetails extends StatelessWidget {
  List recentTranLog;
  TransactionDetails({Key? key, required this.recentTranLog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var serviceProvider = Provider.of<ServiceProvider>(context);
    return Expanded(
      child: recentTranLog.isNotEmpty
          ? ListView.builder(
              itemCount: recentTranLog.length,
              itemBuilder: (BuildContext cxt, int x) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 1.0, end: 0.0),
                  duration: const Duration(seconds: 1),
                  curve: Curves.ease,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(
                        value * 150,
                        0.0,
                      ),
                      child: child,
                    );
                  },
                  child: Card(
                    color: themeManager.currentTheme == ThemeMode.light
                        ? Colors.white
                        : ServiceProvider.blueTrackColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    elevation: 0,
                    child: ListTile(
                      leading: Stack(
                        children: [
                          if (recentTranLog[x]['serviceCode'] == 'mtnAirtime' ||
                              recentTranLog[x]['serviceCode'] == 'mtnData')
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage("images/mtn_logo.png")),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          else if (recentTranLog[x]['serviceCode'] ==
                                  'gloAirtime' ||
                              recentTranLog[x]['serviceCode'] == 'gloData')
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage("images/glo.png")),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          else if (recentTranLog[x]['serviceCode'] ==
                                  'airtelAirtime' ||
                              recentTranLog[x]['serviceCode'] == 'airtelData')
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage("images/airtel.png")),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          else if (recentTranLog[x]['serviceCode'] ==
                                  '9mobileAirtime' ||
                              recentTranLog[x]['serviceCode'] == '9mobileData')
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage("images/9mobile.png")),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          else if (recentTranLog[x]['serviceCode'] == 'smile')
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage("images/smile.png")),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                        ],
                      ),
                      title: Text(
                        recentTranLog[x]['serviceProvided'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ServiceProvider.contentFont,
                      ),
                      subtitle: Stack(
                        children: [
                          if (recentTranLog[x]['subscription'] != '')
                            Text(
                              recentTranLog[x]['subscription']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.sora().copyWith(
                                fontSize: 12,
                                color:
                                    themeManager.currentTheme == ThemeMode.light
                                        ? Colors.black54
                                        : ServiceProvider.idColor,
                              ),
                            )
                          else
                            Text(
                              recentTranLog[x]['transactionNo']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.sora().copyWith(
                                fontSize: 12,
                                color:
                                    themeManager.currentTheme == ThemeMode.light
                                        ? Colors.black54
                                        : ServiceProvider.idColor,
                              ),
                            )
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₦ ${serviceProvider.numberFormater(double.parse(recentTranLog[x]['amount']))}",
                            style: GoogleFonts.sarabun().copyWith(
                              color:
                                  themeManager.currentTheme == ThemeMode.light
                                      ? ServiceProvider.darkBlueShade4
                                      : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            (recentTranLog[x]['createdDate']),
                            style: GoogleFonts.sora().copyWith(
                              color: ServiceProvider.idColor,
                              fontSize: 11,
                            ),
                            // style: TextStyle(
                            //   color: ServiceProvider.idColor,
                            // ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.receipt_rounded, color: Colors.grey, size: 80),
                Text(
                  'No Record',
                  style: ServiceProvider.warningFont,
                ),
              ],
            ),
    );
  }

  formatDate(date) {
    DateTime dt = DateTime.parse(date);
    print(dt);
  }
}
