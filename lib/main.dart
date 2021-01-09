import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:mp_transport/License.dart';
import 'package:mp_transport/Screens/License_details.dart';
import 'package:mp_transport/Screens/bus_details.dart';
import 'package:mp_transport/admob.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Screens/Vehical_details.dart';
import 'dart:ui' as ui;
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

import 'admob.dart';
import 'ads/native_app_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
          backgroundColor: Colors.blue[30],
          appBar: AppBar(
            toolbarHeight: 50,
            backgroundColor: Colors.blue,
            title: Text('MP Transport'),
          ),
          body: Homepage()),
    );
  }
}

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  AdmobManager admobManager = AdmobManager();

  @override
  void initState() {
    // TODO: implement initState

    FirebaseAdMob.instance.initialize(appId: admobManager.appID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                    child: Card(
                  child: nativeAdsView(),
                ))
              ],
            ),
          ),
          Container(
            height: 200,
            child: Row(
              children: [
                Expanded(
                    child: buildCard(
                        imgURI: "assets/images/car.png",
                        title: "वाहन खोज",
                        description:
                            "वाहन की पूर्ण जानकारी पाए वाहन नंबर डालकर",
                        navigator: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return VehicalDetails();
                          }));
                        })),
                Expanded(
                    child: buildCard(
                        imgURI: "assets/images/bus.png",
                        title: "बस समय - तालिका",
                        description: "बसों की समय तालिका पाए शहर के नाम से",
                        navigator: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return BusDetails();
                          }));
                        })),
              ],
            ),
          ),
          Container(
            height: 200,
            child: Row(
              children: [
                Expanded(
                    child: buildCard(
                        imgURI: "assets/images/dl.png",
                        title: "ड्राइविंग लाइसेंस",
                        description:
                            "ड्राइविंग लाइसेंस की जानकारी पाए, लाइसेंस नंबर से ",
                        navigator: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LicenseDetails(
                              LicenseType: DrivingLicenese("ड्राइविंग लाइसेंस"),
                            );
                          }));
                        })),
                Expanded(
                    child: buildCard(
                        imgURI: "assets/images/learning.png",
                        title: "लर्निंग लाइसेंस",
                        description:
                            "लर्निंग लाइसेंस की जानकारी पाए, लर्निंग लाइसेंस नंबर से ",
                        navigator: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LicenseDetails(
                              LicenseType: LearningLicenese("लर्निंग लाइसेंस"),
                            );
                          }));
                        })),
              ],
            ),
          ),
          Container(
            height: 200,
            child: Row(
              children: [
                Expanded(
                    child: buildCard(
                        imgURI: "assets/images/other.png",
                        title: "अन्य सेवाएं",
                        description:
                            "RTO से सम्बंधित अन्य सभी सेवाएं एवं जानकारी ",
                        navigator: () async {
                          FlutterWebBrowser.openWebPage(
                            url:
                                "http://mis.mptransport.org/MPLogin/eLogin.aspx",
                            customTabsOptions: CustomTabsOptions(
                                toolbarColor: Colors.blue, showTitle: true),
                            safariVCOptions: SafariViewControllerOptions(
                              barCollapsingEnabled: true,
                              preferredBarTintColor: Colors.green,
                              preferredControlTintColor: Colors.amber,
                              dismissButtonStyle:
                                  SafariViewControllerDismissButtonStyle.close,
                              modalPresentationCapturesStatusBarAppearance:
                                  true,
                            ),
                          );
                        })),
                Expanded(
                  child: SizedBox(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildCard(
      {String imgURI, String title, String description, Function navigator}) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: GestureDetector(
        onTap: navigator,
        child: Card(
          elevation: 1,
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 4),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            imgURI,
                            height: 90,
                          ),
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          description,
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
