import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dharati/services/FirebaseAllServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SellFarmingServices extends StatefulWidget {
  const SellFarmingServices({super.key});

  @override
  State<SellFarmingServices> createState() => _SellFarmingServicesState();
}

class _SellFarmingServicesState extends State<SellFarmingServices> {
  String? dist;
  String? tal;
  String? vil;
  String? state;
  final _formKey = GlobalKey<FormState>();
  TextStyle labelTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.green.shade600,
  );
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
    {"id": "हार्वेस्टर", "label": "हार्वेस्टर", "parentId": "अवजारे"},
    {"id": "ट्रॅक्टर फळी", "label": "ट्रॅक्टर फळी", "parentId": "अवजारे"},
    {"id": "मनुष्यबळ", "label": "मनुष्यबळ", "parentId": "मनुष्यबळ"},
  ];
  final counts = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  var sevaTypes = [];
  String? selectedSeva;
  String? selectedSevaType;
  String? count = "1";
  TextEditingController _startDate = TextEditingController();
  TextEditingController _endDate = TextEditingController();
  var dateStartInMs;
  var dateEndInMs;
  String? phoneNum;
  String sevaLevel = "Village";
  DateTime dateTimeEnd = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Map userDetails = ModalRoute.of(context)!.settings.arguments as Map;
    dist = userDetails["Dist"].toString();
    tal = userDetails["Tal"].toString();
    vil = userDetails["Vil"].toString();
    state = userDetails["State"].toString();
    phoneNum = userDetails["PhoneNum"].toString();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "सेवा नोंदणी",
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
                        "सेवा पासून",
                        style: labelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _startDate,
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
                              dateTimeEnd =
                                  selectedDate.add(const Duration(days: 1));
                              _startDate.text =
                                  DateFormat("dd-MM-yyyy").format(selectedDate);
                              dateStartInMs =
                                  selectedDate.millisecondsSinceEpoch;
                            });
                          }
                        },
                        validator: (value) =>
                            _startDate.text == "" ? "कृपया दिवस निवडा" : null,
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
                        "सेवा पर्यंत",
                        style: labelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _endDate,
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
                            initialDate: dateTimeEnd,
                            firstDate: dateTimeEnd,
                            lastDate: dateTimeEnd.add(
                              const Duration(days: 730),
                            ),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _endDate.text =
                                  DateFormat("dd-MM-yyyy").format(selectedDate);
                              dateEndInMs = selectedDate.millisecondsSinceEpoch;
                            });
                          }
                        },
                        validator: (value) =>
                            _endDate.text == "" ? "कृपया दिवस निवडा" : null,
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
                        FirebaseAllServices.instance.addFarmingServices(
                            selectedSeva!,
                            selectedSevaType!,
                            _startDate.text,
                            dateStartInMs!,
                            _endDate.text,
                            dateEndInMs!,
                            sevaLevel,
                            dist!,
                            tal!,
                            vil!,
                            userDetails);
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
                      'नोंदणी करा',
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
}
