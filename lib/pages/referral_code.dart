import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ReferralCode extends StatefulWidget {
  final String name;
  const ReferralCode({Key? key, required this.name}) : super(key: key);

  @override
  _ReferralCodeState createState() => _ReferralCodeState();
}

class _ReferralCodeState extends State<ReferralCode>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    initalCall();
  }

  var name, email, token, mobile;
  List toJsonReferrals = [];
  double refTotal = 0;
  int indexTab = 0;

  initalCall() async {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    Map userRec = await serviceProvider.getUserProfile(context);
    if (userRec.isNotEmpty) {
      setState(() {
        token = userRec['token'];
        name = userRec['name'];
        email = userRec['email'];
        mobile = userRec['mobile'];
      });
    }
    Map referrals = await serviceProvider.getReferrals(
        context, token!, email, '', 'getReferral');
    if (referrals['isSuccess'] == false) {
      serviceProvider.popWarningErrorMsg(
          context, 'Error', referrals['errorMsg'].toString());
    } else if (referrals['isSuccess'] == true) {
      setState(() {
        toJsonReferrals = referrals['jsonRef'];
      });
      calculateReferral(toJsonReferrals);
    }
  }

  calculateReferral(List refRecord) {
    refTotal = 0;
    for (var x = 0; x < refRecord.length; x++) {
      if (refRecord[x]['is_payment_verified'] &&
          refRecord[x]['is_referral_process_complete'] == false) {
        refTotal += (refRecord[x]['bonus_amt']);
      }
    }
    setState(() {});
  }

  share(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;

    Share.share(ServiceProvider.urReferralCode,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    var serviceProvider = Provider.of<ServiceProvider>(context);
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;

    TabController tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: indexTab,
    );
    return Scaffold(
      body: Container(
          // color: ServiceProvider.backGroundColor,
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
                  'Referral',
                  style: ServiceProvider.pageNameFont,
                ),
                Container(),
              ],
            ),
          ),
          SizedBox(
            height: screenH * 0.009,
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                  onTap: (index) {
                    print("Index of Tab:" + index.toString());
                  },
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ServiceProvider.innerBlueBackgroundColor,
                  ),
                  controller: tabController,
                  isScrollable: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 30),
                  tabs: const [
                    Tab(
                      child: Text('Invite a friend'),
                    ),
                    Tab(
                      child: Text('Referral Status'),
                    )
                  ]),
            ),
          ),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              // FIRST TAB BAR PAGE...
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenH * 0.003,
                    ),
                    Image.asset("images/referralLogo.png"),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Get bonus when you invite a friend using your referral code.",
                        style: GoogleFonts.sarabun().copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          // color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Start sharing your referral code with your network through various social media. Once your referrals meet the conditions set by the company (e.g., sign up and deposit), you should receive your referral bonus. This reward can vary based on the company's policy. Share that unique code now!!!",
                        style: GoogleFonts.sarabun(
                          fontWeight: FontWeight.w200,
                        ).copyWith(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: screenH * 0.023,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'Your referral code',
                            style: GoogleFonts.sora().copyWith(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      decoration: BoxDecoration(
                          color: themeManager.currentTheme == ThemeMode.light
                              ? Colors.black.withOpacity(0.05)
                              : ServiceProvider.blueTrackColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: -1.0, end: 0.0),
                            curve: Curves.easeInOut,
                            duration: const Duration(seconds: 1),
                            child: ListTile(
                              title: Text(
                                ServiceProvider.urReferralCode,
                                style: GoogleFonts.sora().copyWith(),
                              ),
                              trailing: InkWell(
                                child: Container(
                                  height: screenH * 0.043,
                                  width: screenW * 0.22,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ServiceProvider
                                        .innerBlueBackgroundColor,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Copy Code',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text: ServiceProvider.urReferralCode));
                                  serviceProvider.showToast(
                                      context, 'Copied to clipboard');
                                },
                              ),
                            ),
                            builder: (context, value, child) {
                              indexTab = 0;
                              return Transform.translate(
                                offset: Offset(value * 150, 0.0),
                                child: child,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenH * 0.023,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: MaterialButton(
                        disabledColor: Colors.grey.shade300,
                        child: const Text(
                          'Share Code',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        color: ServiceProvider.innerBlueBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        onPressed: () {
                          share(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // SECOND TAB BAR PAGE...
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white70,
                      ),
                    ),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 1.0, end: 0.0),
                      curve: Curves.easeInOut,
                      duration: const Duration(seconds: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('₦ '),
                          Text(
                            refTotal.toString() == 'null'
                                ? ''
                                : serviceProvider.numberFormater(refTotal),
                            style: GoogleFonts.chakraPetch(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ).copyWith(),
                          )
                        ],
                      ),
                      builder: (context, value, child) {
                        indexTab = 1;
                        return Transform.translate(
                          offset: Offset(value * 150, 0.0),
                          child: child,
                        );
                      },
                    ),
                  ),
                  customeListView(toJsonReferrals),
                ],
              ),
            ]),
          )
        ],
      )),
    );
  }

  Widget customeListView(referrals) {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    return Expanded(
      child: referrals.isNotEmpty
          ? ListView.builder(
              itemCount: referrals.length,
              itemBuilder: (BuildContext cxt, int x) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 1.0, end: 0.0),
                  duration: const Duration(seconds: 1),
                  curve: Curves.ease,
                  builder: (context, value, child) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      height: 90,
                      child: Transform.translate(
                        offset: Offset(
                          value * 150,
                          0.0,
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: Card(
                    color: themeManager.currentTheme == ThemeMode.light
                        ? Colors.white
                        : ServiceProvider.blueTrackColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    elevation: 0,
                    child: Center(
                      child: ListTile(
                        leading: Stack(
                          children: [
                            if (referrals[x]['profileImg'] !=
                                dotenv.env['URL_ENDPOINT'])
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(referrals[x]['profileImg']),
                              )
                            else
                              CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      ServiceProvider.innerBlueBackgroundColor,
                                  child: const Icon(
                                    Icons.person,
                                    size: 55,
                                  ))
                          ],
                        ),
                        title: Text(
                          referrals[x]['referredCusName'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.sora().copyWith(
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text(
                          (referrals[x]['created_date_time']),
                          style: GoogleFonts.sarabun(
                            fontWeight: FontWeight.w200,
                          ).copyWith(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey),
                        ),
                        trailing: Column(
                          children: [
                            if (referrals[x]['referral_process'] ==
                                'Processing')
                              SizedBox(
                                width: 70,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.all(3),
                                    side: const BorderSide(
                                      color: Color.fromRGBO(195, 98, 49, 1),
                                    ),
                                  ),
                                  onPressed: () {
                                    serviceProvider.popDialogMsgAlignLeft(
                                        context,
                                        'Info',
                                        'Name: ${referrals[x]['referredCusName']}\nBonus Amount: ${referrals[x]['bonus_amt']}\nDescription: Yet to make initial deposit.');
                                  },
                                  child: Text(
                                    referrals[x]['referral_process'],
                                    style: const TextStyle(
                                      color: Color.fromRGBO(195, 98, 49, 1),
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              )
                            else if (referrals[x]['referral_process'] ==
                                    'Transfer' &&
                                referrals[x]['is_payment_verified'] == true)
                              SizedBox(
                                width: 70,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.all(5),
                                    side: BorderSide(
                                      color: ServiceProvider
                                          .innerBlueBackgroundColor,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (referrals[x]['referral_process'] ==
                                            'Transfer' &&
                                        referrals[x]['is_payment_verified'] ==
                                            true &&
                                        referrals[x]['bonus_amt'] > 0 &&
                                        referrals[x][
                                                'is_referral_process_complete'] ==
                                            false) {
                                      var inputResp = await serviceProvider
                                          .popWarningConfirmActionYesNo(
                                        context,
                                        'Info',
                                        "Bonus Amount: NGN ${referrals[x]['bonus_amt']}\nTransfer fund to your wallet?",
                                        Colors.grey,
                                      );
                                      if (inputResp != null &&
                                          inputResp != false) {
                                        // UPDATE THE SERVER TABLE WITH REFERRAL
                                        // PROCESS COMPLETE TO TRUE AND RETURN RESPONSE.
                                        Map refer =
                                            await serviceProvider.getReferrals(
                                                context,
                                                token!,
                                                email,
                                                referrals[x]['id'],
                                                'updateReferral');
                                        if (refer['isSuccess']) {
                                          setState(() {
                                            // RECALCULATE TOTAL BONUS & DISPLAY
                                            //IT ON REFERRAL PAGE
                                            calculateReferral(
                                                refer['updatedRef']);
                                            // GET THE ACCT BAL & ADD THE BONUS
                                            // AMT TRANSFERED TO IT
                                            double amt = 0;
                                            amt = double.parse(
                                                ServiceProvider.acctBal);
                                            amt += referrals[x]['bonus_amt'];
                                            ServiceProvider.acctBal =
                                                amt.toString();
                                            // UPDATE THE OLD REFERRAL LIST WITH
                                            // THE NEW ONCE.
                                            toJsonReferrals =
                                                refer['updatedRef'];
                                          });
                                          serviceProvider.showSuccessToast(
                                              context,
                                              'Internal transfer successful.');
                                        } else {
                                          serviceProvider.popWarningErrorMsg(
                                            context,
                                            'Error',
                                            refer['isSuccess'].toString(),
                                          );
                                        }
                                      }
                                    } else {
                                      serviceProvider.popDialogMsgAlignLeft(
                                        context,
                                        'Info',
                                        'Name: ${referrals[x]['referredCusName']}\nBonus Amount: ${referrals[x]['bonus_amt']}\nDescription: This amount have been transferred to your wallet.',
                                      );
                                    }
                                  },
                                  child: Text(
                                    referrals[x]['referral_process'],
                                    style: TextStyle(
                                      color: ServiceProvider
                                          .innerBlueBackgroundColor,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              )
                            else if (referrals[x]['referral_process'] ==
                                'Complete')
                              SizedBox(
                                width: 70,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.all(5),
                                    side: BorderSide(
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                  onPressed: () {
                                    serviceProvider.popDialogMsgAlignLeft(
                                      context,
                                      'Info',
                                      'Name: ${referrals[x]['referredCusName']}\nBonus Amount: ${referrals[x]['bonus_amt']}\nDescription: This amount have been transferred to your wallet.',
                                    );
                                  },
                                  child: Text(
                                    referrals[x]['referral_process'],
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              )
                            else
                              SizedBox(
                                width: 70,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.all(5),
                                    side: BorderSide(
                                      color: Colors.red.shade800,
                                    ),
                                  ),
                                  onPressed: () {
                                    serviceProvider.popDialogMsgAlignLeft(
                                      context,
                                      'Info',
                                      "Name: ${referrals[x]['referredCusName']}\nBonus Amount: ${referrals[x]['bonus_amt']}\nDescription: Customer's transferred amount yet to be verified.",
                                    );
                                  },
                                  child: Text(
                                    referrals[x]['referral_process'],
                                    style: TextStyle(
                                      color: ServiceProvider.redWarningColor,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.receipt_rounded, color: Colors.grey, size: 80),
                Text(
                  'No Record',
                  style: ServiceProvider.warningFont,
                ),
              ],
            ),
    );
  }
}

// class ReferralLog extends StatelessWidget {
//   List referrals;
//   final token;
//   final email;
//   ReferralLog(
//       {Key? key,
//       required this.referrals,
//       required this.token,
//       required this.email})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var serviceProvider = Provider.of<ServiceProvider>(context);
//     return Expanded(
//       child: referrals.isNotEmpty
//           ? ListView.builder(
//               itemCount: referrals.length,
//               itemBuilder: (BuildContext cxt, int x) {
//                 return TweenAnimationBuilder<double>(
//                   tween: Tween(begin: 1.0, end: 0.0),
//                   duration: const Duration(seconds: 1),
//                   curve: Curves.ease,
//                   builder: (context, value, child) {
//                     return Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                       height: 90,
//                       child: Transform.translate(
//                         offset: Offset(
//                           value * 150,
//                           0.0,
//                         ),
//                         child: child,
//                       ),
//                     );
//                   },
//                   child: Card(
//                     color: themeManager.currentTheme == ThemeMode.light
//                         ? Colors.white
//                         : ServiceProvider.blueTrackColor,
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(20),
//                       ),
//                     ),
//                     elevation: 0,
//                     child: Center(
//                       child: ListTile(
//                         leading: Stack(
//                           children: [
//                             if (referrals[x]['profileImg'] !=
//                                 'http://192.168.43.50:8000')
//                               CircleAvatar(
//                                 radius: 30,
//                                 backgroundImage:
//                                     NetworkImage(referrals[x]['profileImg']),
//                               )
//                             else
//                               CircleAvatar(
//                                   radius: 30,
//                                   backgroundColor:
//                                       ServiceProvider.innerBlueBackgroundColor,
//                                   child: const Icon(
//                                     Icons.person,
//                                     size: 55,
//                                   ))
//                           ],
//                         ),
//                         title: Text(
//                           referrals[x]['referredCusName'],
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.sora().copyWith(
//                             fontSize: 13,
//                           ),
//                         ),
//                         subtitle: Text(
//                           (referrals[x]['created_date_time']),
//                           style: GoogleFonts.sarabun(
//                             fontWeight: FontWeight.w200,
//                           ).copyWith(
//                               fontSize: 12,
//                               fontStyle: FontStyle.italic,
//                               color: Colors.grey),
//                         ),
//                         trailing: Column(
//                           children: [
//                             if (referrals[x]['referral_process'] ==
//                                 'Processing')
//                               SizedBox(
//                                 width: 70,
//                                 child: OutlinedButton(
//                                   style: OutlinedButton.styleFrom(
//                                     padding: const EdgeInsets.all(3),
//                                     side: const BorderSide(
//                                       color: Color.fromRGBO(195, 98, 49, 1),
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     serviceProvider.popDialogMsgAlignLeft(
//                                         context,
//                                         'Info',
//                                         'Name: ${referrals[x]['referredCusName']}\nBonus Amount: ${referrals[x]['bonus_amt']}\nDescription: Yet to make initial deposit');
//                                   },
//                                   child: Text(
//                                     referrals[x]['referral_process'],
//                                     style: const TextStyle(
//                                       color: Color.fromRGBO(195, 98, 49, 1),
//                                       // fontWeight: FontWeight.bold,
//                                       fontSize: 11,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             else if (referrals[x]['referral_process'] ==
//                                     'Transfer' &&
//                                 referrals[x]['is_payment_verified'] == true)
//                               SizedBox(
//                                 width: 70,
//                                 child: OutlinedButton(
//                                   style: OutlinedButton.styleFrom(
//                                     padding: const EdgeInsets.all(5),
//                                     side: BorderSide(
//                                       color: ServiceProvider
//                                           .innerBlueBackgroundColor,
//                                     ),
//                                   ),
//                                   onPressed: () async {
//                                     if (referrals[x]['referral_process'] ==
//                                             'Transfer' &&
//                                         referrals[x]['is_payment_verified'] ==
//                                             true &&
//                                         referrals[x]['bonus_amt'] > 0 &&
//                                         referrals[x][
//                                                 'is_referral_process_complete'] ==
//                                             false) {
//                                       var inputResp = await serviceProvider
//                                           .popWarningConfirmActionYesNo(
//                                         context,
//                                         'Info',
//                                         "Are you sure you want to transfer your referral bonus of NGN ${referrals[x]['bonus_amt']} to your wallet? ",
//                                         Colors.grey,
//                                       );
//                                       if (inputResp != null &&
//                                           inputResp != false) {
//                                         // UPDATE THE SERVER TABLE WITH REFERRAL
//                                         // PROCESS COMPLETE TO TRUE AND RETURN RESPONSE.
//                                         Map refer =
//                                             await serviceProvider.getReferrals(
//                                                 context,
//                                                 token!,
//                                                 email,
//                                                 referrals[x]['id'],
//                                                 'updateReferral');
//                                         if (refer['isSuccess']) {
//                                           serviceProvider.showSuccessToast(
//                                               context,
//                                               'Internal transfer successful.');
//                                         } else {
//                                           serviceProvider.popWarningErrorMsg(
//                                             context,
//                                             'Error',
//                                             refer['isSuccess'].toString(),
//                                           );
//                                         }
//                                       }
//                                     } else {
//                                       serviceProvider.popDialogMsgAlignLeft(
//                                         context,
//                                         'Info',
//                                         'Name: ${referrals[x]['referredCusName']}\nBonus Amount: ${referrals[x]['bonus_amt']}\nDescription: This amount have been transferred to your wallet',
//                                       );
//                                     }
//                                   },
//                                   child: Text(
//                                     referrals[x]['referral_process'],
//                                     style: TextStyle(
//                                       color: ServiceProvider
//                                           .innerBlueBackgroundColor,
//                                       // fontWeight: FontWeight.bold,
//                                       fontSize: 11,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             else if (referrals[x]['referral_process'] ==
//                                 'Complete')
//                               SizedBox(
//                                 width: 70,
//                                 child: OutlinedButton(
//                                   style: OutlinedButton.styleFrom(
//                                     padding: const EdgeInsets.all(5),
//                                     side: BorderSide(
//                                       color: Colors.green.shade700,
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     serviceProvider.popDialogMsgAlignLeft(
//                                       context,
//                                       'Info',
//                                       'Name: ${referrals[x]['referredCusName']}\nBonus Amount: ${referrals[x]['bonus_amt']}\nDescription: This amount have been transferred to your wallet',
//                                     );
//                                   },
//                                   child: Text(
//                                     referrals[x]['referral_process'],
//                                     style: TextStyle(
//                                       color: Colors.green.shade700,
//                                       // fontWeight: FontWeight.bold,
//                                       fontSize: 11,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             else
//                               SizedBox(
//                                 width: 70,
//                                 child: OutlinedButton(
//                                   style: OutlinedButton.styleFrom(
//                                     padding: const EdgeInsets.all(5),
//                                     side: BorderSide(
//                                       color: Colors.red.shade800,
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     serviceProvider.popDialogMsgAlignLeft(
//                                       context,
//                                       'Info',
//                                       "Name: ${referrals[x]['referredCusName']}\nBonus Amount: ${referrals[x]['bonus_amt']}\nDescription: Customer's transferred amount yet to be verified.",
//                                     );
//                                   },
//                                   child: Text(
//                                     referrals[x]['referral_process'],
//                                     style: TextStyle(
//                                       color: ServiceProvider.redWarningColor,
//                                       // fontWeight: FontWeight.bold,
//                                       fontSize: 11,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               })
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.receipt_rounded, color: Colors.grey, size: 80),
//                 Text(
//                   'No Record',
//                   style: ServiceProvider.warningFont,
//                 ),
//               ],
//             ),
//     );
//   }
// }
