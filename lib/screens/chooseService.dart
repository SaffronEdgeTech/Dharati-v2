import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dharati/services/FirebaseAllServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChooseService extends StatefulWidget {
  const ChooseService({super.key});

  @override
  State<ChooseService> createState() => _ChooseServiceState();
}

class _ChooseServiceState extends State<ChooseService> {
  TextEditingController name = TextEditingController();
  TextEditingController surName = TextEditingController();
  bool loading = true;
  bool get loadingSts => loading;
  final user = FirebaseAuth.instance.currentUser!;
  String nextPage = "/userdetails";

  final _formKey = GlobalKey<FormState>();
  List<dynamic> allDistricts = [];
  List<dynamic> allTalukas = [];
  var availableTalukas = [];
  List<dynamic> allVillages = [];
  var availableVillages = [];
  String? selectedDistrict;
  String? selectedTaluka;
  String? selectedVillage;
  String? uID;
  String? phoneNum;
  var userDetailsMap = {
    "PhoneNum": "",
    "ID": "",
    "Dist": "",
    "Tal": "",
    "Vil": "",
    "State": ""
  };
  @override
  void initState() {
    super.initState();
    setState(() {
      uID = user.uid;
      phoneNum = user.phoneNumber;
      userDetailsMap["PhoneNum"] = phoneNum.toString();
      userDetailsMap["ID"] = uID.toString();
      userDetailsMap["State"] = "महाराष्ट्र";
      name.clear();
      surName.clear();
    });
    createDistList();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadingSts
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'सेवा निवडा',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: RadioListTile(
                                title: Text("खत व्यवस्थापन व तज्ञ सल्ला"),
                                value: "/userdetails",
                                groupValue: nextPage,
                                onChanged: (value) {
                                  setState(() {
                                    nextPage = value.toString();
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                title: Text("विक्री"),
                                value: "/sellProduct",
                                groupValue: nextPage,
                                onChanged: (value) {
                                  setState(() {
                                    nextPage = value.toString();
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: RadioListTile(
                                title: Text("खरेदी"),
                                value: "/buyProduct",
                                groupValue: nextPage,
                                onChanged: (value) {
                                  setState(() {
                                    nextPage = value.toString();
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                title: Text("शेती सेवा"),
                                value: "/buyFarmingServices",
                                groupValue: nextPage,
                                onChanged: (value) {
                                  setState(() {
                                    nextPage = value.toString();
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: name,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "नाव",
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
                                onChanged: (value) {
                                  setState(() {
                                    String uName = name.text.toString().trim();
                                    if (uName.isNotEmpty) {
                                      userDetailsMap["Name"] =
                                          uName[0].toUpperCase() +
                                              uName.substring(1);
                                    }
                                  });
                                },
                                validator: (value) =>
                                    (value == null || value.isEmpty)
                                        ? "कृपया नाव टाका"
                                        : null,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: surName,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "आडनाव",
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
                                onChanged: (value) {
                                  setState(() {
                                    String uSurname =
                                        surName.text.toString().trim();
                                    if (uSurname.isNotEmpty) {
                                      userDetailsMap["Surname"] =
                                          uSurname[0].toUpperCase() +
                                              uSurname.substring(1);
                                    }
                                  });
                                },
                                validator: (value) =>
                                    (value == null || value.isEmpty)
                                        ? "कृपया आडनाव टाका"
                                        : null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "जिल्हा",
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
                            hint: Text("जिल्हा निवडा"),
                            value: selectedDistrict,
                            items: allDistricts
                                .map((e) => DropdownMenuItem<String>(
                                      child: Text(e["label"]),
                                      value: e["id"],
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() {
                              selectedTaluka = null;
                              selectedVillage = null;
                              availableTalukas.clear();
                              availableVillages.clear();
                              selectedDistrict = value;
                              userDetailsMap["Dist"] =
                                  selectedDistrict.toString();

                              fetchTalukas(selectedDistrict);
                            }),
                            onSaved: ((newValue) => setState(() {
                                  selectedDistrict = newValue;
                                  userDetailsMap["Dist"] =
                                      selectedDistrict.toString();
                                })),
                            validator: (value) =>
                                value == null ? "कृपया जिल्हा निवडा" : null,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "तालुका",
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
                            hint: Text("तालुका निवडा"),
                            value: selectedTaluka,
                            items: availableTalukas
                                .map((e) => DropdownMenuItem<String>(
                                      child: Text(e["label"]),
                                      value: e["id"],
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() {
                              selectedVillage = null;
                              availableVillages.clear();
                              selectedTaluka = value;
                              userDetailsMap["Tal"] = selectedTaluka.toString();
                              fetchVillages(selectedTaluka);
                            }),
                            onSaved: ((newValue) => setState(() {
                                  selectedTaluka = newValue;
                                  userDetailsMap["Tal"] =
                                      selectedTaluka.toString();
                                })),
                            validator: (value) =>
                                value == null ? "कृपया तालुका निवडा" : null,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "गाव",
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
                            hint: Text("गाव निवडा"),
                            value: selectedVillage,
                            items: availableVillages
                                .map((e) => DropdownMenuItem<String>(
                                      child: Text(e["label"]),
                                      value: e["id"],
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() {
                              selectedVillage = value;
                              userDetailsMap["Vil"] =
                                  selectedVillage.toString();
                            }),
                            onSaved: ((newValue) => setState(() {
                                  selectedVillage = newValue;
                                  userDetailsMap["Vil"] =
                                      selectedVillage.toString();
                                })),
                            validator: (value) =>
                                value == null ? "कृपया गाव निवडा" : null,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                FirebaseAllServices.instance.addInfo(
                                    selectedDistrict!,
                                    selectedTaluka!,
                                    selectedVillage!,
                                    name.text.toString().trim(),
                                    surName.text.toString().trim(),
                                    nextPage,
                                    userDetailsMap);
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
                              'पुढे जा',
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
            ),
    );
  }

  fetchTalukas(String? district) {
    setState(() {
      availableTalukas = allTalukas
          .where((element) => element["parentId"] == district)
          .toList();
    });
  }

  Future<void> createDistList() async {
    final jsonDistrictsData =
        await rootBundle.loadString("assets/JSON Files/Districts.json");
    List<dynamic> districtsList =
        json.decode(jsonDistrictsData) as List<dynamic>;
    setState(() {
      allDistricts = districtsList;
    });
    final jsonTalukasData =
        await rootBundle.loadString("assets/JSON Files/Talukas.json");
    List<dynamic> talukasList =
        await json.decode(jsonTalukasData) as List<dynamic>;
    setState(() {
      allTalukas = talukasList;
    });
    final jsonVillagesData =
        await rootBundle.loadString("assets/JSON Files/Villages.json");
    List<dynamic> villagesList =
        await json.decode(jsonVillagesData) as List<dynamic>;
    setState(() {
      allVillages = villagesList;
    });
  }

  fetchVillages(String? taluka) {
    setState(() {
      availableVillages = allVillages
          .where((element) => element["parentId"] == taluka)
          .toList();
    });
  }

  Future<void> getUserData() async {
    var document = await FirebaseFirestore.instance
        .collection("New Users")
        .doc(user.uid)
        .get();
    if (document.exists) {
      var data = document.data()!;
      setState(() {
        selectedDistrict = data["District"];
        selectedTaluka = data["Taluka"];
        selectedVillage = data["Village"];
        name.text = data["Name"];
        surName.text = data["Surname"];
        userDetailsMap["Dist"] = selectedDistrict.toString();
        userDetailsMap["Tal"] = selectedTaluka.toString();
        userDetailsMap["Vil"] = selectedVillage.toString();
        userDetailsMap["State"] = "महाराष्ट्र";
        userDetailsMap["Name"] = name.text.toString();
        userDetailsMap["Surname"] = surName.text.toString();
        fetchTalukas(selectedDistrict);
        fetchVillages(selectedTaluka);
      });
      Future.delayed(Duration(seconds: 5), () {
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
