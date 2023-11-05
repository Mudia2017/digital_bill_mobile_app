import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/pages/home_page.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:digital_mobile_bill/widget/bottom_nav_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Services extends StatelessWidget {
  Services({Key? key}) : super(key: key);
  var serviceProvider = ServiceProvider();
  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      // bottomNavigationBar:
      // BottomNavigatorButtons(
      //   token: token,
      //   name: name,
      //   email: email,
      // ),
      body: SafeArea(
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
          child: Container(
            height: screenH,
            width: screenW,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                Text(
                  'Our Services',
                  style: ServiceProvider.pageNameFont,
                ),
                SizedBox(
                  height: screenH * 0.04,
                ),
                Text(
                  'We offer premium services to meet your daily needs',
                  style: ServiceProvider.pageInfoWithLightGreyFont,
                ),
                SizedBox(
                  height: screenH * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteManager.dataPage,
                            arguments: {'providerChoice': ''});
                      },
                      child: serviceTemplate(
                          Icon(
                            Icons.wifi_tethering,
                            color: themeManager.currentTheme == ThemeMode.light
                                ? Colors.black
                                : ServiceProvider.whiteColorShade70,
                          ),
                          'Data'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            RouteManager.airtimePage,
                            arguments: {'providerChoice': ''});
                      },
                      child: serviceTemplate(
                          Icon(
                            Icons.cell_wifi,
                            color: themeManager.currentTheme == ThemeMode.light
                                ? Colors.black
                                : ServiceProvider.whiteColorShade70,
                          ),
                          'Airtime'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteManager.cableTV,
                            arguments: {'providerChoice': ''});
                      },
                      child: serviceTemplate(
                          Icon(
                            Icons.connected_tv,
                            color: themeManager.currentTheme == ThemeMode.light
                                ? Colors.black
                                : ServiceProvider.whiteColorShade70,
                          ),
                          'Cable TV'),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenH * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteManager.internet);
                      },
                      child: serviceTemplate(
                          Icon(
                            Icons.router_rounded,
                            color: themeManager.currentTheme == ThemeMode.light
                                ? Colors.black
                                : ServiceProvider.whiteColorShade70,
                          ),
                          'Internet'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.electricity);
                      },
                      child: serviceTemplate(
                          Icon(
                            Icons.light_sharp,
                            color: themeManager.currentTheme == ThemeMode.light
                                ? Colors.black
                                : ServiceProvider.whiteColorShade70,
                          ),
                          'Electricity'),
                    ),
                    InkWell(
                      onTap: () {},
                      child: serviceTemplate(
                          Icon(
                            Icons.flight_sharp,
                            color: themeManager.currentTheme == ThemeMode.light
                                ? Colors.black
                                : ServiceProvider.whiteColorShade70,
                          ),
                          'Book a Flight'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget serviceTemplate(Icon _icon, String serviceName) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 0.0),
      curve: Curves.bounceOut,
      duration: const Duration(seconds: 2),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: themeManager.currentTheme == ThemeMode.light
              ? Colors.white
              : ServiceProvider.blueTrackColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: themeManager.currentTheme == ThemeMode.light
                ? Colors.grey.withOpacity(0.6)
                : const Color.fromRGBO(0, 0, 3, 1),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _icon,
              const SizedBox(
                height: 15,
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: 0.0),
                curve: Curves.bounceOut,
                duration: const Duration(milliseconds: 0),
                child: Text(
                  serviceName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(value * 50, 0.0),
                    child: child,
                  );
                },
              )
            ],
          ),
        ),
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value * 150, 0.0),
          child: child,
        );
      },
    );
  }
}
