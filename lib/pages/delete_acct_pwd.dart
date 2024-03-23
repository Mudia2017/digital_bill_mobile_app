import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class DeleteAccountPassword extends StatefulWidget {
  final name, email, token;
  const DeleteAccountPassword({
    Key? key,
    required this.name,
    required this.email,
    required this.token,
  }) : super(key: key);

  @override
  _DeleteAccountPasswordState createState() => _DeleteAccountPasswordState();
}

class _DeleteAccountPasswordState extends State<DeleteAccountPassword> {
  @override
  void initState() {
    super.initState();

    initialCall();
  }

  initialCall() {
    emailController.text = widget.email;
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    var serviceProvider = Provider.of<ServiceProvider>(context);
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            child: Form(
                key: _formKey,
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
                      padding: const EdgeInsets.fromLTRB(30, 0, 13, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              height: screenH * 0.053,
                              width: screenW * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color:
                                    themeManager.currentTheme == ThemeMode.light
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
                            'Delete Acct',
                            style: ServiceProvider.pageNameFont,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: [
                                if (ServiceProvider.profileImgFrmServer != '' &&
                                    ServiceProvider.profileImgFrmServer !=
                                        dotenv.env['URL_ENDPOINT'])
                                  serviceProvider.displayProfileImg(context)
                                // CircleAvatar(
                                //     radius: 30,
                                //     backgroundImage: NetworkImage(
                                //         ServiceProvider.profileImgFrmServer))
                                else if (ServiceProvider.temporaryLocalImg !=
                                    null)
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: (ServiceProvider
                                        .temporaryLocalImg!.image),
                                  )
                                else
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: ServiceProvider.lightgray2,
                                    child: Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        Container(
                          padding: const EdgeInsets.only(right: 13),
                          width: screenW * 0.7,
                          child: Text(
                            widget.name,
                            style: GoogleFonts.sarabun(
                              fontWeight: FontWeight.w200,
                            ).copyWith(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color:
                                    themeManager.currentTheme == ThemeMode.light
                                        ? Colors.black87
                                        : Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    pageContentStructure(),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  pageContentStructure() {
    var serviceProvider = Provider.of<ServiceProvider>(context);
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
          child: Column(
            children: [
              Text(
                ' ${widget.name}, to delete this account completely, provide the password related to this account',
                style: ServiceProvider.greetUserFont1,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenH * 0.04,
              ),
              TextFormField(
                enabled: false,
                keyboardType: TextInputType.name,
                controller: emailController,
                style: Theme.of(context).textTheme.subtitle2,
                decoration: InputDecoration(
                    filled: true,
                    labelText: 'Email',
                    hintStyle: GoogleFonts.sora().copyWith(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      emailController.text;
                    });
                  } else {
                    setState(() {
                      emailController.text;
                    });
                  }
                },
              ),
              SizedBox(
                height: screenH * 0.02,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
                style: Theme.of(context).textTheme.subtitle2,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Password',
                  hintStyle: GoogleFonts.sora().copyWith(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    child: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                        color: themeManager.currentTheme == ThemeMode.light
                            ? Colors.black
                            : ServiceProvider.whiteColorShade70),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Old Password is required';
                  }
                  return null;
                },
                obscureText: hidePassword,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      passwordController.text;
                    });
                  } else {
                    setState(() {
                      passwordController.text;
                    });
                  }
                },
              ),
              SizedBox(
                height: screenH * 0.08,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: MaterialButton(
                  disabledColor: Colors.grey.shade300,
                  child: const Text(
                    'Delete Account',
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
                          !emailController.text.contains('@') ||
                          passwordController.text.isEmpty
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            // SEND REQUEST TO DELETE THE ACCT
                            var resp = await serviceProvider.deactivateAcct(
                                context,
                                widget.token,
                                widget.email,
                                passwordController.text);

                            if (resp['isSuccess']) {
                              await serviceProvider.signOut();
                              serviceProvider.showToast(
                                  context, 'Account deleted successful!');
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteManager.welcomePage,
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              // DE-ACTIVATING ACCT WAS NOT SUCCESSFUL

                              serviceProvider.showToast(
                                  context, resp['errorMsg'].toString());
                            }
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
