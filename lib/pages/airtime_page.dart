import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:digital_mobile_bill/widget/airtime_data_structure.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AirtimePage extends StatefulWidget {
  final String? providerChoice;
  const AirtimePage({Key? key, this.providerChoice}) : super(key: key);

  @override
  _AirtimePageState createState() => _AirtimePageState();
}

class _AirtimePageState extends State<AirtimePage> {
  @override
  Widget build(BuildContext context) {
    var serviceProvider = Provider.of<ServiceProvider>(context);
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
              Container(
                padding: const EdgeInsets.fromLTRB(30, 55, 30, 25),
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
              AirtimeDataStructure(
                call: 'airtimeServiceProvider',
                providerChoice: widget.providerChoice,
                serviceName: 'airtime',
                pageName: 'Airtime Service Provider',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
