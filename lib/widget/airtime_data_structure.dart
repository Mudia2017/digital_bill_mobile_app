import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/route/route.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:digital_mobile_bill/widget/authenticate_pin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

class AirtimeDataStructure extends StatefulWidget {
  List<dynamic>? allDataSubList = [];
  final providerChoice;
  final serviceName;
  String pageName;
  final String call;
  AirtimeDataStructure({
    Key? key,
    this.allDataSubList,
    required this.providerChoice,
    required this.serviceName,
    required this.pageName,
    required this.call,
  }) : super(key: key);

  @override
  State<AirtimeDataStructure> createState() => _AirtimeDataStructureState();
}

class _AirtimeDataStructureState extends State<AirtimeDataStructure> {
  @override
  void initState() {
    super.initState();
    initalCall();
    _providerChoice();
  }

  final _formKey = GlobalKey<FormState>();
  bool _hasBeenPressed = false;
  bool _hasBeenPressed2 = false;
  bool _hasBeenPressed3 = false;
  bool _hasBeenPressed4 = false;
  String price = '0.00';
  String providerCode = '';
  List filteredData = [];
  var serviceProvider = ServiceProvider();
  TextEditingController mobileController = TextEditingController();
  TextEditingController airtimeController = TextEditingController();
  TextEditingController decoderController = TextEditingController();
  TextEditingController meterNumberController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  bool isNumSetAsDefault = false;
  int selectedRadioTile = 0;
  bool isServiceProviderSelected = true;
  String selectListVal = '';
  String providerChoice = '';
  String dataAmt = '';
  String subscriptionId = '';
  bool isProviderSelected = true;
  bool isAmtMaxFig = false;
  var name, email, token, mobile;

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

    // IF AIRTIME DEFAULT NUM WAS SAVED IN SHARED PREF,
    // DISPLAY IT AND SET THE SWITCH BUTTON ON.
    var _data = await serviceProvider.getDefaultNumFrmPref();
    if (_data['airtimeNum'] != '' &&
        _data['airtimeNum'] != null &&
        widget.call == 'airtimeServiceProvider') {
      mobileController.text = _data['airtimeNum'];
      isNumSetAsDefault = true;
    } else if (_data['dataNum'] != '' &&
        _data['dataNum'] != null &&
        widget.call == 'dataServiceProvider') {
      mobileController.text = _data['dataNum'];
      isNumSetAsDefault = true;
    } else if (_data['internetNum'] != '' &&
        _data['internetNum'] != null &&
        widget.call == 'internetServiceProvider') {
      mobileController.text = _data['internetNum'];
      isNumSetAsDefault = true;
    } else if (_data['cableNum'] != '' &&
        _data['cableNum'] != null &&
        widget.call == 'cableTvServiceProvider') {
      decoderController.text = _data['cableNum'];
      isNumSetAsDefault = true;
    }
  }

  _providerChoice() {
    if (widget.providerChoice != '') {
      print(widget.providerChoice);
      switch (widget.providerChoice) {
        case 'mtnData':
          setState(() {
            _hasBeenPressed = true;
            providerCode = 'mtn_${widget.serviceName}';
            price = '0.00';
          });
          providerChoice = widget.providerChoice;
          print('MTN DATA SELECTED');
          break;
        case 'gloData':
          setState(() {
            _hasBeenPressed2 = true;
            providerCode = 'glo_${widget.serviceName}';
            price = '0.00';
          });
          providerChoice = widget.providerChoice;
          print('GLO DATA SELECTED');
          break;
        case 'airtelData':
          setState(() {
            _hasBeenPressed3 = true;
            providerCode = 'airtel_${widget.serviceName}';
            price = '0.00';
          });
          providerChoice = widget.providerChoice;
          print('AIRTEL DATA SELECTED');
          break;
        case '9mobileData':
          setState(() {
            _hasBeenPressed4 = true;
            providerCode = '9mobile_${widget.serviceName}';
            price = '0.00';
          });
          providerChoice = widget.providerChoice;
          print('9MOBIL DATA SELECTED');
          break;
        case 'mtnAirtime':
          setState(() {
            _hasBeenPressed = true;
            providerCode = 'mtn_${widget.serviceName}';
            price = '0.00';
            print('MTN AIRTIME SELECTED');
          });
          providerChoice = widget.providerChoice;
          break;
        case 'gloAirtime':
          setState(() {
            _hasBeenPressed2 = true;
            providerCode = 'glo_${widget.serviceName}';
            price = '0.00';
          });
          providerChoice = widget.providerChoice;
          print('GLO AIRTIME SELECTED');
          break;
        case 'airtelAirtime':
          setState(() {
            _hasBeenPressed3 = true;
            providerCode = 'airtel_${widget.serviceName}';
            price = '0.00';
          });
          providerChoice = widget.providerChoice;
          print('AIRTEL AIRTIME SELECTED');
          break;
        case '9mobileAirtime':
          setState(() {
            _hasBeenPressed4 = true;
            providerCode = '9mobile_${widget.serviceName}';
            price = '0.00';
          });
          providerChoice = widget.providerChoice;
          print('9MOBILE AIRTIME SELECTED');
          break;

        case 'dstv':
          setState(() {
            _hasBeenPressed = true;
            providerCode = widget.serviceName;
            price = '0.00';
          });
          providerChoice = widget.providerChoice;
          print('DSTV CABLE SELECTED');
          break;
        case 'gotv':
          setState(() {
            _hasBeenPressed2 = true;
            providerCode = widget.serviceName;
            price = '0.00';
          });
          providerChoice = widget.providerChoice;
          print('GOTV SELECTED');
          break;
        case 'startimes':
          setState(() {
            _hasBeenPressed3 = true;
            providerCode = widget.serviceName;
            price = '0.00';
          });
          providerChoice = widget.providerChoice;
          print('STARTIMES SELECTED');
          break;
        case 'showmax':
          setState(() {
            _hasBeenPressed4 = true;
            providerCode = widget.serviceName;
            price = '0.00';
          });
          providerChoice = widget.providerChoice;
          print('SHOWMAX SELECTED');
          break;
        default:
      }
    }
  }

  _filterServiceProvider() {
    if (providerCode != '') {
      setState(() {
        filteredData = widget.allDataSubList!
            .where((element) => element['code'].contains(providerCode))
            .toList();
      });
    }
  }

  var maskFormatter = MaskTextInputFormatter(
      mask: '#### ### ####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var moneyFormatter = MaskTextInputFormatter(
    mask: '######',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.call == 'dataServiceProvider' ||
        widget.call == 'internetServiceProvider' ||
        widget.call == 'cableTvServiceProvider') {
      _filterServiceProvider();
    } else if (widget.call == 'electricityServiceProvider') {
      providerCode = 'phcn';
      _filterServiceProvider();
    }
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Container(
      child: Expanded(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    widget.pageName,
                    style: TextStyle(
                      color: themeManager.currentTheme == ThemeMode.light
                          ? ServiceProvider.lightBlueBackGroundColor
                          : ServiceProvider.whiteColorShade70,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // LIST OF SERVICE PROVIDERS
                  if (widget.call != 'electricityServiceProvider')
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: isProviderSelected
                          ? const BoxDecoration()
                          : BoxDecoration(
                              border: Border.all(
                                color: Colors.red.shade700,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => setState(() {
                                  if (widget.call == 'dataServiceProvider') {
                                    debugPrint('SELECTED MTN');
                                    providerChoice = 'mtnData';
                                    providerCode = 'mtn_data';
                                    isProviderSelected = true;
                                    _filterServiceProvider();
                                  } else if (widget.call ==
                                      'airtimeServiceProvider') {
                                    setState(() {
                                      isProviderSelected = true;
                                    });
                                    providerChoice = 'mtnAirtime';
                                    debugPrint('MTN AIRTIME SELECTED');
                                  } else if (widget.call ==
                                      'cableTvServiceProvider') {
                                    providerChoice = 'dstv';
                                    isProviderSelected = true;
                                    providerCode = 'dstv';
                                    debugPrint('DSTV SELECTED');
                                  } else if (widget.call ==
                                      'internetServiceProvider') {
                                    providerChoice = 'spectranet';
                                    debugPrint('SPECTRANET SELECTED');
                                    providerCode = 'spectranet_data';
                                    isProviderSelected = true;
                                    _filterServiceProvider();
                                  }

                                  selectListVal = '';
                                  price = '0.00';
                                  if (!_hasBeenPressed) {
                                    _hasBeenPressed = !_hasBeenPressed;
                                  }
                                  if (_hasBeenPressed2) {
                                    _hasBeenPressed2 = !_hasBeenPressed2;
                                  }
                                  if (_hasBeenPressed3) {
                                    _hasBeenPressed3 = !_hasBeenPressed3;
                                  }
                                  if (_hasBeenPressed4) {
                                    _hasBeenPressed4 = !_hasBeenPressed4;
                                  }
                                }),
                                child: Hero(
                                  tag: 'mtn_logo',
                                  child: Container(
                                    width: screenW * 0.17,
                                    height: screenH * 0.08,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: !_hasBeenPressed
                                            ? Colors.grey.shade300
                                            : Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Stack(
                                        children: [
                                          if (widget.call ==
                                                  'dataServiceProvider' ||
                                              widget.call ==
                                                  'airtimeServiceProvider')
                                            Container(
                                              width: screenW * 0.14,
                                              height: screenH * 0.05,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                      'images/mtn_logo.png'),
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 18,
                                                    left: 28,
                                                    child: !_hasBeenPressed
                                                        ? Container()
                                                        : const Icon(
                                                            Icons
                                                                .done_all_sharp,
                                                            color: Colors.blue,
                                                            size: 30,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (widget.call ==
                                              'cableTvServiceProvider')
                                            Container(
                                              width: screenW * 0.14,
                                              height: screenH * 0.05,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                      'images/dstv.png'),
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 18,
                                                    left: 28,
                                                    child: !_hasBeenPressed
                                                        ? Container()
                                                        : const Icon(
                                                            Icons
                                                                .done_all_sharp,
                                                            color: Colors.blue,
                                                            size: 30,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (widget.call ==
                                              'internetServiceProvider')
                                            Container(
                                              width: screenW * 0.14,
                                              height: screenH * 0.05,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                      'images/spectranet.png'),
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 18,
                                                    left: 28,
                                                    child: !_hasBeenPressed
                                                        ? Container()
                                                        : const Icon(
                                                            Icons
                                                                .done_all_sharp,
                                                            color: Colors.blue,
                                                            size: 30,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() {
                                  if (widget.call == 'dataServiceProvider') {
                                    debugPrint('SELECTED GLO');
                                    providerChoice = 'gloData';
                                    providerCode = 'glo_data';
                                    isProviderSelected = true;
                                    _filterServiceProvider();
                                  } else if (widget.call ==
                                      'airtimeServiceProvider') {
                                    providerChoice = 'gloAirtime';
                                    isProviderSelected = true;
                                    debugPrint('GLO AIRTIME SELECTED');
                                  } else if (widget.call ==
                                      'cableTvServiceProvider') {
                                    providerChoice = 'gotv';
                                    providerCode = 'gotv';
                                    isProviderSelected = true;
                                    debugPrint('GOTV SELECTED');
                                  } else if (widget.call ==
                                      'internetServiceProvider') {
                                    providerChoice = 'smile';
                                    debugPrint('SMILE SELECTED');
                                    providerCode = 'smile_data';
                                    isProviderSelected = true;
                                    _filterServiceProvider();
                                  }
                                  selectListVal = '';
                                  price = '0.00';
                                  if (!_hasBeenPressed2) {
                                    _hasBeenPressed2 = !_hasBeenPressed2;
                                  }
                                  if (_hasBeenPressed) {
                                    _hasBeenPressed = !_hasBeenPressed;
                                  }
                                  if (_hasBeenPressed3) {
                                    _hasBeenPressed3 = !_hasBeenPressed3;
                                  }
                                  if (_hasBeenPressed4) {
                                    _hasBeenPressed4 = !_hasBeenPressed4;
                                  }
                                }),
                                child: Container(
                                  width: screenW * 0.17,
                                  height: screenH * 0.08,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: !_hasBeenPressed2
                                          ? Colors.grey.shade300
                                          : Colors.blue,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        if (widget.call ==
                                                'dataServiceProvider' ||
                                            widget.call ==
                                                'airtimeServiceProvider')
                                          Container(
                                            width: screenW * 0.14,
                                            height: screenH * 0.05,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'images/glo.png'),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 18,
                                                  left: 28,
                                                  child: !_hasBeenPressed2
                                                      ? Container()
                                                      : const Icon(
                                                          Icons.done_all_sharp,
                                                          color: Colors.blue,
                                                          size: 30,
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (widget.call ==
                                            'cableTvServiceProvider')
                                          Container(
                                            width: screenW * 0.14,
                                            height: screenH * 0.05,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'images/gotv.png'),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 18,
                                                  left: 28,
                                                  child: !_hasBeenPressed2
                                                      ? Container()
                                                      : const Icon(
                                                          Icons.done_all_sharp,
                                                          color: Colors.blue,
                                                          size: 30,
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (widget.call ==
                                            'internetServiceProvider')
                                          Container(
                                            width: screenW * 0.14,
                                            height: screenH * 0.05,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'images/smile.png'),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 18,
                                                  left: 28,
                                                  child: !_hasBeenPressed2
                                                      ? Container()
                                                      : const Icon(
                                                          Icons.done_all_sharp,
                                                          color: Colors.blue,
                                                          size: 30,
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() {
                                  if (widget.call == 'dataServiceProvider') {
                                    debugPrint('SELECTED AIRTEL');
                                    providerChoice = 'airtelData';
                                    providerCode = 'airtel_data';
                                    isProviderSelected = true;
                                    _filterServiceProvider();
                                  } else if (widget.call ==
                                      'airtimeServiceProvider') {
                                    debugPrint('AIRTEL AIRTIME SELECTED');
                                    providerChoice = 'airtelAirtime';
                                    isProviderSelected = true;
                                  } else if (widget.call ==
                                      'cableTvServiceProvider') {
                                    debugPrint('STARTIMES SELECTED');
                                    providerChoice = 'startimes';
                                    providerCode = 'startimes';
                                    isProviderSelected = true;
                                  } else if (widget.call ==
                                      'internetServiceProvider') {
                                    debugPrint('FIBERONE SELECTED');
                                    providerChoice = 'fiberone';
                                    providerCode = 'fiberone_data';
                                    isProviderSelected = true;
                                    _filterServiceProvider();
                                  }
                                  selectListVal = '';
                                  price = '0.00';
                                  if (!_hasBeenPressed3) {
                                    _hasBeenPressed3 = !_hasBeenPressed3;
                                  }
                                  if (_hasBeenPressed4) {
                                    _hasBeenPressed4 = !_hasBeenPressed4;
                                  }
                                  if (_hasBeenPressed2) {
                                    _hasBeenPressed2 = !_hasBeenPressed2;
                                  }
                                  if (_hasBeenPressed) {
                                    _hasBeenPressed = !_hasBeenPressed;
                                  }
                                }),
                                child: Container(
                                  width: screenW * 0.17,
                                  height: screenH * 0.08,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: !_hasBeenPressed3
                                          ? Colors.grey.shade300
                                          : Colors.blue,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        if (widget.call ==
                                                'dataServiceProvider' ||
                                            widget.call ==
                                                'airtimeServiceProvider')
                                          Container(
                                            width: screenW * 0.14,
                                            height: screenH * 0.05,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'images/airtel.png'),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 18,
                                                  left: 28,
                                                  child: !_hasBeenPressed3
                                                      ? Container()
                                                      : const Icon(
                                                          Icons.done_all_sharp,
                                                          color: Colors.blue,
                                                          size: 30,
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (widget.call ==
                                            'cableTvServiceProvider')
                                          Container(
                                            width: screenW * 0.14,
                                            height: screenH * 0.05,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'images/startimes2.png'),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 18,
                                                  left: 28,
                                                  child: !_hasBeenPressed3
                                                      ? Container()
                                                      : const Icon(
                                                          Icons.done_all_sharp,
                                                          color: Colors.blue,
                                                          size: 30,
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (widget.call ==
                                            'internetServiceProvider')
                                          Container(
                                            width: screenW * 0.14,
                                            height: screenH * 0.05,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'images/fiberone.png'),
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 18,
                                                  left: 28,
                                                  child: !_hasBeenPressed3
                                                      ? Container()
                                                      : const Icon(
                                                          Icons.done_all_sharp,
                                                          color: Colors.blue,
                                                          size: 30,
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (widget.call !=
                                  'internetServiceProvider') // SINCE WE ONLY HAVE 3 SERVICE PROVIDER FOR INTERNET, USE THIS CONDITION TO REMOVE THE LAST ONE.
                                InkWell(
                                  onTap: () => setState(() {
                                    if (widget.call == 'dataServiceProvider') {
                                      providerCode = '9mobile_data';
                                      providerChoice = '9mobileData';
                                      debugPrint('SELECTED 9MOBILE');
                                      isProviderSelected = true;
                                      _filterServiceProvider();
                                    } else if (widget.call ==
                                        'airtimeServiceProvider') {
                                      debugPrint('9MOBILE AIRTIME SELECTED');
                                      providerChoice = '9mobileAirtime';
                                      isProviderSelected = true;
                                    } else if (widget.call ==
                                        'cableTvServiceProvider') {
                                      debugPrint('SHOWMAX SELECTED');
                                      providerChoice = 'showmax';
                                      providerCode = 'showmax';
                                      isProviderSelected = true;
                                    }
                                    selectListVal = '';
                                    price = '0.00';
                                    if (!_hasBeenPressed4) {
                                      _hasBeenPressed4 = !_hasBeenPressed4;
                                    }
                                    if (_hasBeenPressed3) {
                                      _hasBeenPressed3 = !_hasBeenPressed3;
                                    }
                                    if (_hasBeenPressed2) {
                                      _hasBeenPressed2 = !_hasBeenPressed2;
                                    }
                                    if (_hasBeenPressed) {
                                      _hasBeenPressed = !_hasBeenPressed;
                                    }
                                  }),
                                  child: Container(
                                    width: screenW * 0.17,
                                    height: screenH * 0.08,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: !_hasBeenPressed4
                                            ? Colors.grey.shade300
                                            : Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Stack(
                                        children: [
                                          if (widget.call ==
                                                  'dataServiceProvider' ||
                                              widget.call ==
                                                  'airtimeServiceProvider')
                                            Container(
                                              width: screenW * 0.14,
                                              height: screenH * 0.05,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                      'images/9mobile.png'),
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 18,
                                                    left: 28,
                                                    child: !_hasBeenPressed4
                                                        ? Container()
                                                        : const Icon(
                                                            Icons
                                                                .done_all_sharp,
                                                            color: Colors.blue,
                                                            size: 30,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (widget.call ==
                                              'cableTvServiceProvider')
                                            Container(
                                              width: screenW * 0.14,
                                              height: screenH * 0.05,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                      'images/showmax.png'),
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 18,
                                                    left: 28,
                                                    child: !_hasBeenPressed4
                                                        ? Container()
                                                        : const Icon(
                                                            Icons
                                                                .done_all_sharp,
                                                            color: Colors.blue,
                                                            size: 30,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                    child: Row(
                      children: [
                        isProviderSelected
                            ? Container()
                            : Text(
                                'Click to select a service provider',
                                style: TextStyle(
                                    color: Colors.red.shade700, fontSize: 12),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenH * 0.05,
                  ),
                  if (widget.call == 'electricityServiceProvider')
                    inputMeterNumber(),
                  if (widget.call == 'internetServiceProvider' &&
                      providerCode == 'smile_data')
                    Column(
                      children: [
                        emailAddress(),
                        SizedBox(
                          height: screenH * 0.04,
                        ),
                      ],
                    ),
                  if (widget.call == 'dataServiceProvider' ||
                      widget.call == 'airtimeServiceProvider' ||
                      widget.call == 'internetServiceProvider')
                    mobileNumber(),

                  if (widget.call == 'cableTvServiceProvider') decoderNumber(),

                  if (widget.call == 'dataServiceProvider' ||
                      widget.call == 'airtimeServiceProvider' ||
                      widget.call == 'internetServiceProvider' ||
                      widget.call == 'electricityServiceProvider' ||
                      widget.call == 'cableTvServiceProvider')
                    Row(
                      children: [
                        SizedBox(
                          height: screenH * 0.06,
                        ),
                        Switch(
                            inactiveTrackColor: Colors.grey,
                            value: isNumSetAsDefault,
                            onChanged: (val) {
                              setState(() {
                                isNumSetAsDefault = val;
                              });
                            }),
                        SizedBox(
                          width: screenW * 0.03,
                        ),
                        Text(
                          'Set as default',
                          style: GoogleFonts.sora().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),

                  SizedBox(
                    height: screenH * 0.04,
                  ),
                  if (widget.call == 'dataServiceProvider' ||
                      widget.call == 'internetServiceProvider' ||
                      widget.call == 'electricityServiceProvider' ||
                      widget.call == 'cableTvServiceProvider')
                    // DROP DOWN BUTTON LIST FOR SERVICE PROVIDER
                    outlineDropdownListButton(),

                  if (!isServiceProviderSelected)
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                      width: screenW,
                      child: Text(
                        'Kindly select from the list',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.redAccent.shade700,
                        ),
                      ),
                    ),
                  if (widget.call == 'dataServiceProvider' ||
                      widget.call == 'internetServiceProvider' ||
                      widget.call == 'cableTvServiceProvider')
                    SizedBox(
                      height: screenH * 0.06,
                    ),
                  if (widget.call == 'dataServiceProvider' ||
                      widget.call == 'internetServiceProvider' ||
                      widget.call == 'cableTvServiceProvider')
                    _amount(),
                  if (widget.call == 'dataServiceProvider')
                    SizedBox(
                      height: screenH * 0.06,
                    ),

                  if (widget.call == 'airtimeServiceProvider')
                    airtimeAmtInput(),

                  // IT DISPLAY WHEN THE AIRTIME AMOUNT FIGURE IS 6 DIGIT
                  if (isAmtMaxFig)
                    Text(
                      'Not more than 6 digit figure',
                      style: TextStyle(
                        fontSize: 12,
                        color: ServiceProvider.redWarningColor,
                      ),
                    ),

                  // RADIO BUTTON FOR PRE-PAID AND POST-PAID
                  if (widget.call == 'electricityServiceProvider')
                    Column(
                      children: [
                        ListTile(
                          leading: Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.grey,
                            ),
                            child: Radio(
                              value: 1,
                              groupValue: selectedRadioTile,
                              onChanged: (val) =>
                                  setSelectedRadioTile(val as int),
                              // activeColor: Colors.blue,
                            ),
                          ),
                          title: Text(
                            'Pre Paid',
                            style: ServiceProvider.contentFont,
                          ),
                        ),
                        ListTile(
                          leading: Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.grey,
                            ),
                            child: Radio(
                              value: 2,
                              groupValue: selectedRadioTile,
                              onChanged: (val) =>
                                  setSelectedRadioTile(val as int),
                              activeColor: Colors.blue,
                            ),
                          ),
                          title: Text(
                            'Post Paid',
                            style: ServiceProvider.contentFont,
                          ),
                        )
                      ],
                    ),

                  SizedBox(
                    height: screenH * 0.06,
                  ),

                  standardBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget outlineDropdownListButton() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          style: BorderStyle.solid,
          color: !isServiceProviderSelected
              ? Colors.redAccent.shade700
              : Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: OutlinedButton(
        onPressed: () {
          serviceList();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (selectListVal == '')
              Text(
                'Select',
                style: ServiceProvider.contentFont,
              )
            else
              Flexible(
                child: Text(
                  selectListVal,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 30,
            ),
          ],
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              themeManager.currentTheme == ThemeMode.light
                  ? Colors.white
                  : ServiceProvider.blueTrackColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  serviceList() {
    double screenH = MediaQuery.of(context).size.height;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        backgroundColor: themeManager.currentTheme == ThemeMode.light
            ? ServiceProvider.backGroundColor
            : ServiceProvider.darkNavyBGColor,
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context, setstate) {
            return SizedBox(
              height: screenH - 350,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  ServiceProvider.bottomSheetBarHeader,
                  Text(
                    'Service List',
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
                  if (providerCode != '' && filteredData.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (BuildContext cxt, int x) {
                          return InkWell(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue),
                            onTap: () {
                              setState(() {
                                selectListVal = filteredData[x]['name'];
                                price = filteredData[x]['price'];
                                dataAmt = filteredData[x]['amount_mb'];
                                subscriptionId =
                                    filteredData[x]['id'].toString();
                                isServiceProviderSelected = true;
                              });
                              Navigator.of(context).pop();
                            },
                            child: Card(
                              shape: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                borderSide: BorderSide(
                                  color: themeManager.currentTheme ==
                                          ThemeMode.light
                                      ? Colors.grey.shade400
                                      : ServiceProvider
                                          .lightBlueBackGroundColor,
                                ),
                              ),
                              elevation: 0,
                              child: ListTile(
                                title: Text(filteredData[x]['name']),
                              ),
                              color:
                                  themeManager.currentTheme == ThemeMode.light
                                      ? Colors.white
                                      : ServiceProvider.blueTrackColor,
                            ),
                          );
                        },
                      ),
                    )
                  else if (providerCode != '' && filteredData.isEmpty)
                    Container(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(
                        children: [
                          const Icon(Icons.receipt_rounded,
                              color: Colors.grey, size: 80),
                          Text(
                            'No Record !!!',
                            style: ServiceProvider.warningFont,
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text(
                        'Select a Service Provider !!!',
                        style: ServiceProvider.warningFont,
                      ),
                    ),
                ],
              ),
            );
          });
        }).then((value) {
      if (providerCode == '') {
        setState(() {
          isProviderSelected = false;
        });
      }
    });
  }

  Widget _amount() {
    return Container(
      decoration: BoxDecoration(
        color: themeManager.currentTheme == ThemeMode.light
            ? Colors.white60
            : ServiceProvider.blueTrackColor,
        border: Border.all(style: BorderStyle.none),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₦ ${serviceProvider.numberFormater((double.parse(price)))}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: ServiceProvider.idColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mobileNumber() {
    return Container(
      child: TextFormField(
        // maxLength: 13,
        keyboardType: TextInputType.phone,
        controller: mobileController,
        style: Theme.of(context).textTheme.subtitle2,
        inputFormatters: [maskFormatter],
        decoration: InputDecoration(
          labelText: 'Mobile No',
          fillColor: themeManager.currentTheme == ThemeMode.light
              ? Colors.white
              : ServiceProvider.blueTrackColor,
        ),

        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Mobile number is required';
          } else if (value.length < 13) {
            return 'Number is incomplete';
          }
          return null;
        },
      ),
    );
  }

  Widget inputMeterNumber() {
    return Container(
      child: TextFormField(
        // maxLength: 13,
        keyboardType: TextInputType.phone,
        controller: meterNumberController,
        style: Theme.of(context).textTheme.subtitle2,
        inputFormatters: [maskFormatter],
        decoration: InputDecoration(
          labelText: 'Meter No',
          fillColor: themeManager.currentTheme == ThemeMode.light
              ? Colors.white
              : ServiceProvider.blueTrackColor,
        ),

        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Meter number is required';
          }
          return null;
        },
      ),
    );
  }

  Widget emailAddress() {
    return Container(
      child: TextFormField(
        // maxLength: 13,
        keyboardType: TextInputType.emailAddress,
        controller: emailAddressController,
        style: Theme.of(context).textTheme.subtitle2,
        decoration: InputDecoration(
          labelText: 'Smile Email',
          fillColor: themeManager.currentTheme == ThemeMode.light
              ? Colors.white
              : ServiceProvider.blueTrackColor,
        ),

        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Smile email is required';
          }
          return null;
        },
      ),
    );
  }

  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  Widget airtimeAmtInput() {
    return Container(
      child: Center(
        child: TextFormField(
          controller: airtimeController,
          keyboardType: TextInputType.phone,
          maxLength: 7,
          decoration: InputDecoration(
            counterText: '',
            prefixText: '₦',
            labelText: 'Amount',
            fillColor: themeManager.currentTheme == ThemeMode.light
                ? Colors.white
                : ServiceProvider.blueTrackColor,
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Amount is required';
            }
            return null;
          },
          onChanged: (string) {
            if (string.isNotEmpty) {
              string = (string.replaceAll(RegExp('[^0-9]'), ''));
              if (string.isNotEmpty) {
                string = _formatNumber(string);
                airtimeController.value = TextEditingValue(
                  text: string,
                  selection: TextSelection.collapsed(offset: string.length),
                );
              } else {
                airtimeController.value = TextEditingValue(
                  text: '',
                  selection: TextSelection.collapsed(offset: string.length),
                );
              }
            }
            if (string.length > 6) {
              setState(() {
                isAmtMaxFig = true;
              });
            } else if (isAmtMaxFig) {
              setState(() {
                isAmtMaxFig = false;
              });
            }
          },
        ),
      ),
    );
  }

  Widget decoderNumber() {
    return Container(
      child: TextFormField(
        // maxLength: 13,
        keyboardType: TextInputType.phone,
        controller: decoderController,
        style: Theme.of(context).textTheme.subtitle2,
        inputFormatters: [maskFormatter],
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: 'IUC',
          fillColor: themeManager.currentTheme == ThemeMode.light
              ? Colors.white
              : ServiceProvider.blueTrackColor,
        ),

        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Smart Card number is required';
          }
          return null;
        },
      ),
    );
  }

  Widget standardBtn() {
    return Container(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: MaterialButton(
            disabledColor: Colors.grey.shade300,
            child: const Text(
              'Submit',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            color: ServiceProvider.innerBlueBackgroundColor,
            // color: const Color.fromRGBO(126, 165, 248, 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              bool isValidField = _formKey.currentState!.validate();
              if (isValidField) {
                if (selectListVal == '' &&
                    widget.call == 'airtimeServiceProvider') {
                  if (providerChoice != '') {
                    print('CALLED1');
                    var isDetailConfirm =
                        await serviceProvider.popWarningConfirmActionYesNo(
                      context,
                      'Info',
                      "Transaction Details:\nService provider: $providerChoice\nMobile No: ${mobileController.text}\nAmount: ${airtimeController.text}",
                      Colors.grey,
                    );
                    if (isDetailConfirm != null && isDetailConfirm) {
                      /*  CHECK IF PASSWORD IS REQUIRED BEFORE PERFORMING TRANSACTION
                          SECURITY CHECK INCLUDE THE FOLLOWING:
                      
                      1. CHECK THAT THE ACCT BALANCE IS UP TO THE REQUESTED TRANCTION AMT
                      2. CHECK THAT THE ACCOUNT IS VERIFIED. THIS INCLUDE:
                        i.  USER HAVE SECURITY PIN
                        ii. USER OTP WAS CONFIRMED
                        iii.USER IS AUTHENTICATED
                        iv. USER ACCOUNT IS ACTIVE
                      3.  CHECK THAT THE SUBSCRIPTION SELECTED IS ACTIVE
                      */

                      if (double.parse(ServiceProvider.acctBal) >=
                          (double.parse(
                              airtimeController.text.replaceAll(',', '')))) {
                        print('PROCEED...');
                        var isResult;
                        if (ServiceProvider.isAuthorizeTrans) {
                          isResult = await Navigator.of(context).pushNamed(
                              RouteManager.authenticatePin,
                              arguments: {
                                'name': name,
                                'email': email,
                                'token': token,
                                'call': 'airtimeServiceProvider',
                                'pageTitle': 'Pin Authentication',
                                'requestedAmt':
                                    airtimeController.text.replaceAll(',', ''),
                                'mobileTransNo': mobileController.text,
                                'providerChoice': providerChoice,
                                'pageInfo1': 'Kindly provide your 4 digit pin',
                                'isNumSetAsDefault': isNumSetAsDefault,
                                'serviceProvided': 'Airtime Purchase',
                              });
                        } else {
                          isResult = await serviceProvider.processTransaction(
                            context,
                            token,
                            email,
                            name,
                            '',
                            'airtimeServiceProvider',
                            airtimeController.text.replaceAll(',', ''),
                            mobileController.text,
                            providerChoice,
                            '',
                            '',
                            isNumSetAsDefault,
                            'Airtime Purchase',
                          );
                        }
                        if (isResult != null) {
                          if (isResult['isSuccess'] == true) {
                            ServiceProvider.acctBal = isResult['closingBal'];

                            if (isNumSetAsDefault) {
                              await serviceProvider.saveDefaultAirtimeNumToPref(
                                  mobileController.text);
                            } else {
                              await serviceProvider
                                  .saveDefaultAirtimeNumToPref('');
                            }

                            mobileController.clear();
                            airtimeController.clear();

                            Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteManager.homePage,
                                (Route<dynamic> route) => false,
                                arguments: {
                                  'token': token,
                                  'name': name,
                                  'email': email,
                                  'mobile': mobile,
                                  'acctBal': ServiceProvider.acctBal,
                                });

                            serviceProvider.showSuccessToast(
                                context, 'Airtime purchase successful');
                          } else if (isResult['isSuccess'] == false) {
                            serviceProvider.popWarningErrorMsg(context, 'Error',
                                isResult['errorMsg'].toString());
                          }
                        }
                      } else {
                        serviceProvider.popWarningErrorMsg(context, 'Warning',
                            'Insufficient amount to perform this transaction');
                      }
                    }
                    // setState(() {
                    //   isServicePorviderSelected = true;
                    // });
                  } else {
                    setState(() {
                      isProviderSelected = false;
                    });
                  }
                } else if (widget.call == 'cableTvServiceProvider') {
                  if (providerChoice == '') {
                    setState(() {
                      isProviderSelected = false;
                    });
                  } else if (selectListVal == '') {
                    setState(() {
                      isServiceProviderSelected = false;
                    });
                  } else {
                    print('CALLED2');
                    var inputResp =
                        await serviceProvider.popWarningConfirmActionYesNo(
                      context,
                      'Info',
                      "Transaction Details:\nService provider: $providerChoice\nIUC No: ${decoderController.text}\nPackage: $selectListVal\nAmount: $price",
                      Colors.grey,
                    );
                    if (inputResp != null && inputResp != false) {
                      /*  CHECK IF PASSWORD IS REQUIRED BEFORE PERFORMING TRANSACTION
                          SECURITY CHECK INCLUDE THE FOLLOWING:
                      
                      1. CHECK THAT THE ACCT BALANCE IS UP TO THE REQUESTED TRANCTION AMT
                      2. CHECK THAT THE ACCOUNT IS VERIFIED. THIS INCLUDE:
                        i.  USER HAVE SECURITY PIN
                        ii. USER OTP WAS CONFIRMED
                        iii.USER IS AUTHENTICATED
                        iv. USER ACCOUNT IS ACTIVE
                      3.  CHECK THAT THE SUBSCRIPTION SELECTED IS ACTIVE
                      */
                      if (double.parse(ServiceProvider.acctBal) >=
                          (double.parse(price.replaceAll(',', '')))) {
                        print('PROCEED...');

                        var isResult;
                        if (ServiceProvider.isAuthorizeTrans) {
                          isResult = await Navigator.of(context).pushNamed(
                              RouteManager.authenticatePin,
                              arguments: {
                                'name': name,
                                'email': email,
                                'token': token,
                                'call': 'cableTvServiceProvider',
                                'pageTitle': 'Pin Authentication',
                                'requestedAmt': price,
                                'mobileTransNo': decoderController.text,
                                'providerChoice': providerChoice,
                                'subscriptionId': subscriptionId,
                                'dataAmt': '',
                                'pageInfo1': 'Kindly provide your 4 digit pin',
                                'isNumSetAsDefault': isNumSetAsDefault,
                                'serviceProvided': 'Cable TV Subscription',
                              });
                        } else {
                          isResult = await serviceProvider.processTransaction(
                            context,
                            token,
                            email,
                            name,
                            '',
                            'cableTvServiceProvider',
                            price,
                            decoderController.text,
                            providerChoice,
                            subscriptionId,
                            dataAmt,
                            isNumSetAsDefault,
                            'Cable TV Subscription',
                          );
                        }
                        if (isResult != null) {
                          if (isResult['isSuccess'] == true) {
                            ServiceProvider.acctBal = isResult['closingBal'];
                            if (isNumSetAsDefault) {
                              await serviceProvider.saveDefaultDataNumToPref(
                                  decoderController.text);
                            } else {
                              await serviceProvider
                                  .saveDefaultDataNumToPref('');
                            }

                            decoderController.clear();
                            price = '0';

                            Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteManager.homePage,
                                (Route<dynamic> route) => false,
                                arguments: {
                                  'token': token,
                                  'name': name,
                                  'email': email,
                                  'mobile': mobile,
                                  'acctBal': ServiceProvider.acctBal,
                                });

                            serviceProvider.showSuccessToast(
                                context, 'Cable TV subscription successful');
                          } else if (isResult['isSuccess'] == false) {
                            serviceProvider.popWarningErrorMsg(context, 'Error',
                                isResult['errorMsg'].toString());
                          }
                        }
                      } else {
                        serviceProvider.popWarningErrorMsg(context, 'Warning',
                            'Insufficient amount to perform this transaction');
                      }
                    }
                  }
                } else if (widget.call == 'dataServiceProvider') {
                  if (providerCode == '') {
                    setState(() {
                      isProviderSelected = false;
                    });
                  } else if (selectListVal == '') {
                    setState(() {
                      isServiceProviderSelected = false;
                    });
                  } else {
                    print('CALLED3');
                    var inputResp =
                        await serviceProvider.popWarningConfirmActionYesNo(
                      context,
                      'Info',
                      "Transaction Details:\nService provider: $providerChoice\nData amount: $dataAmt mb\nPlan selected: $selectListVal\nNo: ${mobileController.text}\nAmount: ${serviceProvider.numberFormater((double.parse(price)))}",
                      Colors.grey,
                    );
                    if (inputResp != null && inputResp != false) {
                      /*  CHECK IF PASSWORD IS REQUIRED BEFORE PERFORMING TRANSACTION
                          SECURITY CHECK INCLUDE THE FOLLOWING:
                      
                      1. CHECK THAT THE ACCT BALANCE IS UP TO THE REQUESTED TRANCTION AMT
                      2. CHECK THAT THE ACCOUNT IS VERIFIED. THIS INCLUDE:
                        i.  USER HAVE SECURITY PIN
                        ii. USER OTP WAS CONFIRMED
                        iii.USER IS AUTHENTICATED
                        iv. USER ACCOUNT IS ACTIVE
                      3.  CHECK THAT THE SUBSCRIPTION SELECTED IS ACTIVE
                      */
                      if (double.parse(ServiceProvider.acctBal) >=
                          (double.parse(price.replaceAll(',', '')))) {
                        print('PROCEED...');
                        var isResult;
                        if (ServiceProvider.isAuthorizeTrans) {
                          isResult = await Navigator.of(context).pushNamed(
                              RouteManager.authenticatePin,
                              arguments: {
                                'name': name,
                                'email': email,
                                'token': token,
                                'call': 'dataServiceProvider',
                                'pageTitle': 'Pin Authentication',
                                'requestedAmt': price,
                                'mobileTransNo': mobileController.text,
                                'providerChoice': providerChoice,
                                'subscriptionId': subscriptionId,
                                'dataAmt': dataAmt,
                                'pageInfo1': 'Kindly provide your 4 digit pin',
                                'isNumSetAsDefault': isNumSetAsDefault,
                                'serviceProvided': 'Data Purchase',
                              });
                        } else {
                          isResult = await serviceProvider.processTransaction(
                            context,
                            token,
                            email,
                            name,
                            '',
                            'dataServiceProvider',
                            price,
                            mobileController.text,
                            providerChoice,
                            subscriptionId,
                            dataAmt,
                            isNumSetAsDefault,
                            'Data Purchase',
                          );
                        }

                        if (isResult != null) {
                          if (isResult['isSuccess'] == true) {
                            ServiceProvider.acctBal = isResult['closingBal'];
                            if (isNumSetAsDefault) {
                              await serviceProvider.saveDefaultDataNumToPref(
                                  mobileController.text);
                            } else {
                              await serviceProvider
                                  .saveDefaultDataNumToPref('');
                            }

                            mobileController.clear();
                            price = '0';

                            Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteManager.homePage,
                                (Route<dynamic> route) => false,
                                arguments: {
                                  'token': token,
                                  'name': name,
                                  'email': email,
                                  'mobile': mobile,
                                  'acctBal': ServiceProvider.acctBal,
                                });

                            serviceProvider.showSuccessToast(
                                context, 'Data purchase successful');
                          } else if (isResult['isSuccess'] == false) {
                            serviceProvider.popWarningErrorMsg(context, 'Error',
                                isResult['errorMsg'].toString());
                          }
                        }
                      } else {
                        serviceProvider.popWarningErrorMsg(context, 'Warning',
                            'Insufficient amount to perform this transaction');
                      }
                    }
                  }
                } else if (widget.call == 'internetServiceProvider') {
                  if (selectListVal == '') {
                    setState(() {
                      isServiceProviderSelected = false;
                    });
                  } else {
                    print('CALLED4');
                    var inputResp =
                        await serviceProvider.popWarningConfirmActionYesNo(
                      context,
                      'Info',
                      "Transaction Details:\nService provider: $providerChoice\nMobile No: ${mobileController.text}\nData amount: $dataAmt mb\nPlan: $selectListVal\nAmount: ${serviceProvider.numberFormater((double.parse(price)))}\nEmail: ${emailAddressController.text}",
                      Colors.grey,
                    );
                    if (inputResp != null && inputResp != false) {
                      /*  CHECK IF PASSWORD IS REQUIRED BEFORE PERFORMING TRANSACTION
                          SECURITY CHECK INCLUDE THE FOLLOWING:
                      
                      1. CHECK THAT THE ACCT BALANCE IS UP TO THE REQUESTED TRANCTION AMT
                      2. CHECK THAT THE ACCOUNT IS VERIFIED. THIS INCLUDE:
                        i.  USER HAVE SECURITY PIN
                        ii. USER OTP WAS CONFIRMED
                        iii.USER IS AUTHENTICATED
                        iv. USER ACCOUNT IS ACTIVE
                      3.  CHECK THAT THE SUBSCRIPTION SELECTED IS ACTIVE
                      */
                      if (double.parse(ServiceProvider.acctBal) >=
                          (double.parse(price.replaceAll(',', '')))) {
                        print('PROCEED...');
                        var isResult;
                        if (ServiceProvider.isAuthorizeTrans) {
                          isResult = await Navigator.of(context).pushNamed(
                              RouteManager.authenticatePin,
                              arguments: {
                                'name': name,
                                'email': email,
                                'token': token,
                                'call': 'internetServiceProvider',
                                'pageTitle': 'Pin Authentication',
                                'requestedAmt': price,
                                'mobileTransNo': mobileController.text,
                                'providerChoice': providerChoice,
                                'subscriptionId': subscriptionId,
                                'dataAmt': dataAmt,
                                'pageInfo1': 'Kindly provide your 4 digit pin',
                                'isNumSetAsDefault': isNumSetAsDefault,
                                'serviceProvided': 'Internet Data Purchase',
                              });
                        } else {
                          isResult = await serviceProvider.processTransaction(
                            context,
                            token,
                            email,
                            name,
                            '',
                            'internetServiceProvider',
                            price,
                            mobileController.text,
                            providerChoice,
                            subscriptionId,
                            dataAmt,
                            isNumSetAsDefault,
                            'Internet Data Purchase',
                          );
                        }
                        if (isResult != null) {
                          if (isResult['isSuccess'] == true) {
                            ServiceProvider.acctBal = isResult['closingBal'];
                            if (isNumSetAsDefault) {
                              await serviceProvider
                                  .saveDefaultInternetNumToPref(
                                      mobileController.text);
                            } else {
                              await serviceProvider
                                  .saveDefaultInternetNumToPref('');
                            }
                            mobileController.clear();
                            price = '0';

                            Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteManager.homePage,
                                (Route<dynamic> route) => false,
                                arguments: {
                                  'token': token,
                                  'name': name,
                                  'email': email,
                                  'mobile': mobile,
                                  'acctBal': ServiceProvider.acctBal,
                                });

                            serviceProvider.showSuccessToast(
                                context, 'Internet purchase successful');
                          } else if (isResult['isSuccess'] == false) {
                            serviceProvider.popWarningErrorMsg(context, 'Error',
                                isResult['errorMsg'].toString());
                          }
                        }
                      } else {
                        serviceProvider.popWarningErrorMsg(context, 'Warning',
                            'Insufficient amount to perform this transaction');
                      }
                    }
                  }
                } else if (widget.call == 'electricityServiceProvider') {
                  if (selectListVal == '') {
                    setState(() {
                      isServiceProviderSelected = false;
                    });
                  } else {
                    print('CALLED5');
                    var inputResp =
                        await serviceProvider.popWarningConfirmActionYesNo(
                      context,
                      'Info',
                      "Transaction Details:\nService provider: $providerChoice\nMobile No: ${mobileController.text}\nAmount: ${serviceProvider.numberFormater((double.parse(price)))}",
                      Colors.grey,
                    );
                    if (inputResp != null && inputResp != false) {
                      /*  CHECK IF PASSWORD IS REQUIRED BEFORE PERFORMING TRANSACTION
                          SECURITY CHECK INCLUDE THE FOLLOWING:
                      
                      1. CHECK THAT THE ACCT BALANCE IS UP TO THE REQUESTED TRANCTION AMT
                      2. CHECK THAT THE ACCOUNT IS VERIFIED. THIS INCLUDE:
                        i.  USER HAVE SECURITY PIN
                        ii. USER OTP WAS CONFIRMED
                        iii.USER IS AUTHENTICATED
                        iv. USER ACCOUNT IS ACTIVE
                      3.  CHECK THAT THE SUBSCRIPTION SELECTED IS ACTIVE
                      */
                      print('PROCEED...');
                    }
                  }
                }
              }
            }),
      ),
    );
  }
}
