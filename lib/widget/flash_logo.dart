import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class FlashLogo extends StatefulWidget {
  const FlashLogo({Key? key}) : super(key: key);

  @override
  State<FlashLogo> createState() => _FlashLogoState();
}

class _FlashLogoState extends State<FlashLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  var serviceProvider = ServiceProvider();
  var name = '';
  var email = '';
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      lowerBound: 1.0,
      upperBound: 10.0,
    );
    _animationController.forward();

    getUserProfileFrmLocal();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (email == '' || name == '') {
          Get.offAndToNamed(RouteManager.welcomePage);
          // Navigator.of(context).pushReplacementNamed(RouteManager.welcomePage);
        } else {
          Get.offAndToNamed(RouteManager.loginWithPin, arguments: {
            'userName': name,
            'email': email,
          });
          // Navigator.of(context).pushReplacementNamed(RouteManager.loginWithPin,
          //     arguments: {'userName': name, 'email': email});
        }
      }
    });
    // Future.delayed(const Duration(seconds: 3)).then(
    //   (value) =>
    //       Navigator.of(context).pushReplacementNamed(RouteManager.welcomePage),
    // );

    super.initState();
  }

  Future getUserProfileFrmLocal() async {
    var hasEmailKey = await storage.read(key: 'email');
    var hasUserKey = await storage.read(key: 'userName');
    bool isLoginCounter = await storage.containsKey(key: 'loginCounter');
    isLoginCounter ? await storage.delete(key: 'loginCounter') : null;
    if (hasEmailKey != null && hasUserKey != null) {
      name = hasUserKey;
      email = hasEmailKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animationController,
          child: Container(
            margin: const EdgeInsets.only(top: 10, left: 25, right: 25),
            width: MediaQuery.of(context).size.width / 11,
            height: 40,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: themeManager.currentTheme == ThemeMode.light
                    ? const AssetImage("images/shopper_logo.png")
                    : const AssetImage("images/white_shopper_logo.png"),
              ),
            ),
          ),
          // const FlutterLogo(
          //   size: 40,
          // ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }
}
