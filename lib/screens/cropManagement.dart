import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dharati/main.dart';
import 'package:dharati/screens/dosageCalculator.dart';
import 'package:dharati/services/FirebaseAllServices.dart';
import 'package:dharati/widgets/NavDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_file/internet_file.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pdfx/pdfx.dart';

class CropManagement extends StatefulWidget {
  const CropManagement({super.key});

  @override
  State<CropManagement> createState() => _CropManagementState();
}

class _CropManagementState extends State<CropManagement> {
  //variables

  bool loading = false;
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
  TextEditingController _date = TextEditingController();
  num dateInMs = 0;
  final mainCrops = ["ऊस"];
  TextStyle labelTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.green.shade600,
  );
  List<dynamic> cropTypes = [
    {"id": "तृणधान्य पीक", "label": "तृणधान्य पीक"},
    {"id": "कडधान्य पीक", "label": "कडधान्य पीक"},
    {"id": "गळीतधान्य पीक", "label": "गळीतधान्य पीक"},
    {"id": "नगदी पीक", "label": "नगदी पीक"},
    {"id": "चारा", "label": "चारा"},
    {"id": "फळे", "label": "फळे"},
    {"id": "भाजीपाला", "label": "भाजीपाला"}
  ];

  List<dynamic> cropNames = [
    {"id": "भात", "label": "भात", "parentId": "तृणधान्य पीक"},
    {"id": "बाजरी", "label": "बाजरी", "parentId": "तृणधान्य पीक"},
    {"id": "रब्बी ज्वारी", "label": "रब्बी ज्वारी", "parentId": "तृणधान्य पीक"},
    {"id": "खरीप ज्वारी", "label": "खरीप ज्वारी", "parentId": "तृणधान्य पीक"},
    {"id": "गहू", "label": "गहू", "parentId": "तृणधान्य पीक"},
    {"id": "मका", "label": "मका", "parentId": "तृणधान्य पीक"},
    {"id": "नाचणी", "label": "नाचणी", "parentId": "तृणधान्य पीक"},
    {"id": "वरी", "label": "वरी", "parentId": "तृणधान्य पीक"},
    {"id": "बर्टी", "label": "बर्टी", "parentId": "तृणधान्य पीक"},
    {"id": "हरभरा", "label": "हरभरा", "parentId": "कडधान्य पीक"},
    {"id": "तूर", "label": "तूर", "parentId": "कडधान्य पीक"},
    {"id": "मूग", "label": "मूग", "parentId": "कडधान्य पीक"},
    {"id": "उडीद", "label": "उडीद", "parentId": "कडधान्य पीक"},
    {"id": "कुळीथ ", "label": "कुळीथ", "parentId": "कडधान्य पीक"},
    {"id": "मटकी", "label": "मटकी", "parentId": "कडधान्य पीक"},
    {"id": "राजमा", "label": "राजमा", "parentId": "कडधान्य पीक"},
    {"id": "चवळी", "label": "चवळी", "parentId": "कडधान्य पीक"},
    {"id": "भुईमूग", "label": "भुईमूग", "parentId": "गळीतधान्य पीक"},
    {"id": "सोयाबीन", "label": "सोयाबीन", "parentId": "गळीतधान्य पीक"},
    {"id": "सूर्यफूल", "label": "सूर्यफूल", "parentId": "गळीतधान्य पीक"},
    {"id": "करडई", "label": "करडई", "parentId": "गळीतधान्य पीक"},
    {"id": "तीळ", "label": "तीळ", "parentId": "गळीतधान्य पीक"},
    {
      "id": "दुय्यम तेलवर्गीय पीक",
      "label": "दुय्यम तेलवर्गीय पीक",
      "parentId": "गळीतधान्य पीक"
    },
    {"id": "ऊस", "label": "ऊस", "parentId": "नगदी पीक"},
    {"id": "ऊस - खोडवा", "label": "ऊस - खोडवा", "parentId": "नगदी पीक"},
    {"id": "कापूस", "label": "कापूस", "parentId": "नगदी पीक"},
    {"id": "ज्वारी", "label": "ज्वारी", "parentId": "चारा"},
    {"id": "बाजरी", "label": "बाजरी", "parentId": "चारा"},
    {"id": "मका", "label": "मका", "parentId": "चारा"},
    {"id": "चवळी", "label": "चवळी", "parentId": "चारा"},
    {"id": "ओट", "label": "ओट", "parentId": "चारा"},
    {"id": "बरसीम (घोडा घास)", "label": "बरसीम (घोडा घास)", "parentId": "चारा"},
    {"id": "लसूण घास", "label": "लसूण घास", "parentId": "चारा"},
    {
      "id": "संकरित नेपियर गवत",
      "label": "संकरित नेपियर गवत",
      "parentId": "चारा"
    },
    {"id": "स्टायलो", "label": "स्टायलो", "parentId": "चारा"},
    {"id": "आंबा", "label": "आंबा", "parentId": "फळे"},
    {"id": "केळी", "label": "केळी", "parentId": "फळे"},
    {"id": "द्राक्षे", "label": "द्राक्षे", "parentId": "फळे"},
    {"id": "डाळिंब", "label": "डाळिंब", "parentId": "फळे"},
    {"id": "कांदा", "label": "कांदा", "parentId": "भाजीपाला"},
    {"id": "मिरची", "label": "मिरची", "parentId": "भाजीपाला"},
    {"id": "टोमॅटो", "label": "टोमॅटो", "parentId": "भाजीपाला"},
    {"id": "वांगी", "label": "वांगी", "parentId": "भाजीपाला"},
    {"id": "भेंडी", "label": "भेंडी", "parentId": "भाजीपाला"},
    {"id": "वाल", "label": "वाल", "parentId": "भाजीपाला"},
    {"id": "कोबी", "label": "कोबी", "parentId": "भाजीपाला"},
    {"id": "फुलकोबी", "label": "फुलकोबी", "parentId": "भाजीपाला"},
    {"id": "मेथी", "label": "मेथी", "parentId": "भाजीपाला"},
    {"id": "पालक", "label": "पालक", "parentId": "भाजीपाला"},
    {"id": "ब्रोकोली", "label": "ब्रोकोली", "parentId": "भाजीपाला"},
    {"id": "बटाटा", "label": "बटाटा", "parentId": "भाजीपाला"},
    {"id": "वाटाणा", "label": "वाटाणा", "parentId": "भाजीपाला"},
    {"id": "हळद", "label": "हळद", "parentId": "भाजीपाला"},
    {"id": "आले", "label": "आले", "parentId": "भाजीपाला"},
  ];

  var availableCrops = [];
  final internalCrops = ["आहे", "नाही"];

  final irrigationTypes = ["ठिबक", "पारंपारिक"];

  final irrigationSources = ["बोअरवेल", "नदी", "विहीर"];

  final fertilizerTypes = ["सेंद्रिय", "रासायनिक"];

  String? selectedAcre = "0";
  String? selectedGuntha = "0";
  String? selectedMainCrop;
  String? selectedSubCrop;
  String? selectedInternalCrop;
  String? selectedInrrigationType;
  String? selectedInrrigationSource;
  String? seletedFertilizerType;

  @override
  void initState() {
    super.initState();
    //getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final Map userDetailsMap =
        ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text(
          "पीक व्यवस्थापन",
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
                /*Container(
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
                                hint: Text("एकर"),
                                value: selectedAcre,
                                validator: (value) =>
                                    (value == "0" && selectedGuntha == "0")
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
                ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "एकूण शेतजमीन",
                        style: labelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                          hint: Text("एकर"),
                          value: selectedAcre,
                          validator: (value) =>
                              (value == "0" && selectedGuntha == "0")
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "पीक प्रकार",
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
                          hint: Text("पीक प्रकार निवडा"),
                          value: selectedMainCrop,
                          items: cropTypes
                              .map((e) => DropdownMenuItem<String>(
                                    child: Text(e["label"]),
                                    value: e["id"],
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            selectedSubCrop = null;
                            availableCrops.clear();
                            selectedMainCrop = value;
                            setState(() {
                              availableCrops = cropNames
                                  .where((element) =>
                                      element["parentId"] == selectedMainCrop)
                                  .toList();
                            });
                          }),
                          onSaved: ((newValue) => setState(() {
                                selectedMainCrop = newValue;
                              })),
                          validator: (value) =>
                              value == null ? "कृपया मुख्य पीक निवडा" : null,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "पिकाचे नाव",
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
                          hint: Text("पिकाचे नाव निवडा"),
                          value: selectedSubCrop,
                          items: availableCrops
                              .map((e) => DropdownMenuItem<String>(
                                    child: Text(e["label"]),
                                    value: e["id"],
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            selectedSubCrop = value;
                          }),
                          onSaved: ((newValue) => setState(() {
                                selectedSubCrop = newValue;
                              })),
                          validator: (value) =>
                              value == null ? "कृपया पिकाचे नाव निवडा" : null,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "पीक लागण दिनांक",
                        style: labelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _date,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month_rounded),
                          hintText: "पीक लागण दिनांक निवडा",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.green.shade500, width: 2),
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
                        validator: (value) => _date.text == ""
                            ? "कृपया पीक लागण दिनांक निवडा"
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "अंतर्गत पीक",
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
                          hint: Text("अंतर्गत पीक"),
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "सिंचन प्रकार",
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "सिंचन स्त्रोत",
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "खत प्रकार",
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        FirebaseStorage.instance
                            .ref()
                            .child("$selectedMainCrop/$selectedSubCrop.pdf")
                            .getDownloadURL()
                            .then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ViewPDF(value, selectedSubCrop!)));
                        }).onError((error, stackTrace) {
                          Get.snackbar(
                            "तसदीबद्दल क्षमस्व",
                            "माहिती उपलब्ध नाही",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            isDismissible: true,
                            dismissDirection: DismissDirection.horizontal,
                            margin: EdgeInsets.all(15),
                            forwardAnimationCurve: Curves.easeOutBack,
                            colorText: Colors.white,
                          );
                        });
                        ;

                        /*FirebaseAllServices.instance.addData(
                                  selectedAcre!,
                                  selectedGuntha!,
                                  selectedMainCrop!,
                                  selectedSubCrop!,
                                  _date.text,
                                  dateInMs,
                                  selectedInternalCrop!,
                                  selectedInrrigationType!,
                                  selectedInrrigationSource!,
                                  seletedFertilizerType!,
                                  userDetailsMap);*/
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
                      'पुढे',
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

  /*Future<void> getUserData() async {
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
        selectedSubCrop = data["Sub Crop"];
        _date.text = data["Crop Date"];
        dateInMs = data["Crop Date in ms"];
        selectedInternalCrop = data["Internal Crop"];
        selectedInrrigationType = data["Irrigation Type"];
        selectedInrrigationSource = data["Irrigation Source"];
        seletedFertilizerType = data["Fertilizer Type"];
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          loading = false;
        });
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }*/
}

class ViewPDF extends StatefulWidget {
  String doc;
  String docName;
  ViewPDF(this.doc, this.docName);

  @override
  State<ViewPDF> createState() => _ViewPDFState(doc, docName);
}

class _ViewPDFState extends State<ViewPDF> {
  String newDoc;
  String docName;
  _ViewPDFState(this.newDoc, this.docName);
  static const int _initialPage = 1;
  late PdfControllerPinch pdfPinchController;

  @override
  void initState() {
    super.initState();
    pdfPinchController = PdfControllerPinch(
      document: PdfDocument.openData(InternetFile.get(newDoc)),
      initialPage: _initialPage,
    );
  }

  @override
  void dispose() {
    super.dispose();
    pdfPinchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          docName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: PdfViewPinch(
          builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(),
            documentLoaderBuilder: (_) =>
                const Center(child: CircularProgressIndicator()),
            pageLoaderBuilder: (_) =>
                const Center(child: CircularProgressIndicator()),
          ),
          controller: pdfPinchController,
        ),
      ),
    );
  }
}
