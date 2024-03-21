import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

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
    var serviceProvider = Provider.of<ServiceProvider>(context);
    return Scaffold(
      // backgroundColor: ServiceProvider.backGroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            child: Column(
              children: [
                Visibility(
                  child: serviceProvider.noInternetConnectionBadge(context),
                  visible: Provider.of<InternetConnectionStatus>(context) ==
                      InternetConnectionStatus.disconnected,
                ),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Having issues loggin? Don't worry...",
                    style: GoogleFonts.overlock().copyWith(
                      color: Colors.grey,
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Enter your email address associated with your account",
                    style: GoogleFonts.overlock().copyWith(
                      color: Colors.grey,
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Form(
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
                ),
                SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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

                              // CHECK IF THERE IS INTERNET CONNECTION
                              Provider.of<InternetConnectionStatus>(context,
                                          listen: false) ==
                                      InternetConnectionStatus.disconnected
                                  ? serviceProvider.popWarningErrorMsg(
                                      context,
                                      'Internet Connection',
                                      'No internet connection on your device!')
                                  :
                                  // RESET PASSWORD
                                  print('SEND REQUEST TO RESET PASSWORD');
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
