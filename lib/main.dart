import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/pages/home_page.dart';
import 'package:digital_mobile_bill/pages/login.dart';
import 'package:digital_mobile_bill/pages/login_with_pin.dart';
import 'package:digital_mobile_bill/pages/register.dart';
import 'package:digital_mobile_bill/pages/settings.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:digital_mobile_bill/widget/flash_logo.dart';
import 'package:flutter/material.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (value) async {
      await themeManager.getThemeFrmPref(); // SET THE CURRENT THEME

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: ServiceProvider()),
          ],
          child: ChangeNotifierProvider(
              create: (context) => ServiceProvider(),
              // builder: (context) => ServiceProvider(),
              child: const MyApp()),
        ),
      );
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    themeManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeManager.lightTheme,
      darkTheme: ThemeManager.darkTheme,
      themeMode: ThemeManager().currentTheme,
      home: const GetXRoute(),
      debugShowCheckedModeBanner: false,
    );
  }
}
