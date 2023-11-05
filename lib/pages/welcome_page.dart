import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({Key? key}) : super(key: key);

  var serviceProvider = ServiceProvider();

  @override
  Widget build(BuildContext context) {
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
        body: Container(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to DigitalBill.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Text(
                  'Automate and pay your subscription',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Text(
                  'bills the smart and easy way',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Text(
                  'with a secure system.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: MaterialButton(
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      color: ServiceProvider.innerBlueBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      onPressed: () {
                        Get.toNamed(RouteManager.register);
                        // Navigator.of(context).pushNamed(RouteManager.register);
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.toNamed(
                        RouteManager.login,
                        arguments: {'isLastStack': false},
                      );
                      // Navigator.of(context).pushNamed(RouteManager.login);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: ServiceProvider.innerBlueBackgroundColor),
                    ),
                    style: OutlinedButton.styleFrom(
                        shape: (RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0))),
                        side: BorderSide(
                            color: ServiceProvider.innerBlueBackgroundColor)),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                const Text(
                  'By creating an account or logging in, you agree to our terms and conditions.',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                InkWell(
                  child: const Text(
                    'Learn more about our cookies and privacy policy',
                    style: TextStyle(fontSize: 10, color: Colors.blueAccent),
                  ),
                  onTap: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
