import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpContact extends StatefulWidget {
  final String name, token, email, mobile;
  const HelpContact({
    Key? key,
    required this.name,
    required this.token,
    required this.email,
    required this.mobile,
  }) : super(key: key);

  @override
  _HelpContactState createState() => _HelpContactState();
}

class _HelpContactState extends State<HelpContact> {
  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
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
                      Navigator.pop(context);
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
                    'Customer Service',
                    style: ServiceProvider.pageNameFont,
                  ),
                  Container(),
                ],
              ),
            ),
            SizedBox(
              height: screenH * 0.009,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                '${widget.name}, how can we help you today?',
                style: ServiceProvider.greetUserFont1,
              ),
            ),
            SizedBox(
              height: screenH * 0.009,
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
                child: Column(
                  children: [
                    InkWell(
                      child: listTileStructure(
                          'Transfer not reflecting in wallet',
                          'Transfer was made but not is not reflecting in my wallet'),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.contact, arguments: {
                          'name': widget.name,
                          'email': widget.email,
                          'token': widget.token,
                          'mobile': widget.mobile,
                          'subject': 'Transfer not reflecting in wallet',
                        });
                      },
                    ),
                    Divider(
                      color: themeManager.currentTheme == ThemeMode.light
                          ? Colors.black
                          : Colors.white24,
                    ),
                    InkWell(
                      child: listTileStructure('Debited without data',
                          'I was debited but the did not get the data'),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.contact, arguments: {
                          'name': widget.name,
                          'email': widget.email,
                          'token': widget.token,
                          'mobile': widget.mobile,
                          'subject': 'Debited without data',
                        });
                      },
                    ),
                    Divider(
                      color: themeManager.currentTheme == ThemeMode.light
                          ? Colors.black
                          : Colors.white24,
                    ),
                    InkWell(
                      child: listTileStructure('Debited without airtime',
                          'I was debited but the did not get the airtime'),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.contact, arguments: {
                          'name': widget.name,
                          'email': widget.email,
                          'token': widget.token,
                          'mobile': widget.mobile,
                          'subject': 'Debited without airtime',
                        });
                      },
                    ),
                    Divider(
                      color: themeManager.currentTheme == ThemeMode.light
                          ? Colors.black
                          : Colors.white24,
                    ),
                    InkWell(
                      child: listTileStructure(
                          'Issue with cable TV subscription',
                          'Any issue related to cable TV?'),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.contact, arguments: {
                          'name': widget.name,
                          'email': widget.email,
                          'token': widget.token,
                          'mobile': widget.mobile,
                          'subject': 'Issue with cable TV subscription',
                        });
                      },
                    ),
                    Divider(
                      color: themeManager.currentTheme == ThemeMode.light
                          ? Colors.black
                          : Colors.white24,
                    ),
                    InkWell(
                      child: listTileStructure('Internet subscription issue',
                          'Any issue related to Internet subscription'),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.contact, arguments: {
                          'name': widget.name,
                          'email': widget.email,
                          'token': widget.token,
                          'mobile': widget.mobile,
                          'subject': 'Internet subscription issue',
                        });
                      },
                    ),
                    Divider(
                      color: themeManager.currentTheme == ThemeMode.light
                          ? Colors.black
                          : Colors.white24,
                    ),
                    InkWell(
                      child: listTileStructure('Electricity',
                          'Any issue related to Electricity bill'),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.contact, arguments: {
                          'name': widget.name,
                          'email': widget.email,
                          'token': widget.token,
                          'mobile': widget.mobile,
                          'subject': 'Electricity',
                        });
                      },
                    ),
                    Divider(
                      color: themeManager.currentTheme == ThemeMode.light
                          ? Colors.black
                          : Colors.white24,
                    ),
                    InkWell(
                      child: listTileStructure(
                          'Others', 'Having any general issue?'),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteManager.contact, arguments: {
                          'name': widget.name,
                          'email': widget.email,
                          'token': widget.token,
                          'mobile': widget.mobile,
                          'subject': 'Others',
                        });
                      },
                    ),
                    Divider(
                      color: themeManager.currentTheme == ThemeMode.light
                          ? Colors.black
                          : Colors.white24,
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

  Widget listTileStructure(title, subtitle) {
    return Container(
      color: themeManager.currentTheme == ThemeMode.light
          ? ServiceProvider.lightBlueWriteColor
          : ServiceProvider.blueTrackColor,
      child: ListTile(
        title: Text(
          title,
          style: ServiceProvider.contentFont,
        ),
        subtitle: Text(
          subtitle,
          style: themeManager.currentTheme == ThemeMode.light
              ? ServiceProvider.contentFont
              : GoogleFonts.sora().copyWith(
                  color: Colors.grey,
                ),
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: themeManager.currentTheme == ThemeMode.light
              ? ServiceProvider.lightBlueBackGroundColor
              : ServiceProvider.whiteColorShade70,
        ),
      ),
    );
  }
}
