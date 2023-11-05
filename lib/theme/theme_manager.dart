import 'dart:ui';

import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeManager themeManager = ThemeManager();

class ThemeManager with ChangeNotifier {
  final storageKey = "isDarkMode";

  static bool isDarkTheme = false;

  Future<bool> saveThemeOnPref(bool val) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool(storageKey, val);
  }

  getThemeFrmPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return isDarkTheme = pref.getBool(storageKey) ?? false;
  }

  ThemeMode get currentTheme {
    return isDarkTheme ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    saveThemeOnPref(isDarkTheme);

    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.lightBlue,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: ServiceProvider.backGroundColor,
      textTheme: const TextTheme(
          headline1: TextStyle(color: Colors.black),
          headline2: TextStyle(color: Colors.black),
          // headline6: GoogleFonts.sora().copyWith(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
          // subtitle1: GoogleFonts.sora(color: Colors.grey.shade600)
          //     .copyWith(fontSize: 18),

          subtitle1: TextStyle(
            fontWeight: FontWeight.bold, //<-- TextFormField input Bold
          ),
          subtitle2: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0) //<-- TextFormField input Bold
          ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        // hintStyle: GoogleFonts.sora().copyWith(),
        labelStyle: const TextStyle(
            // color: Colors.blue,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            )),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: ServiceProvider.darkNavyBGColor,
        textTheme: TextTheme(
          headline1: const TextStyle(color: Colors.white),
          headline2: const TextStyle(color: Colors.white),
          // bodyText1: GoogleFonts.sora(
          //   color: Colors.white,
          // ).copyWith(

          //     ),
          subtitle1: TextStyle(
            color: ServiceProvider.whiteColorShade70, // <-- TextField color
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
          subtitle2: const TextStyle(
            color: Color.fromRGBO(113, 208, 193, 1),
            fontSize: 16.0,
          ), // <-- TextFormField input color
          bodyText2: const TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red),
        // switchTheme: SwitchThemeData(
        //   trackColor: MaterialStateProperty.all<Color>(Colors.grey),
        //   thumbColor: MaterialStateProperty.all<Color>(Colors.white),
        // ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ServiceProvider.blueTrackColor,
          prefixStyle: TextStyle(color: ServiceProvider.whiteColorShade70),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelStyle: TextStyle(
            color: ServiceProvider.whiteColorShade70,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        cardTheme: CardTheme(color: ServiceProvider.blueTrackColor)
        // cupertinoOverrideTheme:
        // NoDefaultCupertinoThemeData(primaryColor: Colors.white)
        // CupertinoTheme(
        //   data: CupertinoThemeData(textTheme: CupertinoTextThemeData(dateTimePickerTextStyle: TextStyle(color: Colors.white,),),),
        //   child: CupertinoDatePicker(onDateTimeChanged: (){}))
        );
  }
}
