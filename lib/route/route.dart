import 'dart:io';

import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/pages/fund_wallet.dart';
import 'package:digital_mobile_bill/pages/airtime_page.dart';
import 'package:digital_mobile_bill/pages/cable_tv.dart';
import 'package:digital_mobile_bill/pages/change_password.dart';
import 'package:digital_mobile_bill/pages/change_pin.dart';
import 'package:digital_mobile_bill/pages/data_page.dart';
import 'package:digital_mobile_bill/pages/delete_acct_pwd.dart';
import 'package:digital_mobile_bill/pages/edit_profile.dart';
import 'package:digital_mobile_bill/pages/electricity_page.dart';
import 'package:digital_mobile_bill/pages/contact.dart';
import 'package:digital_mobile_bill/pages/end_user_agreement.dart';
import 'package:digital_mobile_bill/pages/help_contact.dart';
import 'package:digital_mobile_bill/pages/home_page.dart';
import 'package:digital_mobile_bill/pages/interent_page.dart';
import 'package:digital_mobile_bill/pages/login.dart';
import 'package:digital_mobile_bill/pages/login_with_pin.dart';
import 'package:digital_mobile_bill/pages/notification.dart';
import 'package:digital_mobile_bill/pages/otp_verification.dart';
import 'package:digital_mobile_bill/pages/passwd_reset.dart';
import 'package:digital_mobile_bill/pages/referral_code.dart';
import 'package:digital_mobile_bill/pages/register.dart';
import 'package:digital_mobile_bill/pages/security_pin.dart';
import 'package:digital_mobile_bill/pages/service_page.dart';
import 'package:digital_mobile_bill/pages/settings.dart';
import 'package:digital_mobile_bill/pages/welcome_page.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:digital_mobile_bill/widget/airtime_data_structure.dart';
import 'package:digital_mobile_bill/widget/authenticate_pin.dart';
import 'package:digital_mobile_bill/widget/bottom_nav_buttons.dart';
import 'package:digital_mobile_bill/widget/flash_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class RouteManager {
  static const String flashLogo = '/';
  static const String welcomePage = '/welcomePage';
  static const String register = '/register';
  static const String otpVerify = '/otpVerify';
  static const String securityPin = '/securityPin';
  static const String homePage = '/homePage';
  static const String login = '/login';
  static const String resetPassword = '/resetPassword';
  static const String loginWithPin = '/loginWithPin';
  static const String dataPage = '/dataPage';
  static const String airtimePage = '/airtimePage';
  static const String cableTV = '/cableTV';
  // static const String services = '/services';
  static const String internet = '/internet';
  static const String electricity = '/electricity';
  static const String notification = '/notification';
  static const String fundWallet = '/fundWallet';
  static const String editProfile = '/editProfile';
  static const String settings = '/settings';
  static const String changePin = '/changePin';
  static const String changePassword = '/changePassword';
  static const String deleteAcct = '/deleteAcct';
  static const String helpContact = '/helpContact';
  static const String contact = '/contact';
  static const String authenticatePin = '/authenticatePin';
  static const String userAgreement = '/userAgreement';
  static const String referralCode = '/referralCode';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var valuePassed = {};
    if (settings.arguments != null) {
      valuePassed = settings.arguments as Map<String, dynamic>;
    }
    switch (settings.name) {
      //     case flashLogo:
      //       return MaterialPageRoute(
      //         builder: (context) => const FlashLogo(),
      //       );

      //     case welcomePage:
      //       return MaterialPageRoute(
      //         builder: (context) => WelcomePage(),
      //       );

      //     case register:
      //       return MaterialPageRoute(
      //         builder: (context) => const Register(),
      //       );

      //     case otpVerify:
      //       return MaterialPageRoute(
      //         builder: (context) => OTPVerification(
      //           name: valuePassed['name'],
      //           email: valuePassed['email'],
      //           token: valuePassed['token'],
      //           otpSecretKey: valuePassed['otpSecretKey'],
      //           otpValidDate: valuePassed['otpValidDate'],
      //           call: valuePassed['call'],
      //         ),
      //       );

      //     case securityPin:
      //       return MaterialPageRoute(
      //         builder: (context) => SecurityPin(
      //           name: valuePassed['name'],
      //           token: valuePassed['token'],
      //         ),
      //       );

      // case homePage:
      //   return MaterialPageRoute(
      //     builder: (context) => HomePage(
      //       token: valuePassed['token'],
      //       name: valuePassed['name'],
      //       email: valuePassed['email'],
      //     ),
      //   );

      case login:
        return MaterialPageRoute(
          builder: (context) => Login(
            isLastStack: valuePassed['isLastStack'],
          ),
        );

      //     case resetPassword:
      //       return MaterialPageRoute(
      //         builder: (context) => PasswordReset(),
      //       );

      //     case loginWithPin:
      //       return MaterialPageRoute(
      //         builder: (context) => LoginWithPin(
      //           userName: valuePassed['userName'],
      //           email: valuePassed['email'],
      //         ),
      //       );

      //     case dataPage:
      //       return MaterialPageRoute(
      //         builder: (context) => DataPage(
      //           balance: valuePassed['balance'],
      //           providerChoice: valuePassed['providerChoice'],
      //         ),
      //       );

      //     case airtimePage:
      //       return MaterialPageRoute(
      //         builder: (context) => AirtimePage(
      //           providerChoice: valuePassed['providerChoice'],
      //         ),
      //       );

      //     case cableTV:
      //       return MaterialPageRoute(
      //         builder: (context) => CableTV(
      //           providerChoice: valuePassed['providerChoice'],
      //         ),
      //       );

      //     case services:
      //       return MaterialPageRoute(
      //         builder: (context) => Services(
      //           token: valuePassed['token'],
      //           name: valuePassed['name'],
      //           email: valuePassed['email'],
      //         ),
      //       );

      default:
        throw const FormatException('Route not found! Check routes again.');
    }
  }
}

// ==========================================================================

class GetXRoute extends StatefulWidget {
  const GetXRoute({Key? key}) : super(key: key);

  @override
  State<GetXRoute> createState() => _GetXRouteState();
}

class _GetXRouteState extends State<GetXRoute> {
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarDividerColor:
            ThemeManager().currentTheme == ThemeMode.light
                ? Colors.grey.shade400
                : ServiceProvider.blueTrackColor,
        systemNavigationBarColor: ThemeManager().currentTheme == ThemeMode.light
            ? ServiceProvider.backGroundColor
            : ServiceProvider.darkNavyBGColor,
      ));
    }

    themeManager.addListener(() {
      if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: true,
          systemNavigationBarDividerColor:
              ThemeManager().currentTheme == ThemeMode.light
                  ? Colors.grey.shade400
                  : ServiceProvider.blueTrackColor,
          systemNavigationBarColor:
              ThemeManager().currentTheme == ThemeMode.light
                  ? ServiceProvider.backGroundColor
                  : ServiceProvider.darkNavyBGColor,
        ));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeManager.lightTheme,
      darkTheme: ThemeManager.darkTheme,
      themeMode: ThemeManager().currentTheme,
      // themeMode: themeManager.currentTheme,
      initialRoute: RouteManager.flashLogo,
      getPages: [
        GetPage(
          name: RouteManager.flashLogo,
          page: () => const FlashLogo(),
        ),
        //
        GetPage(
          name: RouteManager.welcomePage,
          page: () => WelcomePage(),
        ),
        //
        GetPage(
          name: RouteManager.register,
          page: () => const Register(),
          transition: Transition.fade,
          transitionDuration: const Duration(seconds: 1),
        ),
        //
        GetPage(
          name: RouteManager.otpVerify,
          page: () {
            var argumentData = Get.arguments;
            return OTPVerification(
              name: argumentData['name'],
              email: argumentData['email'],
              token: argumentData['token'],
              otpSecretKey: argumentData['otpSecretKey'],
              otpValidDate: argumentData['otpValidDate'],
              call: argumentData['call'],
              mobile: argumentData['mobile'],
            );
          },
          transition: Transition.fade,
          transitionDuration: const Duration(seconds: 1),
        ),
        //
        GetPage(
          name: RouteManager.securityPin,
          page: () {
            var _argumentData = Get.arguments;
            return SecurityPin(
              name: _argumentData['name'],
              token: _argumentData['token'],
              email: _argumentData['email'],
              mobile: _argumentData['mobile'],
            );
          },
          transition: Transition.fade,
          transitionDuration: const Duration(seconds: 1),
        ),
        //
        GetPage(
          name: RouteManager.homePage,
          page: () {
            var _argumentData = Get.arguments;
            return HomePage(
              token: _argumentData['token'],
              name: _argumentData['name'],
              email: _argumentData['email'],
              mobile: _argumentData['mobile'],
              acctBal: _argumentData['acctBal'],
            );
          },
          transition: Transition.zoom,
          transitionDuration: const Duration(seconds: 1),
        ),

        GetPage(
          name: RouteManager.login,
          page: () {
            var _argumentData = Get.arguments;
            return Login(isLastStack: _argumentData['isLastStack']);
          },
          transition: Transition.fade,
          transitionDuration: const Duration(seconds: 1),
        ),

        GetPage(
          name: RouteManager.resetPassword,
          page: () => PasswordReset(),
          transition: Transition.fade,
          transitionDuration: const Duration(seconds: 1),
        ),
        //
        GetPage(
          name: RouteManager.loginWithPin,
          page: () {
            var _argumentData = Get.arguments;
            return LoginWithPin(
              userName: _argumentData['userName'],
              email: _argumentData['email'],
            );
          },
          transition: Transition.fade,
          transitionDuration: const Duration(seconds: 1),
        ),
        //
        GetPage(
          name: RouteManager.dataPage,
          page: () {
            var _argumentData = Get.arguments;
            return DataPage(
                balance: _argumentData['balance'],
                providerChoice: _argumentData['providerChoice']);
          },
          transition: Transition.zoom,
        ),
        //
        GetPage(
          name: RouteManager.airtimePage,
          page: () {
            var _argumentData = Get.arguments;
            return AirtimePage(providerChoice: _argumentData['providerChoice']);
          },
          transition: Transition.zoom,
        ),
        //
        GetPage(
          name: RouteManager.cableTV,
          page: () {
            var _argumentData = Get.arguments;
            return CableTV(providerChoice: _argumentData['providerChoice']);
          },
          transition: Transition.zoom,
        ),
        //
        // GetPage(
        //   name: RouteManager.services,
        //   page: () {
        //     var _argumentData = Get.arguments;
        //     return Services(
        //       token: _argumentData['token'],
        //       name: _argumentData['name'],
        //       email: _argumentData['email'],
        //     );
        //   },
        //   transition: Transition.zoom,
        // ),
        //
        GetPage(
          name: RouteManager.internet,
          page: () => const InternetPage(),
          transition: Transition.zoom,
        ),
        //
        GetPage(
          name: RouteManager.electricity,
          page: () => const ElectricityPage(),
          transition: Transition.zoom,
        ),

        //
        GetPage(
          name: RouteManager.notification,
          page: () {
            var _argumentData = Get.arguments;
            return NotificationPage(
              token: _argumentData['token'],
              name: _argumentData['name'],
              email: _argumentData['email'],
            );
          },
          transition: Transition.zoom,
        ),

        //
        GetPage(
          name: RouteManager.fundWallet,
          page: () {
            var _argumentData = Get.arguments;
            return FundWallet(
              token: _argumentData['token'],
              name: _argumentData['name'],
              email: _argumentData['email'],
            );
          },
          transition: Transition.zoom,
        ),

        //
        GetPage(
          name: RouteManager.editProfile,
          page: () {
            var _argumentData = Get.arguments;
            return EditProfile(
              token: _argumentData['token'],
              name: _argumentData['name'],
              email: _argumentData['email'],
              mobile: _argumentData['mobile'],
            );
          },
          transition: Transition.zoom,
        ),

        //
        GetPage(
          name: RouteManager.settings,
          page: () {
            var _argumentData = Get.arguments;
            return AccountSettings(
              token: _argumentData['token'],
              name: _argumentData['name'],
              email: _argumentData['email'],
            );
          },
          transition: Transition.zoom,
        ),

        //
        GetPage(
          name: RouteManager.changePin,
          page: () {
            var _argumentData = Get.arguments;
            return ChangePin(
              token: _argumentData['token'],
              name: _argumentData['name'],
              email: _argumentData['email'],
            );
          },
          transition: Transition.zoom,
        ),

        //
        GetPage(
          name: RouteManager.changePassword,
          page: () {
            var _argumentData = Get.arguments;
            return ChangePassword(
              token: _argumentData['token'],
              name: _argumentData['name'],
              email: _argumentData['email'],
            );
          },
          transition: Transition.zoom,
        ),

        //
        GetPage(
          name: RouteManager.deleteAcct,
          page: () {
            var _argumentData = Get.arguments;
            return DeleteAccountPassword(
              token: _argumentData['token'],
              name: _argumentData['name'],
              email: _argumentData['email'],
            );
          },
          transition: Transition.zoom,
        ),

        //
        GetPage(
          name: RouteManager.contact,
          page: () {
            var _argumentData = Get.arguments;
            return Contact(
              token: _argumentData['token'],
              name: _argumentData['name'],
              email: _argumentData['email'],
              mobile: _argumentData['mobile'],
              subject: _argumentData['subject'],
            );
          },
          transition: Transition.zoom,
        ),

        //
        GetPage(
          name: RouteManager.helpContact,
          page: () {
            var _argumentData = Get.arguments;
            return HelpContact(
              token: _argumentData['token'],
              name: _argumentData['name'],
              email: _argumentData['email'],
              mobile: _argumentData['mobile'],
            );
          },
          transition: Transition.zoom,
        ),

        //
        GetPage(
          name: RouteManager.authenticatePin,
          page: () {
            var _argumentData = Get.arguments;
            return AuthenticatePin(
              token: _argumentData['token'],
              name: _argumentData['name'],
              email: _argumentData['email'],
              call: _argumentData['call'],
              prefImage: _argumentData['prefImage'],
              pageTitle: _argumentData['pageTitle'],
              pageInfo1: _argumentData['pageInfo1'],
              pageInfo2: _argumentData['pageInfo2'],
              requestedAmt: _argumentData['requestedAmt'],
              mobileTransNo: _argumentData['mobileTransNo'],
              providerChoice: _argumentData['providerChoice'],
              subscriptionId: _argumentData['subscriptionId'],
              dataAmt: _argumentData['dataAmt'],
              isNumSetAsDefault: _argumentData['isNumSetAsDefault'],
            );
          },
          transition: Transition.fadeIn,
        ),

        GetPage(
          name: RouteManager.userAgreement,
          page: () => const EndUserAgreement(),
          transition: Transition.zoom,
        ),

        GetPage(
          name: RouteManager.referralCode,
          page: () {
            var _argumentData = Get.arguments;
            return ReferralCode(
              name: _argumentData['name'],
            );
          },
          transition: Transition.zoom,
        ),
      ],
    );
  }
}
