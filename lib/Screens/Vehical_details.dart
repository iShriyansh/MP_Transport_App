import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mp_transport/Repository/data_requester.dart';
import 'dart:convert';

import 'package:mp_transport/ads/native_app_widget.dart';

import '../admob.dart';

class VehicalDetails extends StatefulWidget {
  VehicalDetails({Key key}) : super(key: key);

  @override
  _VehicalDetailsState createState() => _VehicalDetailsState();
}

class _VehicalDetailsState extends State<VehicalDetails> {
  Map<String, dynamic> VehicleDataMap = null;

  bool isDataLoaded = false;
  bool showVehicleDetails = false;
  TextEditingController edtVehicleNumber = TextEditingController();

  var data;

  Future<Map<String, dynamic>> getVehicleData({String vehicleNumber}) async {
    vehicleNumber = vehicleNumber.toString().replaceAll(' ', '');
    String url =
        "https://mp-rto.herokuapp.com/vehical_details/" + vehicleNumber;
    print(url);
    var vehicalDataJson = await DataRequest(url).get_raw_data();

    Map<String, dynamic> vehicalDataMap = json.decode(vehicalDataJson);

    return vehicalDataMap;
  }

  AdmobManager admobManager = AdmobManager();

  Future datax = null;
  final _formKey = GlobalKey<FormState>();

  InterstitialAd myInterstitialx;
  @override
  void initState() {
    // TODO: implement initState
    myInterstitialx = admobManager.myInterstitial..load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        myInterstitialx.show();
        dispose();
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("वाहन खोज"),
          toolbarHeight: 50,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: edtVehicleNumber,
                                decoration: InputDecoration(
                                  labelText: "वाहन नंबर लिखें eg. MP04A2300",
                                  contentPadding: EdgeInsets.all(8),
                                  focusColor: Colors.blue,
                                  fillColor: Colors.black,
                                  //  hintText: "Vehicle number",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please enter vehicle number";
                                  } else if (RegExp(
                                          r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]')
                                      .hasMatch(value)) {
                                    return "Enter valid number ";
                                  } else if (value.length < 5) {
                                    return "Enter valid number ";
                                  }
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                datax = getVehicleData(
                                    vehicleNumber: edtVehicleNumber.text);
                              });
                            }
                          },
                          child: Text(
                            "खोजें",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                      future: datax,
                      builder: (context, datasnap) {
                        if (datasnap.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (datasnap.data == null) {
                          return Container();
                        }

                        if (datasnap.connectionState == ConnectionState.done &&
                            datasnap.hasData) {
                          print(datasnap.data.length);
                          Map<String, dynamic> data = datasnap.data;

                          if (data.containsKey("error_code")) {
                            return Center(
                              child: Text(
                                datasnap.data["error"],
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          } else {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  String subtitle = data.keys.elementAt(index);

                                  return Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            subtitle,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Divider(),
                                          ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: data[subtitle].length,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
                                                return Container(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                                data[subtitle]
                                                                    .keys
                                                                    .elementAt(
                                                                        index)),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              data[subtitle]
                                                                  .values
                                                                  .elementAt(
                                                                      index),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Divider()
                                                    ],
                                                  ),
                                                );
                                              })
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        }
                      }),
                  Card(child: nativeAdsView())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
