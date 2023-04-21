import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dharati/main.dart';
import 'package:dharati/screens/dosageCalculator.dart';
import 'package:dharati/services/FirebaseAllServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  //variables

  bool loading = true;
  bool get loadingSts => loading;
  final user = FirebaseAuth.instance.currentUser!;

  final _formKey = GlobalKey<FormState>();

  final _acres = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

  final _gunthas = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30",
    "31",
    "32",
    "33",
    "34",
    "35",
    "36",
    "37",
    "38",
    "39",
    "40"
  ];

  final mainCrops = ["ऊस"];

  final internalCrops = [
    "भुईमूग",
    "ज्वारी",
    "कांदा",
    "सोयाबीन",
    "भाजीपाला",
    "गहू"
  ];

  final irrigationTypes = ["ठिबक", "पारंपारिक"];

  final irrigationSources = ["बोअरवेल", "नदी", "विहीर"];

  final fertilizerTypes = ["सेंद्रिय", "रासायनिक"];

  String? selectedAcre = "0";
  String? selectedGuntha = "0";
  String? selectedMainCrop;
  String? selectedInternalCrop;
  String? selectedInrrigationType;
  String? selectedInrrigationSource;
  String? seletedFertilizerType;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "सुस्वागतम",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: loadingSts
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(25.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: "एकूण शेतजमीन",
                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.green.shade500, width: 2)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(18),
                            child: Row(
                              children: [
                                ButtonTheme(
                                  alignedDropdown: true,
                                  child: Expanded(
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        labelText: "एकर",
                                        labelStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.green.shade900,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: Colors.green.shade300,
                                              width: 1),
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      menuMaxHeight: 250,
                                      hint: Text("एकर"),
                                      value: selectedAcre,
                                      validator: (value) => (value == "0" &&
                                              selectedGuntha == "0")
                                          ? "कृपया एकर निवडा"
                                          : null,
                                      items: _acres
                                          .map((e) => DropdownMenuItem(
                                                child: Text(e),
                                                value: e,
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedAcre = value;
                                        });
                                      },
                                      onSaved: ((newValue) => setState(() {
                                            selectedAcre = newValue;
                                          })),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                ButtonTheme(
                                  alignedDropdown: true,
                                  child: Expanded(
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        labelText: "गुंठा",
                                        floatingLabelAlignment:
                                            FloatingLabelAlignment.start,
                                        labelStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.green.shade900,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: Colors.green.shade300,
                                              width: 1),
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      menuMaxHeight: 250,
                                      hint: Text("गुंठा"),
                                      value: selectedGuntha,
                                      validator: (value) =>
                                          (value == "0" && selectedAcre == "0")
                                              ? "कृपया गुंठा निवडा"
                                              : null,
                                      items: _gunthas
                                          .map((e) => DropdownMenuItem(
                                                child: Text(e),
                                                value: e,
                                              ))
                                          .toList(),
                                      onChanged: (value) => setState(() {
                                        selectedGuntha = value;
                                      }),
                                      onSaved: ((newValue) => setState(() {
                                            selectedGuntha = newValue;
                                          })),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "मुख्य पीक",
                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.green.shade900,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.green.shade500, width: 2),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight: 250,
                          isExpanded: true,
                          isDense: true,
                          hint: Text("मुख्य पीक निवडा"),
                          value: selectedMainCrop,
                          items: mainCrops
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            selectedMainCrop = value;
                          }),
                          onSaved: ((newValue) => setState(() {
                                selectedMainCrop = newValue;
                              })),
                          validator: (value) =>
                              value == null ? "कृपया मुख्य पीक निवडा" : null,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "अंतर्गत पीक",
                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.green.shade900,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.green.shade500, width: 2),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight: 250,
                          isExpanded: true,
                          isDense: true,
                          hint: Text("अंतर्गत पीक निवडा"),
                          value: selectedInternalCrop,
                          items: internalCrops
                              .map((e) => DropdownMenuItem<String>(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            selectedInternalCrop = value;
                          }),
                          onSaved: ((newValue) => setState(() {
                                selectedInternalCrop = newValue;
                              })),
                          validator: (value) =>
                              value == null ? "कृपया अंतर्गत पीक निवडा" : null,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "सिंचन प्रकार",
                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.green.shade900,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.green.shade500, width: 2),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight: 250,
                          isExpanded: true,
                          isDense: true,
                          hint: Text("सिंचन प्रकार निवडा"),
                          value: selectedInrrigationType,
                          items: irrigationTypes
                              .map((e) => DropdownMenuItem<String>(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            selectedInrrigationType = value;
                          }),
                          onSaved: ((newValue) => setState(() {
                                selectedInrrigationType = newValue;
                              })),
                          validator: (value) =>
                              value == null ? "कृपया सिंचन प्रकार निवडा" : null,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "सिंचन स्त्रोत",
                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.green.shade900,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.green.shade500, width: 2),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight: 250,
                          isExpanded: true,
                          isDense: true,
                          hint: Text("सिंचन स्त्रोत निवडा"),
                          value: selectedInrrigationSource,
                          items: irrigationSources
                              .map((e) => DropdownMenuItem<String>(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            selectedInrrigationSource = value;
                          }),
                          onSaved: ((newValue) => setState(() {
                                selectedInrrigationSource = newValue;
                              })),
                          validator: (value) => value == null
                              ? "कृपया सिंचन स्त्रोत निवडा"
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "खत प्रकार",
                            labelStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.green.shade900,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.green.shade500, width: 2),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight: 250,
                          isExpanded: true,
                          isDense: true,
                          hint: Text("खत प्रकार निवडा"),
                          value: seletedFertilizerType,
                          items: fertilizerTypes
                              .map((e) => DropdownMenuItem<String>(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            seletedFertilizerType = value;
                          }),
                          onSaved: ((newValue) => setState(() {
                                seletedFertilizerType = newValue;
                              })),
                          validator: (value) =>
                              value == null ? "कृपया खत प्रकार निवडा" : null,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FirebaseAllServices.instance.addData(
                                  selectedAcre!,
                                  selectedGuntha!,
                                  selectedMainCrop!,
                                  selectedInternalCrop!,
                                  selectedInrrigationType!,
                                  selectedInrrigationSource!,
                                  seletedFertilizerType!);
                            } else {
                              Get.snackbar(
                                "अवैध माहिती",
                                "सर्व माहिती अनिवार्य आहे!",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                isDismissible: true,
                                dismissDirection: DismissDirection.horizontal,
                                margin: EdgeInsets.all(15),
                                forwardAnimationCurve: Curves.easeOutBack,
                                colorText: Colors.white,
                              );
                            }
                          },
                          child: Text(
                            'जतन करा',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> getUserData() async {
    var document = await FirebaseFirestore.instance
        .collection("New Users")
        .doc(user.uid)
        .get();
    if (document.exists) {
      var data = document.data()!;
      setState(() {
        selectedAcre = data["Acre"];
        selectedGuntha = data["Guntha"];
        selectedMainCrop = data["Main Crop"];
        selectedInternalCrop = data["Internal Crop"];
        selectedInrrigationType = data["Irrigation Type"];
        selectedInrrigationSource = data["Irrigation Source"];
        seletedFertilizerType = data["Fertilizer Type"];
      });
      Future.delayed(Duration(seconds: 7), () {
        setState(() {
          loading = false;
        });
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }
}
