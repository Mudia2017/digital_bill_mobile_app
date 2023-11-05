import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EndUserAgreement extends StatelessWidget {
  const EndUserAgreement({Key? key}) : super(key: key);

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
                    'License Agreement',
                    style: ServiceProvider.pageNameFont,
                  ),
                  Container(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Text(
                  ServiceProvider.userAgreement,
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w200,
                  ).copyWith(
                      fontSize: 14,
                      color: themeManager.currentTheme == ThemeMode.light
                          ? Colors.black87
                          : Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
