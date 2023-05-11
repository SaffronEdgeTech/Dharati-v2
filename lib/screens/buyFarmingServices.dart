import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dharati/screens/showFarmingServices.dart';
import 'package:dharati/widgets/NavDrawer.dart';
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
    {"id": "कृषी अवजारे", "label": "कृषी अवजारे"},
    {"id": "मनुष्यबळ", "label": "मनुष्यबळ"},
    {"id": "पशुधन", "label": "पशुधन"},
    {"id": "सेंद्रिय खते व तण नाशके", "label": "सेंद्रिय खते व तण नाशके"},
    {"id": "सिंचन व्यवस्था", "label": "सिंचन व्यवस्था"},
    {"id": "बियाणे", "label": "बियाणे"},
    {"id": "विद्युत व्यवस्था", "label": "विद्युत व्यवस्था"},
    {"id": "वाहतूक व्यवस्था", "label": "वाहतूक व्यवस्था"},
  ];
  List<dynamic> allSevaTypes = [
    {"id": "ट्रॅक्टर", "label": "ट्रॅक्टर", "parentId": "कृषी अवजारे"},
    {"id": "रोटाव्हेटर", "label": "रोटाव्हेटर", "parentId": "कृषी अवजारे"},
    {"id": "पलटी नांगर", "label": "पलटी नांगर", "parentId": "कृषी अवजारे"},
    {"id": "ट्रेलर", "label": "ट्रेलर", "parentId": "कृषी अवजारे"},
    {"id": "फवारणी यंत्र", "label": "फवारणी यंत्र", "parentId": "कृषी अवजारे"},
    {"id": "बोअरवेल", "label": "बोअरवेल", "parentId": "कृषी अवजारे"},
    {"id": "तोडणी यंत्र", "label": "तोडणी यंत्र", "parentId": "कृषी अवजारे"},
    {"id": "मळणी यंत्र", "label": "मळणी यंत्र", "parentId": "कृषी अवजारे"},
    {
      "id": "कल्टिव्हेटर / मशागत",
      "label": "कल्टिव्हेटर / मशागत",
      "parentId": "कृषी अवजारे"
    },
    {
      "id": "हॅरो / दंताळे",
      "label": "हॅरो / दंताळे",
      "parentId": "कृषी अवजारे"
    },
    {"id": "पेरणी यंत्र", "label": "पेरणी यंत्र", "parentId": "कृषी अवजारे"},
    {"id": "ड्रोन", "label": "ड्रोन", "parentId": "कृषी अवजारे"},
    {"id": "जेसिबी", "label": "जेसिबी", "parentId": "कृषी अवजारे"},
    {"id": "हार्वेस्टर", "label": "हार्वेस्टर", "parentId": "कृषी अवजारे"},
    {"id": "ट्रॅक्टर फळी", "label": "ट्रॅक्टर फळी", "parentId": "कृषी अवजारे"},
    {"id": "पॉवर टिलर", "label": "पॉवर टिलर", "parentId": "कृषी अवजारे"},
    {"id": "मशागत", "label": "मशागत", "parentId": "मनुष्यबळ"},
    {"id": "मळणी", "label": "मळणी", "parentId": "मनुष्यबळ"},
    {"id": "कोळपणी", "label": "कोळपणी", "parentId": "मनुष्यबळ"},
    {"id": "फवारणी", "label": "फवारणी", "parentId": "मनुष्यबळ"},
    {"id": "तोडणी", "label": "तोडणी", "parentId": "मनुष्यबळ"},
    {"id": "पेरणी", "label": "पेरणी", "parentId": "मनुष्यबळ"},
    {"id": "इतर", "label": "इतर", "parentId": "मनुष्यबळ"},
    {"id": "बैलजोडी", "label": "बैलजोडी", "parentId": "पशुधन"},
    {
      "id": "शेळ्या - मेंढ्या",
      "label": "शेळ्या - मेंढ्या",
      "parentId": "पशुधन"
    },
    {"id": "शेणखत", "label": "शेणखत", "parentId": "सेंद्रिय खते व तण नाशके"},
    {
      "id": "गांडूळखत",
      "label": "गांडूळखत",
      "parentId": "सेंद्रिय खते व तण नाशके"
    },
    {
      "id": "पंचगव्य",
      "label": "पंचगव्य",
      "parentId": "सेंद्रिय खते व तण नाशके"
    },
    {
      "id": "जीवामृत",
      "label": "जीवामृत",
      "parentId": "सेंद्रिय खते व तण नाशके"
    },
    {
      "id": "दशपर्णी",
      "label": "दशपर्णी",
      "parentId": "सेंद्रिय खते व तण नाशके"
    },
    {
      "id": "कंपोस्ट",
      "label": "कंपोस्ट",
      "parentId": "सेंद्रिय खते व तण नाशके"
    },
    {"id": "इतर", "label": "इतर", "parentId": "सेंद्रिय खते व तण नाशके"},
    {
      "id": "बोअरवेल खुदाई",
      "label": "बोअरवेल खुदाई",
      "parentId": "सिंचन व्यवस्था"
    },
    {
      "id": "बोअरवेल मोटर",
      "label": "बोअरवेल मोटर",
      "parentId": "सिंचन व्यवस्था"
    },
    {
      "id": "जलव्यवस्थापन",
      "label": "जलव्यवस्थापन",
      "parentId": "सिंचन व्यवस्था"
    },
    {"id": "विहीर खुदाई", "label": "विहीर खुदाई", "parentId": "सिंचन व्यवस्था"},
    {
      "id": "विहीर गाळ काढणे",
      "label": "विहीर गाळ काढणे",
      "parentId": "सिंचन व्यवस्था"
    },
    {"id": "विहीर मोटर", "label": "विहीर मोटर", "parentId": "सिंचन व्यवस्था"},
    {
      "id": "भूअंतर्गत जलवाहिनी (PVC Pipes) आणि हार्डवेअर",
      "label": "भूअंतर्गत जलवाहिनी (PVC Pipes) आणि हार्डवेअर",
      "parentId": "सिंचन व्यवस्था"
    },
    {
      "id": "ठिबक सिंचन व्यवस्थापन",
      "label": "ठिबक सिंचन व्यवस्थापन",
      "parentId": "सिंचन व्यवस्था"
    },
    {"id": "इतर", "label": "इतर", "parentId": "सिंचन व्यवस्था"},
    {"id": "भात", "label": "भात", "parentId": "बियाणे"},
    {"id": "बाजरी", "label": "बाजरी", "parentId": "बियाणे"},
    {"id": "रब्बी ज्वारी", "label": "रब्बी ज्वारी", "parentId": "बियाणे"},
    {"id": "खरीप ज्वारी", "label": "खरीप ज्वारी", "parentId": "बियाणे"},
    {"id": "गहू", "label": "गहू", "parentId": "बियाणे"},
    {"id": "मका", "label": "मका", "parentId": "बियाणे"},
    {"id": "नाचणी", "label": "नाचणी", "parentId": "बियाणे"},
    {"id": "वरी", "label": "वरी", "parentId": "बियाणे"},
    {"id": "बर्टी", "label": "बर्टी", "parentId": "बियाणे"},
    {"id": "हरभरा", "label": "हरभरा", "parentId": "बियाणे"},
    {"id": "तूर", "label": "तूर", "parentId": "बियाणे"},
    {"id": "मूग", "label": "मूग", "parentId": "बियाणे"},
    {"id": "उडीद", "label": "उडीद", "parentId": "बियाणे"},
    {"id": "कुळीथ", "label": "कुळीथ", "parentId": "बियाणे"},
    {"id": "मटकी", "label": "मटकी", "parentId": "बियाणे"},
    {"id": "राजमा", "label": "राजमा", "parentId": "बियाणे"},
    {"id": "चवळी", "label": "चवळी", "parentId": "बियाणे"},
    {"id": "भुईमूग", "label": "भुईमूग", "parentId": "बियाणे"},
    {"id": "सोयाबीन", "label": "सोयाबीन", "parentId": "बियाणे"},
    {"id": "सूर्यफूल", "label": "सूर्यफूल", "parentId": "बियाणे"},
    {"id": "करडई", "label": "करडई", "parentId": "बियाणे"},
    {"id": "तीळ", "label": "तीळ", "parentId": "बियाणे"},
    {"id": "ऊस", "label": "ऊस", "parentId": "बियाणे"},
    {"id": "ऊस रोपे", "label": "ऊस रोपे", "parentId": "बियाणे"},
    {"id": "कापूस", "label": "कापूस", "parentId": "बियाणे"},
    {"id": "आंबा", "label": "आंबा", "parentId": "बियाणे"},
    {"id": "केळी", "label": "केळी", "parentId": "बियाणे"},
    {"id": "द्राक्ष", "label": "द्राक्ष", "parentId": "बियाणे"},
    {"id": "डाळिंब", "label": "डाळिंब", "parentId": "बियाणे"},
    {"id": "चिक्कू", "label": "चिक्कू", "parentId": "बियाणे"},
    {"id": "पेरू", "label": "पेरू", "parentId": "बियाणे"},
    {"id": "कांदा", "label": "कांदा", "parentId": "बियाणे"},
    {"id": "मिरची", "label": "मिरची", "parentId": "बियाणे"},
    {"id": "टोमॅटो", "label": "टोमॅटो", "parentId": "बियाणे"},
    {"id": "वांगी", "label": "वांगी", "parentId": "बियाणे"},
    {"id": "भेंडी", "label": "भेंडी", "parentId": "बियाणे"},
    {"id": "वाल", "label": "वाल", "parentId": "बियाणे"},
    {"id": "कोबी", "label": "कोबी", "parentId": "बियाणे"},
    {"id": "फुलकोबी", "label": "फुलकोबी", "parentId": "बियाणे"},
    {"id": "मेथी", "label": "मेथी", "parentId": "बियाणे"},
    {"id": "पालक", "label": "पालक", "parentId": "बियाणे"},
    {"id": "ब्रोकोली", "label": "ब्रोकोली", "parentId": "बियाणे"},
    {"id": "बटाटा", "label": "बटाटा", "parentId": "बियाणे"},
    {"id": "हळद", "label": "हळद", "parentId": "बियाणे"},
    {"id": "आले", "label": "आले", "parentId": "बियाणे"},
    {"id": "वाटाणा", "label": "वाटाणा", "parentId": "बियाणे"},
    {"id": "इतर", "label": "इतर", "parentId": "बियाणे"},
    {
      "id": "बोअरवेल मोटर",
      "label": "बोअरवेल मोटर",
      "parentId": "विद्युत व्यवस्था"
    },
    {"id": "विहीर मोटर", "label": "विहीर मोटर", "parentId": "विद्युत व्यवस्था"},
    {
      "id": "उपसा सिंचन मोटर (१० HP पेक्षा अधिक)",
      "label": "उपसा सिंचन मोटर (१० HP पेक्षा अधिक)",
      "parentId": "विद्युत व्यवस्था"
    },
    {"id": "इतर", "label": "इतर", "parentId": "विद्युत व्यवस्था"},
    {
      "id": "ट्रॅक्टर - छोटा",
      "label": "ट्रॅक्टर - छोटा",
      "parentId": "वाहतूक व्यवस्था"
    },
    {
      "id": "ट्रॅक्टर - मोठा",
      "label": "ट्रॅक्टर - मोठा",
      "parentId": "वाहतूक व्यवस्था"
    },
    {
      "id": "टेम्पो - लहान",
      "label": "टेम्पो - लहान",
      "parentId": "वाहतूक व्यवस्था"
    },
    {
      "id": "टेम्पो - मध्यम",
      "label": "टेम्पो - मध्यम",
      "parentId": "वाहतूक व्यवस्था"
    },
    {
      "id": "टेम्पो - मोठा",
      "label": "टेम्पो - मोठा",
      "parentId": "वाहतूक व्यवस्था"
    },
    {"id": "बैलगाडी", "label": "बैलगाडी", "parentId": "वाहतूक व्यवस्था"},
    {"id": "ट्रक", "label": "ट्रक", "parentId": "वाहतूक व्यवस्था"},
    {"id": "इतर", "label": "इतर", "parentId": "वाहतूक व्यवस्था"},
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
      drawer: NavDrawer(details: userDetailsMap),
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
    seva = seva.replaceAll(" ", "");
    sevaType = sevaType.replaceAll(" ", "");
    seva = seva.replaceAll("/", "");
    sevaType = sevaType.replaceAll("/", "");
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
