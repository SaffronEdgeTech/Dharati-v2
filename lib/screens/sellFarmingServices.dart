import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dharati/services/FirebaseAllServices.dart';
import 'package:dharati/widgets/NavDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

class SellFarmingServices extends StatefulWidget {
  const SellFarmingServices({super.key});

  @override
  State<SellFarmingServices> createState() => _SellFarmingServicesState();
}

class _SellFarmingServicesState extends State<SellFarmingServices> {
  TextEditingController otp = TextEditingController();
  String? dist;
  String? tal;
  String? vil;
  String? state;
  String verifyId = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextStyle labelTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.green.shade600,
  );
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
  TextEditingController _startDate = TextEditingController();
  TextEditingController _endDate = TextEditingController();
  var dateStartInMs;
  var dateEndInMs;
  String? phoneNum;
  String? name;
  String? surName;
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
    name = userDetails["Name"].toString();
    surName = userDetails["Surname"].toString();
    return Scaffold(
      appBar: AppBar(
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
      drawer: NavDrawer(details: userDetails),
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
                              _endDate.clear();
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
                        phoneAuthentication(
                            _auth.currentUser!.phoneNumber.toString());
                        Future.delayed(const Duration(seconds: 1), () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text(
                                    '$phoneNum या संपर्क क्रमांकाला पाठवलेला ओटीपी टाका',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: CupertinoTextField(
                                    autofocus: true,
                                    maxLength: 6,
                                    controller: otp,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onSubmitted: (value) async {
                                      verifyOTP();
                                    },
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "रद्द करा",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        verifyOTP();
                                      },
                                      child: const Text(
                                        "सत्यापित करा",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        });
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

  Future<void> phoneAuthentication(String phoneNum) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNum,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential).then((value) {
            Navigator.pop(context);
            addData();
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar(
            "तसदीबद्दल क्षमस्व",
            e.message!,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            margin: EdgeInsets.all(15),
            forwardAnimationCurve: Curves.easeOutBack,
            colorText: Colors.white,
          );
        },
        codeSent: (verificationId, resendToken) {
          this.verifyId = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verifyId = verificationId;
        },
        timeout: Duration(seconds: 60),
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "तसदीबद्दल क्षमस्व",
        e.message!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(15),
        forwardAnimationCurve: Curves.easeOutBack,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "तसदीबद्दल क्षमस्व",
        "ओटीपी तपासून पहा!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(15),
        forwardAnimationCurve: Curves.easeOutBack,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> OTPVerification(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: this.verifyId, smsCode: otp);
      var credentials = await _auth.signInWithCredential(credential);
      return credentials.user != null ? true : false;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "तसदीबद्दल क्षमस्व",
        e.message!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(15),
        forwardAnimationCurve: Curves.easeOutBack,
        colorText: Colors.white,
      );
    }
    return false;
  }

  void verifyOTP() async {
    if (otp.length == 6) {
      var isVerified = await OTPVerification(otp.text);
      if (isVerified) {
        Navigator.pop(context);
        addData();
      } else {
        Get.snackbar(
          "तसदीबद्दल क्षमस्व",
          "ओटीपी तपासून पहा!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          margin: EdgeInsets.all(15),
          forwardAnimationCurve: Curves.easeOutBack,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "तसदीबद्दल क्षमस्व",
        "ओटीपी तपासून पहा!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(15),
        forwardAnimationCurve: Curves.easeOutBack,
        colorText: Colors.white,
      );
    }
  }

  void addData() {
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
        name!,
        surName!);
  }
}
