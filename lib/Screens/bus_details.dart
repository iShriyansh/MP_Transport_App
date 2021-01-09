import 'dart:collection';
import 'dart:convert';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:mp_transport/Repository/data_requester.dart';
import 'package:mp_transport/ads/native_app_widget.dart';

import '../admob.dart';

class BusDetails extends StatefulWidget {
  @override
  _BusDetailsState createState() => _BusDetailsState();
}

class _BusDetailsState extends State<BusDetails> {
  TextEditingController edtSource = TextEditingController();
  TextEditingController edtDEstination = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future datax = null;

  Future<Map<String, dynamic>> getBusData(
      {String source, String destination}) async {
    source = source.toString().replaceAll(' ', '');
    destination = destination.toString().replaceAll(' ', '');

    String url = "https://mp-rto.herokuapp.com/bus_tt/$source/$destination/";
    print(url);
    var busDetails = await DataRequest(url).get_raw_data();

    Map<String, dynamic> busDetailsMap = json.decode(busDetails);
    print(busDetailsMap);
    return busDetailsMap;
  }

  AdmobManager admobManager = AdmobManager();
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
        myInterstitialx..show();
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          title: Text("बस समय - तालिका"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                controller: edtSource,
                                decoration: InputDecoration(
                                  labelText: "सोर्स पता eg. Jabalpur",
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
                                          r'[!@#<>?":_`~;[\]\\|=+)(*&1-9^%-]')
                                      .hasMatch(value)) {
                                    return "Enter valid number ";
                                  } else if (value.length < 5) {
                                    return "Enter valid number ";
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextFormField(
                                controller: edtDEstination,
                                decoration: InputDecoration(
                                  labelText: "डेस्टिनेशन पता eg. Indore",
                                  contentPadding: EdgeInsets.all(8),
                                  focusColor: Colors.blue,
                                  fillColor: Colors.black,
                                  //  hintText: "Vehicle number",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please enter City name";
                                  } else if (RegExp(
                                          r'[!@#<>?":_`~;[\]\\|=+)(*&^0-9%-]')
                                      .hasMatch(value)) {
                                    return "Enter valid City name ";
                                  } else if (value.length < 5) {
                                    return "Enter valid City name ";
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                            datax = getBusData(
                                source: edtSource.text,
                                destination: edtDEstination.text);
                          });
                        }
                      },
                      child: Text(
                        "खोजें ",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                  future: datax,
                  builder: (BuildContext ctx, datasnap) {
                    if (datasnap.connectionState == ConnectionState.waiting) {
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
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              String subtitle = data.keys.elementAt(index);

                              return Column(children: [
                                Container(
                                  child: Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  data[subtitle].length - 1,
                                              itemBuilder: (BuildContext ctx,
                                                  int indexx) {
                                                Map<String, dynamic> datax =
                                                    data[subtitle];

                                                Map<String, dynamic> sortedMap =
                                                    {
                                                  "Origin": datax["Origin"],
                                                  "Destination":
                                                      datax["Destination"],
                                                  "Dept.Time":
                                                      datax["Dept.Time"],
                                                  "Arrival At Destination": datax[
                                                      "Arrival At Destination"],
                                                  "Service type":
                                                      datax["Service type"],
                                                  "Vehicle Number":
                                                      datax["Vehicle Number"],
                                                  "Service type":
                                                      datax["Service type"],
                                                  "Fitness validity":
                                                      datax["Fitness validity"],
                                                };

                                                return Column(children: [
                                                  Row(children: [
                                                    Expanded(
                                                      child: Text(sortedMap.keys
                                                          .elementAt(indexx)),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        sortedMap.values
                                                            .elementAt(indexx),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ]),
                                                  Divider()
                                                ]);
                                              }),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 6.0),
                                        child: Card(
                                          color: Colors.lightBlueAccent,
                                          margin: EdgeInsets.all(0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              (index + 1).toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                Divider()
                              ]);
                            });
                      }
                    }
                  }),
              Card(child: nativeAdsView())
            ],
          ),
        ),
      ),
    );
  }
}
