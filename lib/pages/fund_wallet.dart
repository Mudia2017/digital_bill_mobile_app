import 'dart:io';

import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';

class FundWallet extends StatefulWidget {
  final String name, token, email;
  FundWallet(
      {Key? key, required this.name, required this.token, required this.email})
      : super(key: key);

  @override
  State<FundWallet> createState() => _FundWalletState();
}

class _FundWalletState extends State<FundWallet> {
  @override
  void initState() {
    plugin.initialize(publicKey: paystackPublicKey);
    super.initState();

    amtFieldController.text = '₦ ';
  }

  var serviceProvider = ServiceProvider();
  TextEditingController amtFieldController = TextEditingController();
  bool isMaxAmt = false;
  String paymentRef = '';
  bool _hasNotBeenPressed = true;
  bool _hasNotBeenPressed2 = true;

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          color: themeManager.currentTheme == ThemeMode.light
              ? ServiceProvider.lightBlueBackGroundColor
              : ServiceProvider.blueTrackColor,
          height: screenH,
          width: screenW,
          child: Column(
            children: [
              SizedBox(
                height: screenH * 0.023,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(30, 25, 13, 0),
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
                          color: themeManager.currentTheme == ThemeMode.light
                              ? ServiceProvider.innerBlueBackgroundColor
                              : ServiceProvider.darkNavyBGColor,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Add Fund',
                      style: ServiceProvider.pageNameFontBlueBG,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        children: [
                          if (ServiceProvider.profileImgFrmServer != '' &&
                              ServiceProvider.profileImgFrmServer !=
                                  dotenv.env['URL_ENDPOINT'])
                            CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    ServiceProvider.profileImgFrmServer))
                          else if (ServiceProvider.temporaryLocalImg != null)
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  (ServiceProvider.temporaryLocalImg!.image),
                            )
                          else
                            CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  ServiceProvider.innerBlueBackgroundColor,
                              child: const Icon(
                                Icons.person,
                                size: 60,
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
                          color: themeManager.currentTheme == ThemeMode.light
                              ? Colors.white
                              : Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Note: Kindly make payment to any of the account below',
                  style: GoogleFonts.sarabun(
                    fontWeight: FontWeight.w200,
                    fontStyle: FontStyle.italic,
                  ).copyWith(
                    color: ServiceProvider.lightBlueWriteColor,
                    fontSize: 23,
                  ),
                ),
              ),
              SizedBox(
                height: screenH * 0.009,
              ),
              pageContentStructure(context),
              // Flexible(child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  pageContentStructure(context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: themeManager.currentTheme == ThemeMode.light
              ? ServiceProvider.backGroundColor
              : ServiceProvider.darkNavyBGColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: screenH * 0.049,
              ),
              pinField(amtFieldController),
              if (isMaxAmt)
                Text('Maximum digit of 7 figure reached',
                    style: GoogleFonts.sora().copyWith(
                        fontSize: 12, color: ServiceProvider.redWarningColor)),
              SizedBox(
                height: screenH * 0.09,
              ),
              numberKeyPad(),
              SizedBox(
                height: screenH * 0.049,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: MaterialButton(
                        disabledColor: Colors.grey.shade300,
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        color: ServiceProvider.innerBlueBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        onPressed: (amtFieldController.text.length < 5)
                            ? null
                            : () {
                                fundWalletOption();
                              },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  // PIN INPUT FIELD
  pinField(controllerIndex) {
    return Container(
      child: TextFormField(
        controller: controllerIndex,
        enabled: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          fillColor: themeManager.currentTheme == ThemeMode.light
              ? Colors.white
              : ServiceProvider.blueTrackColor,
          filled: true,
          contentPadding: const EdgeInsets.only(
            top: 15,
          ),
        ),
        style: TextStyle(
          fontSize: 35,
          color: themeManager.currentTheme == ThemeMode.light
              ? Colors.black
              : Colors.white70,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  numberKeyPad() {
    return Container(
      // alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                KeyboardNumber(
                  n: 1,
                  onPressed: () {
                    setFigure("1");
                  },
                ),
                KeyboardNumber(
                  n: 2,
                  onPressed: () {
                    setFigure("2");
                  },
                ),
                KeyboardNumber(
                  n: 3,
                  onPressed: () {
                    setFigure("3");
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                KeyboardNumber(
                  n: 4,
                  onPressed: () {
                    setFigure("4");
                  },
                ),
                KeyboardNumber(
                  n: 5,
                  onPressed: () {
                    setFigure("5");
                  },
                ),
                KeyboardNumber(
                  n: 6,
                  onPressed: () {
                    setFigure("6");
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                KeyboardNumber(
                  n: 7,
                  onPressed: () {
                    setFigure("7");
                  },
                ),
                KeyboardNumber(
                  n: 8,
                  onPressed: () {
                    setFigure("8");
                  },
                ),
                KeyboardNumber(
                  n: 9,
                  onPressed: () {
                    setFigure("9");
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 60.0,
                  child: const MaterialButton(
                    onPressed: null,
                    child: SizedBox(),
                  ),
                ),
                KeyboardNumber(
                  n: 0,
                  onPressed: () {
                    setFigure("0");
                  },
                ),
                Container(
                  width: 60.0,
                  child: MaterialButton(
                    splashColor: ServiceProvider.redWarningColor,
                    highlightColor: Colors.blue,
                    height: 60.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    onPressed: () {
                      clearPin();
                    },
                    child: Icon(
                      Icons.backspace_outlined,
                      color: themeManager.currentTheme == ThemeMode.light
                          ? Colors.black
                          : ServiceProvider.whiteColorShade70,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  setFigure(String text) {
    String str = '';
    if (amtFieldController.text.length < 10) {
      if (amtFieldController.text == '₦ ' && text == '0') {
        amtFieldController.text += text;
      } else if (amtFieldController.text.length == 3 && text != '0') {
        if (amtFieldController.text != '₦ 0') {
          amtFieldController.text += (text);
        } else {
          str = amtFieldController.text;
          amtFieldController.text = str.substring(0, str.length - 1);
          amtFieldController.text += text;
        }
      } else if (amtFieldController.text.length == 3 && text != '0') {
        if (amtFieldController.text == '₦ 0') {
          str = amtFieldController.text;
          amtFieldController.text = str.substring(0, str.length - 1);
          amtFieldController.text += text;
        } else {
          amtFieldController.text += (text);
        }
      } else if (amtFieldController.text != '₦ 0') {
        str = amtFieldController.text += text;
        str = _formatNumber(str.replaceAll(RegExp('[^0-9]'), ''));
        amtFieldController.text = '₦ $str';
        if (str.length > 8) {
          setState(() {
            isMaxAmt = true;
          });
        } else {
          // THIS WAS DONE BECAUSE OF THE CONDITION
          // TO ACTIVE OR DE-ACTIVE "DONE BUTTON"
          setState(() {});
        }
      }
    }
  }

  setFigureWithOutCurrencySymbol(String text) {
    // NOT BEEN USED AT THE MOMENT
    String str = '';
    if (amtFieldController.text.length < 10) {
      if (amtFieldController.text.isEmpty && text == '0') {
        amtFieldController.text = text;
      } else if (amtFieldController.text.length == 1 && text == '0') {
        if (amtFieldController.text != '0') {
          amtFieldController.text += _formatNumber(text);
        } else {
          amtFieldController.text = text;
        }
      } else if (amtFieldController.text.length == 1 && text != '0') {
        if (amtFieldController.text == '0') {
          amtFieldController.text = text;
        } else {
          amtFieldController.text += _formatNumber(text);
        }
      } else {
        str = amtFieldController.text += text;
        amtFieldController.text = _formatNumber(str.replaceAll(',', ''));
      }
    }
  }

  removeString(String text) {
    if (text != '₦ ') {
      String str = '';
      str = text.substring(0, text.length - 1);
      if (str != '₦ ') {
        str = str.replaceAll(RegExp('[^0-9]'), '');
        str = _formatNumber(str);
        amtFieldController.text = '₦ $str';
        setState(() {
          isMaxAmt = false;
        });
      } else {
        amtFieldController.text = str;
      }
    }
  }

  clearPin() {
    removeString(amtFieldController.text);
  }

  fundWalletOption() {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return showModalBottomSheet(
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        backgroundColor: themeManager.currentTheme == ThemeMode.light
            ? ServiceProvider.backGroundColor
            : ServiceProvider.darkNavyBGColor,
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (context, setstate) {
              return SizedBox(
                height: screenH - 600,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ServiceProvider.bottomSheetBarHeader,
                    const SizedBox(height: 10),
                    Text(
                      'Options',
                      style: ServiceProvider.pageNameFont,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Divider(
                      color: themeManager.currentTheme == ThemeMode.light
                          ? Colors.black38
                          : Colors.white38,
                      height: 0,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20.0,
                            ),
                            InkWell(
                              splashColor:
                                  themeManager.currentTheme == ThemeMode.light
                                      ? Colors.blue.shade200
                                      : Colors.white12,
                              child: Container(
                                width: screenW - 20,
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: themeManager.currentTheme ==
                                            ThemeMode.light
                                        ? _hasNotBeenPressed
                                            ? Colors.black26
                                            : Colors.blue
                                        : _hasNotBeenPressed
                                            ? Colors.white24
                                            : Colors.blue,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  // color: Colors.black38,
                                ),
                                child: Center(
                                  child: ListTile(
                                    leading: Container(
                                      height: 70,
                                      width: 80,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'images/debit_card.png'),
                                        ),
                                      ),
                                    ),
                                    title: const Text('**** **** **** 8756'),
                                    trailing: Icon(Icons.check_circle,
                                        size: 30,
                                        color: themeManager.currentTheme ==
                                                ThemeMode.light
                                            ? _hasNotBeenPressed
                                                ? Colors.black26
                                                : Colors.blue
                                            : _hasNotBeenPressed
                                                ? Colors.white24
                                                : Colors.blue),
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (_hasNotBeenPressed) {
                                  _hasNotBeenPressed = !_hasNotBeenPressed;
                                }
                                if (_hasNotBeenPressed2) {
                                  _hasNotBeenPressed2 = _hasNotBeenPressed2;
                                } else {
                                  _hasNotBeenPressed2 = !_hasNotBeenPressed2;
                                }
                                setstate(() {});
                                double amt = 0;
                                amt = double.parse(amtFieldController.text
                                    .replaceAll(RegExp('[^0-9]'), ''));
                                chargeCard(amt, 'Debit Card');
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            InkWell(
                              splashColor:
                                  themeManager.currentTheme == ThemeMode.light
                                      ? Colors.blue.shade200
                                      : Colors.white12,
                              child: Container(
                                width: screenW - 20,
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: themeManager.currentTheme ==
                                            ThemeMode.light
                                        ? _hasNotBeenPressed2
                                            ? Colors.black26
                                            : Colors.blue
                                        : _hasNotBeenPressed2
                                            ? Colors.white24
                                            : Colors.blue,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  // color: Colors.black38,
                                ),
                                child: Center(
                                  child: ListTile(
                                    leading: Container(
                                      height: 70,
                                      width: 80,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'images/bank_house.png'),
                                        ),
                                      ),
                                    ),
                                    title: const Text('Bank Transfer'),
                                    trailing: Icon(
                                      Icons.check_circle,
                                      size: 30,
                                      color: themeManager.currentTheme ==
                                              ThemeMode.light
                                          ? _hasNotBeenPressed2
                                              ? Colors.black26
                                              : Colors.blue
                                          : _hasNotBeenPressed2
                                              ? Colors.white24
                                              : Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (_hasNotBeenPressed2) {
                                  setstate(() {
                                    _hasNotBeenPressed2 = !_hasNotBeenPressed2;
                                  });
                                }
                                if (_hasNotBeenPressed) {
                                  _hasNotBeenPressed = _hasNotBeenPressed;
                                } else {
                                  _hasNotBeenPressed = !_hasNotBeenPressed;
                                }
                                setstate(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }).then((value) {
      _hasNotBeenPressed = true;
      _hasNotBeenPressed2 = true;
    });
  }

  // ========== PAYSTACK PAYMENT SYSTEM BEGIN =============================

  String paystackPublicKey = 'pk_test_ba8f7eed26252a042ba331330d205fd0aef1919f';
  bool isGeneratingCode = false;
  final plugin = PaystackPlugin();
  void _showDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return successDialog(context);
      },
    ).then((value) {
      // THIS BLOCK IS OUT PAYSTACK
      amtFieldController.text = '₦ ';
      isMaxAmt = false;
      Navigator.pop(
          context); //  THIS WILL POP BOTTOM SHEET. THIS IS OUT PAYSTACK
      setState(() {});
    });
  }

  Dialog successDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.check_box,
                color: Colors.green,
                size: 90,
              ),
              const SizedBox(height: 15),
              const Text(
                'Payment has successfully',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'been made',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                "Your payment has been successfully",
                style: TextStyle(fontSize: 13),
              ),
              const Text("processed.", style: TextStyle(fontSize: 13)),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.pop(context))
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return errorDialog(context);
      },
    ).then((value) {
      // THIS BLOCK IS OUT PAYSTACK
      amtFieldController.text = '₦ ';
      isMaxAmt = false;
      Navigator.pop(
          context); //  THIS WILL POP BOTTOM SHEET. THIS IS OUT PAYSTACK
      setState(() {});
    });
  }

  Dialog errorDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 90,
              ),
              const SizedBox(height: 15),
              const Text(
                'Failed to process payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                "Error in processing payment, please try again",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const Expanded(child: SizedBox()),
              ElevatedButton(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }

  String _getReference() {
    paymentRef = '';
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    paymentRef =
        'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
    return paymentRef;
  }

  int convertToInt(ranks) {
    return (ranks).round();
  }

  chargeCard(double amt, String paymentMethod) async {
    setState(() {
      isGeneratingCode = !isGeneratingCode;
    });

    // String accessCode = "sk_test_58e5b7fab484bda3aab4289ce5a50345209c8dac";

    setState(() {
      isGeneratingCode = !isGeneratingCode;
    });

    Charge charge = Charge()
      ..amount = convertToInt(amt * 100)
      ..reference = _getReference()
      // ..accessCode = accessCode
      ..email = widget.email;

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
      logo: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/shopper_logo.png'),
          ),
        ),
      ),
    );

    if (response.status == true) {
      // ============ CREATE THE RECORD ON THE SERVER ================
      Map record = {
        'ref': response.reference,
        'credit': amt,
        'status': response.status,
      };
      var serverRes = await serviceProvider.creditCustomerWallet(
          context, record, widget.token);
      if (serverRes['isSuccess'] == true) {
        ServiceProvider.acctBal =
            (double.parse(ServiceProvider.acctBal) + serverRes['amt'])
                .toString();
      }
      _showDialog();
    } else {
      _showErrorDialog();
    }
  }

  // ===================== PAY STACK PAYMENT ENDS HERE ========================

}

class CardLayout extends StatefulWidget {
  const CardLayout({Key? key}) : super(key: key);

  @override
  _CardLayoutState createState() => _CardLayoutState();
}

class _CardLayoutState extends State<CardLayout> {
  var serviceProvider = ServiceProvider();
  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext cxt, int x) {
          return TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: 0.0),
              duration: const Duration(seconds: 1),
              curve: Curves.ease,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(
                    value * 150,
                    0.0,
                  ),
                  child: child,
                );
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Stack(
                  // alignment: AlignmentDirectional.center,
                  // clipBehavior: Clip.antiAlias,
                  // fit: StackFit.loose,
                  children: [
                    Container(
                        color: Colors.amber,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Image.asset('images/electronic_card.png')),
                    bankName('BANK NAME'),
                    accountNo('1234567890'),
                    acctName('NAME OF ACCOUNT.'),
                  ],
                ),
              ));
        });
  }

  bankName(_bankName) {
    return Positioned(
      top: 10,
      left: 30,
      right: 5,
      child: Text(
        _bankName,
        style: ServiceProvider.cardFontBold7,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  accountNo(_acctNo) {
    return Positioned(
      bottom: 90,
      left: 20,
      child: Row(
        children: [
          Text(
            _acctNo,
            style: GoogleFonts.chakraPetch().copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 30,
              letterSpacing: 4.0,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: _acctNo));
              serviceProvider.showToast(context, 'Copied to clipboard');
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ServiceProvider.lightBlueWriteColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: const Icon(
                Icons.copy_all,
                color: Colors.white,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }

  acctName(_acctName) {
    return Positioned(
      right: 5,
      top: 180,
      left: 25,
      bottom: 2,
      child: Text(
        _acctName,
        style: GoogleFonts.chakraPetch().copyWith(
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontSize: 24,
          letterSpacing: 4.0,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
