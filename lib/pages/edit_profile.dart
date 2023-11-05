import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditProfile extends StatefulWidget {
  final String name, token, email, mobile;
  const EditProfile({
    Key? key,
    required this.name,
    required this.token,
    required this.email,
    required this.mobile,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    initialCall();
  }

  var serviceProvider = ServiceProvider();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  var maskFormatter = MaskTextInputFormatter(
      mask: '#### ### ####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  initialCall() {
    nameController.text = widget.name;
    mobileController.text = widget.mobile;
  }

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          // color: ServiceProvider.backGroundColor,
          // height: screenH,
          // width: screenW,
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
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Edit Profile',
                      style: ServiceProvider.pageNameFont,
                    ),
                    Container(),
                  ],
                ),
              ),
              SizedBox(
                height: screenH * 0.009,
              ),
              pageContentStructure(),
            ],
          ),
        ),
      ),
    );
  }

  pageContentStructure() {
    Map data = {
      'isShowAcctBal': false,
      'call': 'editNameMobile',
      'name': nameController.text,
      'mobile': mobileController.text,
    };

    return Container(
      child: Expanded(
          child: Container(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                style: Theme.of(context).textTheme.subtitle2,
                decoration: InputDecoration(
                    filled: true,
                    labelText: 'Name',
                    hintStyle: GoogleFonts.sora().copyWith(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      nameController.text;
                    });
                  } else {
                    setState(() {
                      nameController.text;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: mobileController,
                style: Theme.of(context).textTheme.subtitle2,
                inputFormatters: [maskFormatter],
                decoration: InputDecoration(
                    filled: true,
                    labelText: 'Mobile No',
                    hintStyle: GoogleFonts.sora().copyWith(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mobile number is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      mobileController.text;
                    });
                  } else {
                    setState(() {
                      mobileController.text;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: MaterialButton(
                    disabledColor: Colors.grey.shade300,
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    color: ServiceProvider.innerBlueBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    onPressed: mobileController.text.isEmpty ||
                            nameController.text.isEmpty
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              if (mobileController.text.length < 10) {
                                serviceProvider.popWarningErrorMsg(
                                    context,
                                    'Warning',
                                    'Mobile number is not complete!');
                              } else {
                                FocusManager.instance.primaryFocus?.unfocus();
                                var response =
                                    await serviceProvider.setUpdateAcct(
                                  context,
                                  widget.token,
                                  data,
                                );
                                if (response['isSuccess'] == true) {
                                  await serviceProvider.saveUserInfoToLocalStorage(
                                      nameController.text,
                                      widget.email,
                                      widget.token,
                                      mobileController
                                          .text); // SAVE PROFILE INFO TO LOCAL DB.

                                  ServiceProvider.isEditProfile = true;
                                  serviceProvider.showSuccessToast(
                                      context, 'Update successful');
                                  Navigator.of(context).pop();
                                }
                              }
                            }
                          }),
              )
            ],
          ),
        ),
      )),
    );
  }
}
