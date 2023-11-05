import 'package:digital_mobile_bill/components/service_provider.dart';
import 'package:digital_mobile_bill/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatefulWidget {
  final String name, token, email;
  const NotificationPage(
      {Key? key, required this.name, required this.token, required this.email})
      : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var serviceProvider = ServiceProvider();
  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
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
                  Text(
                    'Notification',
                    style: ServiceProvider.pageNameFontBlueBG,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: screenH * 0.053,
                      width: screenW * 0.12,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ServiceProvider.lightBlueWriteColor,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
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
    );
  }

  pageContentStructure() {
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
        child: BuildListView(),
      )),
    );
  }
}

class BuildListView extends StatefulWidget {
  const BuildListView({Key? key}) : super(key: key);

  @override
  _BuildListViewState createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 90,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (x.isEven) const Text('Today'),
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: ListTile(
                      leading: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          color: ServiceProvider.lightBlueWriteColor,
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        'Title message. This is a lengthen message to test the fitness on the card',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.sora().copyWith(),
                      ),
                      subtitle: Text(
                        '8:09 AM',
                        style: GoogleFonts.sora().copyWith(
                          color: themeManager.currentTheme == ThemeMode.light
                              ? Colors.black
                              : ServiceProvider.idColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
