import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/components/to_pdf.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    initalCall();
  }

  final ToPDF _toPDF = ToPDF();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  var name, email, token, mobile;
  List transLog = [];
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
    Map resp = await serviceProvider.transAcctHistory(context, token!);
    if (resp['isSuccess'] == false) {
      serviceProvider.popWarningErrorMsg(
          context, 'Error', resp['errorMsg'].toString());
    } else if (resp['isSuccess'] == true) {
      setState(() {
        transLog = resp['transLog'];
      });
    }
  }

  getCurrentDate() {
    String currentDate = DateFormat("MMMM, dd, yyyy").format(DateTime.now());
    return currentDate;
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
        body: SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          bool isResponse = await serviceProvider.popWarningConfirmActionYesNo(
              context,
              'Warning',
              'Do you want to exit the app?',
              Colors.white60);
          if (isResponse == true) {
            SystemNavigator.pop();
          }
          return Future.value(false);
        },
        child: Container(
          // color: ServiceProvider.backGroundColor,
          height: screenH,
          width: screenW,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Text(
                    'History',
                    style: ServiceProvider.pageNameFont,
                  ),

                  // THIS WAS SUPPOSE TO BE SETTINGS TO FILTER TRANSACTION LOG
                  // BUT, I WAS UNABLE TO FIGURE OUT WHEN THE TABS IS SWIPE
                  // FROM LEFT TO RIGHT SO AS TO HIDE OR MAKE IT VISIBLE.
                  // IT WILL ONLY BE NEEDED ON THE TRANSACTION LOG.

                  // InkWell(
                  //   onTap: () {
                  //     filter();
                  //   },
                  //   child: Container(
                  //     height: screenH * 0.053,
                  //     width: screenW * 0.12,
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: ServiceProvider.innerBlueBackgroundColor,
                  //       ),
                  //       borderRadius:
                  //           const BorderRadius.all(Radius.circular(10)),
                  //     ),
                  //     child: Icon(
                  //       Icons.settings_outlined,
                  //       color: ServiceProvider.innerBlueBackgroundColor,
                  //       size: 30,
                  //     ),
                  //   ),
                  // )
                  Container(),
                ],
              ),
              SizedBox(
                height: screenH * 0.008,
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
                        // It gives current selected index 0 for First Tab , second 1, like....
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
                          child: Text('Transaction log'),
                        ),
                        Tab(
                          child: Text('Account statement'),
                        )
                      ]),
                ),
              ),
              Expanded(
                  child: TabBarView(controller: tabController, children: [
                // FIRST TAB
                transLog.isNotEmpty
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: transLog.length,
                        itemBuilder: (context, x) {
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: -0.5, end: 0.0),
                            duration: const Duration(seconds: 1),
                            curve: Curves.ease,
                            builder: (context, value, child) {
                              indexTab = 0;
                              return Transform.translate(
                                offset: Offset(
                                  value * 150,
                                  0.0,
                                ),
                                child: child,
                              );
                            },
                            child: Card(
                              color:
                                  themeManager.currentTheme == ThemeMode.light
                                      ? Colors.white
                                      : ServiceProvider.blueTrackColor,
                              child: transLog.isNotEmpty
                                  ? ListTile(
                                      leading: Stack(
                                        children: [
                                          if (transLog[x]['serviceCode'] ==
                                                  'mtnAirtime' ||
                                              transLog[x]['serviceCode'] ==
                                                  'mtnData')
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "images/mtn_logo.png")),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )
                                          else if (transLog[x]['serviceCode'] ==
                                                  'gloAirtime' ||
                                              transLog[x]['serviceCode'] ==
                                                  'gloData')
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "images/glo.png")),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )
                                          else if (transLog[x]['serviceCode'] ==
                                                  'airtelAirtime' ||
                                              transLog[x]['serviceCode'] ==
                                                  'airtelData')
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "images/airtel.png")),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )
                                          else if (transLog[x]['serviceCode'] ==
                                                  '9mobileAirtime' ||
                                              transLog[x]['serviceCode'] ==
                                                  '9mobileData')
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "images/9mobile.png")),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )
                                          else if (transLog[x]['serviceCode'] ==
                                              'spectranet')
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "images/spectranet.png")),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )
                                          else if (transLog[x]['serviceCode'] ==
                                              'smile')
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "images/smile.png")),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )
                                          else if (transLog[x]['serviceCode'] ==
                                              'fiberone')
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "images/fiberone.png")),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )
                                          else if (transLog[x]['serviceCode'] ==
                                              'dstv')
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "images/dstv.png")),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )
                                          else if (transLog[x]['serviceCode'] ==
                                              'gotv')
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "images/gotv.png")),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )
                                          else if (transLog[x]['serviceCode'] ==
                                              'startimes')
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "images/startimes.png")),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )
                                          else if (transLog[x]['serviceCode'] ==
                                              'showmax')
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "images/showmax.png")),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )
                                          else
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "images/no_image.png")),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )
                                        ],
                                      ),
                                      title: Text(
                                        transLog[x]['serviceProvided'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: ServiceProvider.contentFont,
                                      ),
                                      subtitle: Stack(
                                        children: [
                                          if (transLog[x]['subscription'] != '')
                                            Text(
                                              transLog[x]['subscription']!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.sora()
                                                  .copyWith(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                            )
                                          else
                                            Text(
                                              transLog[x]['transactionNo']!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.sora()
                                                  .copyWith(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                            )
                                        ],
                                      ),
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "₦ ${serviceProvider.numberFormater(double.parse(transLog[x]['amount']))}",
                                            style:
                                                GoogleFonts.sarabun().copyWith(
                                              color:
                                                  themeManager.currentTheme ==
                                                          ThemeMode.light
                                                      ? ServiceProvider
                                                          .darkBlueShade4
                                                      : Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            (transLog[x]['createdDate']),
                                            style: GoogleFonts.sora().copyWith(
                                              color: ServiceProvider.idColor,
                                              fontSize: 11,
                                            ),
                                          ),
                                          InkWell(
                                            child: Container(
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    color: ServiceProvider
                                                        .innerBlueBackgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                      color: ServiceProvider
                                                          .innerBlueBackgroundColor,
                                                    )),
                                                child: const Text(
                                                  'Detail',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            onTap: () {
                                              serviceProvider.popDialogMsg(
                                                  context,
                                                  'Info',
                                                  "Transaction No: ${transLog[x]['transactionNo']}\nSubscription: ${transLog[x]['subscription']}\nAmount: ₦ ${serviceProvider.numberFormater(double.parse(transLog[x]['amount']))}\nData: ${transLog[x]['dataAmt']}MB\nService Provided: ${transLog[x]['serviceProvided']}\nCreated Date: ${transLog[x]['createdDate']}\nStatus: ${transLog[x]['status']}");
                                            },
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ),
                          );
                        })
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.receipt_rounded,
                              color: Colors.grey, size: 80),
                          Text(
                            'No Record',
                            style: ServiceProvider.warningFont,
                          ),
                        ],
                      ),

                // SECOND TAB (ACCT STATEMENT)
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Text(
                        'Choose statement period',
                        style: ServiceProvider.greetUserFont1,
                      ),
                      SizedBox(
                        height: screenH * 0.004,
                      ),
                      Text(
                        'Start',
                        style: themeManager.currentTheme == ThemeMode.light
                            ? ServiceProvider.cardFontBold4
                            : ServiceProvider.cardFontBoldLight,
                      ),
                      SizedBox(
                        child: SizedBox(
                            height: screenH * 0.2,
                            width: screenW * 0.8,
                            child: CupertinoTheme(
                              data: CupertinoThemeData(
                                textTheme: CupertinoTextThemeData(
                                  dateTimePickerTextStyle: TextStyle(
                                    letterSpacing: 2,
                                    fontSize: 20.0,
                                    color: themeManager.currentTheme ==
                                            ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              child: CupertinoDatePicker(
                                maximumYear: DateTime.now().year,
                                maximumDate: DateTime.now(),
                                mode: CupertinoDatePickerMode.date,
                                initialDateTime: startDate,
                                onDateTimeChanged: (_startDate) {
                                  print('Inital: ' + startDate.toString());

                                  startDate = _startDate;

                                  var selectedDate = DateFormat('dd/MM/yyyy')
                                      .format(startDate);
                                  print('Selected: ' + selectedDate.toString());
                                },
                              ),
                            )),
                      ),
                      Builder(builder: (context) {
                        indexTab = 1;
                        return Text(
                          'End',
                          style: themeManager.currentTheme == ThemeMode.light
                              ? ServiceProvider.cardFontBold4
                              : ServiceProvider.cardFontBoldLight,
                        );
                      }),
                      SizedBox(
                        child: SizedBox(
                          height: screenH * 0.2,
                          width: screenW * 0.8,
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                  dateTimePickerTextStyle: TextStyle(
                                color:
                                    themeManager.currentTheme == ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                letterSpacing: 2,
                                fontSize: 20.0,
                              )),
                            ),
                            child: CupertinoDatePicker(
                              maximumYear: DateTime.now().year,
                              maximumDate: DateTime.now(),
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: endDate,
                              onDateTimeChanged: (_endDate) {
                                print('Inital: ' + startDate.toString());

                                endDate = _endDate;

                                var selectedDate =
                                    DateFormat('dd/MM/yyyy').format(endDate);
                                print(
                                    'Selected End: ' + selectedDate.toString());
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenH * 0.04,
                      ),
                      SizedBox(
                        height: 40,
                        child: MaterialButton(
                          onPressed: () async {
                            var valDate = startDate.compareTo(endDate);
                            if (valDate > 0) {
                              serviceProvider.popWarningErrorMsg(
                                  context,
                                  'Error',
                                  'Start date most be greater or equal to end date.');
                            } else {
                              var resp = await serviceProvider.getAcctStatement(
                                  context, token, startDate, endDate);
                              if (resp['isSuccess'] == false) {
                                serviceProvider.popWarningErrorMsg(context,
                                    'Error', resp['errorMsg'].toString());
                              } else if (resp['isSuccess'] == true) {
                                showAcctStatement(resp['acctStatement'],
                                    resp['openBal'], resp['compInfo']);
                              }
                            }
                            print(valDate);
                            print(
                                'Start Date:  ${startDate.toString()} \nEnd Date: ${endDate.toString()}');
                          },
                          child: const Text(
                            'Generate',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          color: ServiceProvider.innerBlueBackgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                        ),
                      )
                    ],
                  ),
                )
              ])),
            ],
          ),
        ),
      ),
    ));
  }

  filter() {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.height;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context, StateSetter setstate) {
            return Container(
              height: screenH * 0.37,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(''),
                          Text(
                            'filter',
                            style: ServiceProvider.pageNameFont,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              height: screenH * 0.053,
                              // width: screenW * 0.12,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      ServiceProvider.innerBlueBackgroundColor,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Transform.rotate(
                                angle: 150,
                                child: const Icon(
                                  Icons.add,
                                  size: 45,
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: screenW * 0.04),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Date',
                              style: ServiceProvider.pageInfoWithLightGreyFont,
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: screenW * 0.15,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    await _selectCupertinoDate('startDate');
                                    setstate(() {});
                                  },
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(startDate),
                                    style: GoogleFonts.sora().copyWith(
                                      color: Colors.brown.shade700,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: ServiceProvider
                                          .innerBlueBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '-- To -->',
                                style: ServiceProvider.pageInfoWithDarkGreyFont,
                              ),
                              SizedBox(
                                width: screenW * 0.15,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    await _selectCupertinoDate('endDate');
                                    setstate(() {});
                                  },
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(endDate),
                                    style: GoogleFonts.sora().copyWith(
                                      color: Colors.brown.shade700,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: ServiceProvider
                                          .innerBlueBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(child: Container()),
                  SizedBox(
                    height: 40,
                    child: MaterialButton(
                      onPressed: () {
                        print('Start Date: ' + startDate.toString());
                        print('End Date: ' + endDate.toString());
                      },
                      child: const Text('Apply'),
                      color: ServiceProvider.innerBlueBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  // ========= USED TO DISPLAY ACCT STATEMENT ===============
  showAcctStatement(List acctList, openBal, Map compInfo) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.height;
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    // ================ DETAIL HEADER SECTION ============
    Container detailHeader() {
      return Container(
        child: Table(
          columnWidths: const {
            // 0: FixedColumnWidth(37),
            // 1: FixedColumnWidth(30),
            // 2: FixedColumnWidth(35),
            3: FixedColumnWidth(100),
            4: FixedColumnWidth(60),
            5: FixedColumnWidth(37)
          },
          children: [
            TableRow(children: [
              Text(
                'Date',
                style: ServiceProvider.smallFontBlackContent,
              ),
              Text(
                'Credit',
                style: ServiceProvider.smallFontBlackContent,
              ),
              Text(
                'Debit',
                style: ServiceProvider.smallFontBlackContent,
              ),
              Text(
                'Detail',
                style: ServiceProvider.smallFontBlackContent,
              ),
              Text(
                'Balance',
                style: ServiceProvider.smallFontBlackContent,
              ),
              Text(
                'Status',
                style: ServiceProvider.smallFontBlackContent,
              ),
            ])
          ],
        ),
      );
    }

    Widget acctStatement() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Start Date: ',
                style: ServiceProvider.smallFontBlackContent,
              ),
              Text(
                serviceProvider.formatDateWithStroke(startDate),
                style: ServiceProvider.smallFontGreyContent,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'End Date: ',
                style: ServiceProvider.smallFontBlackContent,
              ),
              Text(
                serviceProvider.formatDateWithStroke(endDate),
                style: ServiceProvider.smallFontGreyContent,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Opening Balance: ',
                style: ServiceProvider.smallFontBlackContent,
              ),
              Text(
                "₦ ${serviceProvider.formattedNumber(openBal)}",
                style: ServiceProvider.smallFontGreyContent,
              ),
            ],
          ),
        ],
      );
    }

    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        backgroundColor: themeManager.currentTheme == ThemeMode.light
            ? ServiceProvider.backGroundColor
            : ServiceProvider.darkNavyBGColor,
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: screenH - 130,
            child: Column(
              children: [
                const SizedBox(height: 10),
                ServiceProvider.bottomSheetBarHeader,
                Text(
                  'Account Statement',
                  style: ServiceProvider.pageNameFont,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    acctStatement(),
                    MaterialButton(
                      onPressed: acctList.isEmpty
                          ? null
                          : () async {
                              final data = await _toPDF.acctStatement(
                                startDate,
                                endDate,
                                acctList,
                                openBal,
                                compInfo,
                              );
                              serviceProvider.isLifeCycleState =
                                  false; // THIS IS USED ON THE LIFE-CYCLE-STATE
                              _toPDF.savePdfFile(
                                'accountStatement ${getCurrentDate()}',
                                data,
                              );
                            },
                      child: const Text(
                        'To PDF',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      disabledColor: Colors.grey.shade300,
                      color: ServiceProvider.innerBlueBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ],
                ),
                detailHeader(),
                Divider(
                  color: themeManager.currentTheme == ThemeMode.light
                      ? Colors.black38
                      : Colors.white70,
                  height: 3.0,
                ),
                Expanded(
                  child: acctList.isNotEmpty
                      ? ListView.builder(
                          itemCount: acctList.length,
                          itemBuilder: (context, x) {
                            return Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FixedColumnWidth(37),
                                  1: FixedColumnWidth(37),
                                  2: FixedColumnWidth(37),
                                  3: FixedColumnWidth(100),
                                  4: FixedColumnWidth(48),
                                  5: FixedColumnWidth(20)
                                },
                                children: [
                                  TableRow(
                                      decoration: themeManager.currentTheme ==
                                              ThemeMode.light
                                          ? x.isEven
                                              ? BoxDecoration(
                                                  color: Colors.grey[200])
                                              : const BoxDecoration(
                                                  color: Colors.white)
                                          : x.isEven
                                              ? BoxDecoration(
                                                  color: ServiceProvider
                                                      .blueTrackColor,
                                                )
                                              : BoxDecoration(
                                                  color: ServiceProvider
                                                      .darkNavyBGColor,
                                                ),
                                      children: [
                                        Text(
                                          acctList[x]['transactionDate'],
                                          style: themeManager.currentTheme ==
                                                  ThemeMode.light
                                              ? ServiceProvider
                                                  .smallFontGreyContent
                                              : ServiceProvider
                                                  .smallFontWhiteContent,
                                          textAlign: TextAlign.center,
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            serviceProvider.formattedNumber(
                                                acctList[x]['credit']),
                                            style: themeManager.currentTheme ==
                                                    ThemeMode.light
                                                ? ServiceProvider
                                                    .smallFontGreyContent
                                                : ServiceProvider
                                                    .smallFontWhiteContent,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            serviceProvider.formattedNumber(
                                                acctList[x]['debit']),
                                            style: themeManager.currentTheme ==
                                                    ThemeMode.light
                                                ? ServiceProvider
                                                    .smallFontGreyContent
                                                : ServiceProvider
                                                    .smallFontWhiteContent,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            acctList[x]['description']!,
                                            style: themeManager.currentTheme ==
                                                    ThemeMode.light
                                                ? ServiceProvider
                                                    .smallFontGreyContent
                                                : ServiceProvider
                                                    .smallFontWhiteContent,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            serviceProvider.formattedNumber(
                                                acctList[x]['closingBal']),
                                            style: themeManager.currentTheme ==
                                                    ThemeMode.light
                                                ? ServiceProvider
                                                    .smallFontGreyContent
                                                : ServiceProvider
                                                    .smallFontWhiteContent,
                                          ),
                                        ),
                                        SizedBox(
                                            height: 40,
                                            child: acctList[x]['status']
                                                ? const Icon(
                                                    Icons.check_box,
                                                    color: Colors.green,
                                                    size: 15,
                                                  )
                                                : const Icon(
                                                    Icons.cancel_presentation,
                                                    color: Colors.red,
                                                    size: 15,
                                                  ))
                                      ])
                                ]);
                          })
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.receipt_rounded,
                                color: Colors.grey, size: 80),
                            Text(
                              'No Record',
                              style: ServiceProvider.warningFont,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
          // );
        }).whenComplete(() async {
      bool isCycleState = await serviceProvider.getLifeCycleStateFrmPref();
      serviceProvider.isLifeCycleState =
          isCycleState; // THIS IS USED ON THE LIFE-CYCLE-STATE)
    });
  }

  // ========= CUPERTINO DATE SELECTOR IN MODAL BOTTOM SHEET FORMAT =========

  DateTime? pickedDate;
  _selectCupertinoDate(String caller) async {
    await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 250,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlinedButton(
                      child: const Text('Done'),
                      onPressed: () {
                        setState(() {
                          if (caller == 'startDate' && pickedDate != null) {
                            startDate = DateTime.parse(pickedDate.toString());
                            Navigator.of(context).pop(startDate);
                          } else if (caller == 'endDate' &&
                              pickedDate != null) {
                            endDate = DateTime.parse(pickedDate.toString());

                            Navigator.of(context).pop(endDate);
                          }
                        });
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                        color: ServiceProvider.innerBlueBackgroundColor,
                      )),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      setState(() {
                        pickedDate = dateTime;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
