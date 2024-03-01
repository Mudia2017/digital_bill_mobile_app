import 'dart:convert';

import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:digital_mobile_bill/widget/airtime_data_structure.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class DataPage extends StatefulWidget {
  final String? providerChoice;
  const DataPage({Key? key, this.providerChoice}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  void initState() {
    _getDataUser();
    super.initState();
    _providerChoice();
  }

  bool _hasBeenPressed = false;
  bool _hasBeenPressed2 = false;
  bool _hasBeenPressed3 = false;
  bool _hasBeenPressed4 = false;
  TextEditingController mobileController = TextEditingController();
  String selectedList = '0';
  List catList = [];
  List allDataSubList = [];
  List filteredData = [];
  String providerCode = '';
  final _formKey = GlobalKey<FormState>();
  Map userProfile = {};
  String price = '';

  getDataSub() async {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    var serverResponse =
        await serviceProvider.getServiceProvider(context, userProfile['token']);
    if (serverResponse['isSuccess'] == false) {
      if (serverResponse['errorMsg'] != '') {
        serviceProvider.popWarningErrorMsg(
            context, 'Error', serverResponse['errorMsg'].toString());
      }
    } else {
      setState(() {
        filteredData = allDataSubList = serverResponse['dataSubList'];
        _filterServiceProvider();
      });
    }
  }

  _filterServiceProvider() {
    if (providerCode != '') {
      setState(() {
        filteredData = allDataSubList
            .where((element) =>
                element['code'].contains(providerCode) ||
                element['code'].contains('select'))
            .toList();
      });
    }
  }

  _providerChoice() {
    if (widget.providerChoice != null || widget.providerChoice != '') {
      switch (widget.providerChoice) {
        case 'mtnData':
          setState(() {
            _hasBeenPressed = true;
            providerCode = 'mtn_data';
            price = '0.00';
          });
          break;
        case 'gloData':
          setState(() {
            _hasBeenPressed2 = true;
            providerCode = 'glo_data';
            price = '0.00';
          });
          break;
        case 'airtelData':
          setState(() {
            _hasBeenPressed3 = true;
            providerCode = 'airtel_data';
            price = '0.00';
          });
          break;
        case '9mobileData':
          setState(() {
            _hasBeenPressed4 = true;
            providerCode = '9mobile_data';
            price = '0.00';
          });
          break;
        default:
      }
    }
  }

  _getDataUser() async {
    var serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
    userProfile = await serviceProvider.getUserInfo();

    if (userProfile['token'] == '' || userProfile['token'] == 'null') {
      serviceProvider.logOutUser();
      serviceProvider.authenticateUser(
          context, userProfile['name'], userProfile['email']);
    } else {
      await getDataSub();
    }
  }

  var maskFormatter = MaskTextInputFormatter(
      mask: '#### ### ####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    var serviceProvider = Provider.of<ServiceProvider>(context);
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
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
                padding: const EdgeInsets.fromLTRB(30, 35, 30, 15),
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
                    Column(
                      children: [
                        Text(
                          'Available Balance',
                          style: ServiceProvider.blueWriteOnBlueBgColorFont,
                        ),
                        Text(
                          serviceProvider.isShowBal
                              ? '₦ ${serviceProvider.numberFormater(double.parse(ServiceProvider.acctBal))}'
                              : '****',
                          style: GoogleFonts.sarabun().copyWith(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const Text(''),
                  ],
                ),
              ),
              SizedBox(
                height: screenH * 0.009,
              ),
              AirtimeDataStructure(
                allDataSubList: allDataSubList,
                serviceName: 'data',
                providerChoice: widget.providerChoice,
                pageName: 'Data Service Provider',
                call: 'dataServiceProvider',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
