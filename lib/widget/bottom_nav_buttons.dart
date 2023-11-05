// // import 'package:digital_mobile_bill/route/route.dart';
// import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:get/get.dart';
// // import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomProgressHUD extends StatefulWidget {
  const CustomProgressHUD({Key? key}) : super(key: key);

  @override
  _CustomProgressHUDState createState() => _CustomProgressHUDState();
}

class _CustomProgressHUDState extends State<CustomProgressHUD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Center(
          child: Container(
              height: 80,
              width: 80,
              color: Colors.black54,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3.0,
              )),
        ),
      ),
    );
  }
}
