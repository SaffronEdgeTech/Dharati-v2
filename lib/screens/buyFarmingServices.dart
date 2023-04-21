import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dharati/screens/showFarmingServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BuyFarmingServices extends StatefulWidget {
  const BuyFarmingServices({super.key});

  @override
  State<BuyFarmingServices> createState() => _BuyFarmingServicesState();
}

class _BuyFarmingServicesState extends State<BuyFarmingServices> {
  final _formKey = GlobalKey<FormState>();

  TextStyle labelTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.green.shade600,
  );
  List<dynamic> documents = [];
  List<dynamic> seva = [
    {"id": "अवजारे", "label": "अवजारे"},
    {"id": "मनुष्यबळ", "label": "मनुष्यबळ"}
  ];
  List<dynamic> allSevaTypes = [
    {"id": "ट्रॅक्टर", "label": "ट्रॅक्टर", "parentId": "अवजारे"},
    {"id": "रोटाव्हेटर", "label": "रोटाव्हेटर", "parentId": "अवजारे"},
    {"id": "पलटी नांगर", "label": "पलटी नांगर", "parentId": "अवजारे"},
    {"id": "ट्रेलर", "label": "ट्रेलर", "parentId": "अवजारे"},
    {"id": "फवारणी यंत्र", "label": "फवारणी यंत्र", "parentId": "अवजारे"},
    {"id": "बोअरवेल", "label": "बोअरवेल", "parentId": "अवजारे"},
    {"id": "तोडणी यंत्र", "label": "तोडणी यंत्र", "parentId": "अवजारे"},
    {"id": "मळणी यंत्र", "label": "मळणी यंत्र", "parentId": "अवजारे"},
    {
      "id": "कल्टिव्हेटर / मशागत",
      "label": "कल्टिव्हेटर / मशागत",
      "parentId": "अवजारे"
    },
    {"id": "हॅरो / दंताळे", "label": "हॅरो / दंताळे", "parentId": "अवजारे"},
    {"id": "पेरणी यंत्र", "label": "पेरणी यंत्र", "parentId": "अवजारे"},
    {"id": "ड्रोन", "label": "ड्रोन", "parentId": "अवजारे"},
    {"id": "जेसिबी", "label": "जेसिबी", "parentId": "अवजारे"},
    {"id": "हार्वेस्टर", "label": "हार्वेस्टर", "parentId": "अवजारे"},
    {"id": "ट्रॅक्टर फळी", "label": "ट्रॅक्टर फळी", "parentId": "अवजारे"},
    {"id": "मनुष्यबळ", "label": "मनुष्यबळ", "parentId": "मनुष्यबळ"},
  ];
  final counts = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  var sevaTypes = [];
  String? selectedSeva;
  String? selectedSevaType;
  String? count = "1";
  TextEditingController _date = TextEditingController();
  num dateInMs = 0;
  String sevaLevel = "Village";
  String? phoneNumber;
  var distTalVil = {};
 

  @override
  Widget build(BuildContext context) {
    final Map userDetailsMap =
        ModalRoute.of(context)!.settings.arguments as Map;
    distTalVil["District"] = userDetailsMap["Dist"].toString();
    distTalVil["Taluka"] = userDetailsMap["Tal"].toString();
    distTalVil["Village"] = userDetailsMap["Vil"].toString();
    distTalVil["State"] = userDetailsMap["State"].toString();
    phoneNumber = userDetailsMap["PhoneNum"].toString();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "शेती सेवा",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "सेवा निवड",
                        style: labelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ButtonTheme(
                      alignedDropdown: true,
                      child: Expanded(
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: Colors.green.shade300, width: 1),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(5),
                          menuMaxHeight: 250,
                          isExpanded: true,
                          isDense: true,
                          hint: Text("सेवा निवडा"),
                          value: selectedSeva,
                          validator: (value) =>
                              value == null ? "कृपया सेवा निवडा" : null,
                          items: seva
                              .map((e) => DropdownMenuItem<String>(
                                    child: Text(e["label"]),
                                    value: e["id"],
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            selectedSevaType = null;
                            sevaTypes.clear();
                            selectedSeva = value;
                            sevaTypes = allSevaTypes
                                .where((element) =>
                                    element["parentId"] == selectedSeva)
                                .toList();
                          }),
                          onSaved: (newValue) => setState(() {
                            selectedSeva = newValue;
                          }),
                        ),
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
                      child: Text(
                        "सेवा प्रकार",
                        style: labelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ButtonTheme(
                      alignedDropdown: true,
                      child: Expanded(
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: Colors.green.shade300, width: 1),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(5),
                          menuMaxHeight: 250,
                          isExpanded: true,
                          isDense: true,
                          hint: Text("सेवा प्रकार"),
                          value: selectedSevaType,
                          validator: (value) =>
                              value == null ? "कृपया सेवा प्रकार निवडा" : null,
                          items: sevaTypes
                              .map((e) => DropdownMenuItem<String>(
                                    child: Text(e["label"]),
                                    value: e["id"],
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            selectedSevaType = value;
                          }),
                          onSaved: (newValue) => setState(() {
                            selectedSevaType = newValue;
                          }),
                        ),
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
                      child: Text(
                        "संख्या",
                        style: labelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ButtonTheme(
                      alignedDropdown: true,
                      child: Expanded(
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: Colors.green.shade300, width: 1),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(5),
                          menuMaxHeight: 250,
                          isExpanded: true,
                          isDense: true,
                          hint: Text("संख्या"),
                          value: count,
                          validator: (value) =>
                              value == null ? "कृपया संख्या निवडा" : null,
                          items: counts
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            count = value;
                          }),
                          onSaved: (newValue) => setState(() {
                            count = newValue;
                          }),
                        ),
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
                      child: Text(
                        "सेवा दिवस",
                        style: labelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _date,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month_rounded),
                          hintText: "दिवस निवडा",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Colors.green.shade300, width: 1),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 730),
                            ),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _date.text =
                                  DateFormat("dd-MM-yyyy").format(selectedDate);
                              dateInMs = selectedDate.millisecondsSinceEpoch;
                            });
                          }
                        },
                        validator: (value) =>
                            _date.text == "" ? "कृपया दिवस निवडा" : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'सेवा क्षेत्र',
                  style: labelTextStyle,
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: Text("गाव पातळी"),
                        value: "Village",
                        groupValue: sevaLevel,
                        onChanged: (value) {
                          setState(() {
                            sevaLevel = value.toString();
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text("तालुका पातळी"),
                        value: "Taluka",
                        groupValue: sevaLevel,
                        onChanged: (value) {
                          setState(() {
                            sevaLevel = value.toString();
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
                        title: Text("जिल्हा पातळी"),
                        value: "District",
                        groupValue: sevaLevel,
                        onChanged: (value) {
                          setState(() {
                            sevaLevel = value.toString();
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text("राज्य पातळी"),
                        value: "State",
                        groupValue: sevaLevel,
                        onChanged: (value) {
                          setState(() {
                            sevaLevel = value.toString();
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        documents.clear();
                        fetchFarmingServices(selectedSeva!, selectedSevaType!);
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
                      'शोध करा',
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
                SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Get.offNamed("/sellFarmingServices",
                          arguments: userDetailsMap);
                    },
                    child: Text(
                      'स्वतः ची सेवा नोंद करा',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void fetchFarmingServices(String seva, String sevaType) {
    Get.snackbar(
      "कृपया प्रतिक्षा करा...",
      "सेवा शोधत आहोत.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.all(15),
      forwardAnimationCurve: Curves.easeOutBack,
      colorText: Colors.white,
    );
    FirebaseFirestore.instance
        .collectionGroup(seva + sevaType)
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        var data = doc.data();
        String phoneNum = data["Phone Number"].toString();
        String startDate = data["Start Date ms"].toString();
        String endDate = data["End Date ms"].toString();
        String level = data["Service Level"].toString();
        String loc = data[sevaLevel].toString();
        if (phoneNum != phoneNumber.toString() &&
            startDate.compareTo(dateInMs.toString()) <= 0 &&
            endDate.compareTo(dateInMs.toString()) >= 0 &&
            level == sevaLevel.toString() &&
            loc == distTalVil[sevaLevel].toString()) {
          setState(() {
            documents.add(data);
          });
        }
      });
    }).whenComplete(() {
      if (documents.isNotEmpty) {
        Future.delayed(Duration(seconds: 5), () {
          Navigator.pushNamed(context, "/showServices", arguments: documents);
        });
      } else {
        Get.snackbar(
          "तसदीबद्दल क्षमस्व",
          "सेवा उबलब्ध नाही",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          margin: EdgeInsets.all(15),
          forwardAnimationCurve: Curves.easeOutBack,
          colorText: Colors.white,
        );
      }
    });
  }
}
