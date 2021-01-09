import 'dart:convert';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:mp_transport/License.dart';
import 'package:mp_transport/Repository/data_requester.dart';
import 'package:mp_transport/ads/native_app_widget.dart';
import 'dart:convert';
import 'dart:typed_data';

import '../admob.dart';

class LicenseDetails extends StatefulWidget {
  final License LicenseType;

  const LicenseDetails({Key key, this.LicenseType}) : super(key: key);

  @override
  _LicenseDetailsState createState() => _LicenseDetailsState();
}

Future<Map<String, dynamic>> getLicenseDetails(
    {String licenseNumber, String dob}) async {
  licenseNumber = licenseNumber.toString().replaceAll(' ', '');

  String url;
  if (dob == null) {
    url = "https://mp-rto.herokuapp.com/l_license_details/$licenseNumber/";
  } else {
//   MP07L009383/06
// MP51N-2019-0064688
    url =
        "https://mp-rto.herokuapp.com/license_details?reg_number=${licenseNumber}&dob=${dob}";
  }

  print(url);
  var licenseDataJson = await DataRequest(url).get_raw_data();
  print(licenseDataJson);
  Map<String, dynamic> licenseDataMap = json.decode(licenseDataJson);

  return licenseDataMap;
}

class _LicenseDetailsState extends State<LicenseDetails> {
  TextEditingController edtLicenseNumber = TextEditingController();
  TextEditingController edtDob = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future datax;

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
            title: Text(widget.LicenseType.title),
          ),
          body: Container(
            child: SingleChildScrollView(
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
                                    controller: edtLicenseNumber,
                                    decoration: InputDecoration(
                                      labelText: "लाइसेंस नंबर",
                                      contentPadding: EdgeInsets.all(8),
                                      focusColor: Colors.blue,
                                      fillColor: Colors.black,
                                      //  hintText: "Vehicle number",
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter License number";
                                      } else if (!RegExp(r'[a-zA-Z\\0-9]')
                                          .hasMatch(value)) {
                                        return "Enter valid Licendsse number ";
                                      } else if (value.length < 5) {
                                        return "Enter valid License number ";
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        widget.LicenseType is DrivingLicenese
                            ? Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: TextFormField(
                                          controller: edtDob,
                                          decoration: InputDecoration(
                                            labelText:
                                                "जन्मतिथि eg. 05/11/1999",
                                            contentPadding: EdgeInsets.all(8),
                                            focusColor: Colors.blue,
                                            fillColor: Colors.black,
                                            //  hintText: "Vehicle number",
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (widget.LicenseType
                                                is LearningLicenese) {
                                              if (value.isEmpty) {
                                                return "Please enter City name";
                                              } else if (RegExp(
                                                      r'[!@#<>?":_`~;[\]\\|=+)(*&^0-9%-]')
                                                  .hasMatch(value)) {
                                                return "Enter valid City name ";
                                              } else if (value.length < 5) {
                                                return "Enter valid City name ";
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.LicenseType is DrivingLicenese
                        ? Text(
                            """Note :	If License no is "MP04/003963/06" then enter "MP04/003963/06" with / or If License no is "MP07R-2006-0071951" then enter "MP07R-2006-0071951" """,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 11),
                          )
                        : Container(),
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
                                if (widget.LicenseType is LearningLicenese) {
                                  datax = getLicenseDetails(
                                      licenseNumber: edtLicenseNumber.text);
                                } else {
                                  datax = getLicenseDetails(
                                      licenseNumber: edtLicenseNumber.text,
                                      dob: edtDob.text);
                                }
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
                      builder: (BuildContext ctx, datasnap) {
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
                            // var x = datasnap.data.remove("classes");

                            String data = datasnap.data['user_img'];

                            Uint8List _bytes =
                                base64.decode(data.split(',').last);

                            return Column(children: [
                              Image.memory(_bytes),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: datasnap.data.length,
                                  itemBuilder: (BuildContext ctx, int indexx) {
                                    Map<String, dynamic> userData =
                                        datasnap.data;

                                    if (userData.keys.elementAt(indexx) ==
                                            "classes" ||
                                        userData.keys.elementAt(indexx) ==
                                            "user_img") {
                                      return Container();
                                    } else {
                                      return Column(children: [
                                        Row(children: [
                                          Expanded(
                                            child: Text(userData.keys
                                                .elementAt(indexx)
                                                .toString()),
                                          ),
                                          Expanded(
                                            child: Text(
                                              userData.values
                                                  .elementAt(indexx)
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ]),
                                        Divider()
                                      ]);
                                    }
                                  }),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Classes",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            datasnap.data["classes"].length,
                                        itemBuilder:
                                            (BuildContext ctx, int index) {
                                          var classesData = datasnap
                                              .data["classes"].values
                                              .elementAt(index);

                                          print(classesData);
                                          return Column(children: [
                                            Container(
                                              child: Stack(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 30.0),
                                                  child: Card(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount: classesData
                                                              .length,
                                                          itemBuilder:
                                                              (BuildContext ctx,
                                                                  int indexx) {
                                                            return Column(
                                                                children: [
                                                                  Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Text(classesData
                                                                              .keys
                                                                              .elementAt(indexx)
                                                                              .toString()),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            classesData.values.elementAt(indexx).toString(),
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold),
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
                                                        const EdgeInsets.only(
                                                            left: 6.0),
                                                    child: Card(
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      margin: EdgeInsets.all(0),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          (index + 1)
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ),
                                            Divider()
                                          ]);
                                        }),
                                  ]),
                            ]);
                          }
                        }
                      }),
                  Card(child: nativeAdsView())
                ],
              ),
            ),
          )),
    );
  }
}
