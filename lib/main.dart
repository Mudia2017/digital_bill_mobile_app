import 'dart:async';

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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
//   // Check internet connection with singleton (no custom values allowed)
//   await execute(InternetConnectionChecker());

//   // Create customized instance which can be registered via dependency injection
//   final InternetConnectionChecker customInstance =
//       InternetConnectionChecker.createInstance(
//     checkTimeout: const Duration(seconds: 1),
//     checkInterval: const Duration(seconds: 1),
//   );

//   // Check internet connection with created instance
//   await execute(customInstance);
// }

// Future<void> execute(
//   InternetConnectionChecker internetConnectionChecker,
// ) async {
//   // Simple check to see if we have Internet
//   // ignore: avoid_print
//   print('''The statement 'this machine is connected to the Internet' is: ''');
//   final bool isConnected = await InternetConnectionChecker().hasConnection;
//   // ignore: avoid_print
//   print(
//     isConnected.toString(),
//   );
//   // returns a bool

//   // actively listen for status updates
//   final StreamSubscription<InternetConnectionStatus> listener =
//       InternetConnectionChecker().onStatusChange.listen(
//     (InternetConnectionStatus status) {
//       switch (status) {
//         case InternetConnectionStatus.connected:
//           // ignore: avoid_print
//           print('Data connection is available.');
//           break;
//         case InternetConnectionStatus.disconnected:
//           // ignore: avoid_print
//           print('You are disconnected from the internet.');
//           break;
//       }
//     },
//   );

//   // close listener after 30 seconds, so the program doesn't run forever
//   await Future<void>.delayed(const Duration(seconds: 30));
//   await listener.cancel();

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
    return StreamProvider<InternetConnectionStatus>(
      initialData: InternetConnectionStatus.connected,
      create: (_) {
        return InternetConnectionChecker().onStatusChange;
      },
      child: MaterialApp(
        theme: ThemeManager.lightTheme,
        darkTheme: ThemeManager.darkTheme,
        themeMode: ThemeManager().currentTheme,
        home: const GetXRoute(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
