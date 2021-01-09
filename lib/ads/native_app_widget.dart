import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';


import '../admob.dart';

class nativeAdsView extends StatefulWidget {
  @override
  _nativeAdsViewState createState() => _nativeAdsViewState();
}

class _nativeAdsViewState extends State<nativeAdsView> {
  final _nativeAdController = NativeAdmobController();

  AdmobManager admobManager = AdmobManager();
  @override
  void initState() {
    // TODO: implement initState

    FirebaseAdMob.instance.initialize(appId: admobManager.appID);

    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);

    super.initState();
  }

  double _height = 0;

  StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    _nativeAdController.dispose();
    super.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = 330;
        });
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NativeAdmob(
          controller: _nativeAdController,
          // Don't show loading widget when in loading sta
          adUnitID: admobManager.nativeAdID,
          loading: Container(),
          error: Text("Failed to load the ad"),
          type: NativeAdmobType.full,
        ),
      ),
    );
  }
}
