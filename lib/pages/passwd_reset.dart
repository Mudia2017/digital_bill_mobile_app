import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordReset extends StatefulWidget {
  PasswordReset({Key? key}) : super(key: key);

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: ServiceProvider.backGroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                        child: Transform.rotate(
                          angle: 150,
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 45,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Reset Password',
                      style: ServiceProvider.pageNameFont,
                    ),
                    Container(),
                  ],
                ),
              ),
              Text(
                "Having issues loggin? Don't worry...",
                style: GoogleFonts.overlock().copyWith(
                  color: Colors.grey,
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                "Enter your email address associated with your account",
                style: GoogleFonts.overlock().copyWith(
                  color: Colors.grey,
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  style: Theme.of(context).textTheme.subtitle2,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                  onChanged: (element) {
                    if (element.isNotEmpty && element.contains('@')) {
                      setState(() {
                        emailController.text;
                      });
                    } else if (!element.contains('@')) {
                      setState(() {
                        emailController.text;
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: MaterialButton(
                  disabledColor: Colors.grey.shade300,
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  color: ServiceProvider.redWarningColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onPressed: emailController.text.isEmpty ||
                          !emailController.text.contains('@')
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
