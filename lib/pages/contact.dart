import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Contact extends StatefulWidget {
  final String name, token, email, mobile, subject;
  const Contact({
    Key? key,
    required this.name,
    required this.token,
    required this.email,
    required this.mobile,
    required this.subject,
  }) : super(key: key);

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailBodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
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
                        FocusManager.instance.primaryFocus
                            ?.unfocus(); // USED TO DISMISS KEYBOARD FROM SCREEN
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
                      'Contact Us',
                      style: ServiceProvider.pageNameFont,
                    ),
                    Container(),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '${widget.name}, your email is important to us.',
                  style: ServiceProvider.greetUserFont1,
                ),
              ),
              SizedBox(
                height: screenH * 0.009,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: emailHeader()),
              Expanded(
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: emailBody())),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailHeader() {
    double screenH = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          color: themeManager.currentTheme == ThemeMode.light
              ? Colors.black.withOpacity(0.05)
              : ServiceProvider.blueTrackColor,
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: const [
              Text('To: '),
              Text('Digital Bill Customer Service')
            ],
          ),
          SizedBox(
            height: screenH * 0.004,
          ),
          Row(
            children: [
              const Text('From: '),
              Text(widget.name),
            ],
          ),
          SizedBox(
            height: screenH * 0.004,
          ),
          Row(
            children: [
              const Text('Subject: '),
              Text(widget.subject),
            ],
          ),
        ],
      ),
    );
  }

  Widget emailBody() {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    double screenH = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          SizedBox(
            height: screenH * 0.04,
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  maxLines: 10,
                  minLines: 10,
                  keyboardType: TextInputType.multiline,
                  controller: emailBodyController,
                  style: Theme.of(context).textTheme.subtitle2,
                  decoration: InputDecoration(
                      filled: true,
                      // labelText: 'Body',
                      hintStyle: GoogleFonts.sora().copyWith(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email body can not be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        emailBodyController.text;
                      });
                    } else {
                      setState(() {
                        emailBodyController.text;
                      });
                    }
                  },
                ),
              ),
              Positioned(
                  left: 30,
                  top: -7,
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    color: themeManager.currentTheme == ThemeMode.light
                        ? ServiceProvider.backGroundColor
                        : const Color.fromRGBO(0, 22, 38, 1),
                    child: Text(
                      'Email body',
                      style: TextStyle(
                          color: themeManager.currentTheme == ThemeMode.light
                              ? Colors.black
                              : ServiceProvider.whiteColorShade70,
                          fontSize: 12),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: screenH * 0.04,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: MaterialButton(
                disabledColor: Colors.grey.shade300,
                child: const Text(
                  'Send Email',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                color: ServiceProvider.innerBlueBackgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                onPressed: (emailBodyController.text.isEmpty)
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (emailBodyController.text == '') {
                            serviceProvider.popWarningErrorMsg(context,
                                'Warning', 'Email body most not be empty!');
                          } else {
                            // SEND EMAIL
                            FocusManager.instance.primaryFocus
                                ?.unfocus(); // USED TO DISMISS KEYBOARD FROM SCREEN
                            var resp = await serviceProvider.sendEmail(
                                context,
                                widget.name,
                                widget.subject,
                                emailBodyController.text);
                            if (resp['statusCode'] == 200) {
                              emailBodyController.clear();
                              serviceProvider.showSuccessToast(
                                  context, 'Email sent');
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            } else if (resp['statusCode'] == '') {
                              serviceProvider.popWarningErrorMsg(context,
                                  'Error', resp['errorMsg'].toString());
                            } else {
                              serviceProvider.popWarningErrorMsg(
                                  context,
                                  'Error',
                                  'An error have occure while sending your email.\nCheck your internet connection and try again.');
                            }
                          }
                        }
                      },
              ))
        ],
      ),
    );
  }
}
