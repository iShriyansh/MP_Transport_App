import 'dart:developer';

import 'package:firebase_admob/firebase_admob.dart';

class AdmobManager {
  String appID = "ca-app-pub-6614495494674157~7857150001";
  static String bannerID = "ca-app-pub-6614495494674157/2071590410";
  String nativeAdID = "ca-app-pub-6614495494674157/9848834627";
  static String interstitial = "ca-app-pub-6614495494674157/4356533477";

  // static String bannerID = BannerAd.testAdUnitId;
  // String nativeAdID = NativeAd.testAdUnitId;
  // static String interstitial = InterstitialAd.testAdUnitId;

  InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: interstitial,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );
}
