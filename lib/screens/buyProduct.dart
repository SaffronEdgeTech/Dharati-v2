import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dharati/widgets/NavDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:dharati/services/FirebaseAllServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';

class BuyProduct extends StatefulWidget {
  const BuyProduct({super.key});

  @override
  State<BuyProduct> createState() => _BuyProductState();
}

class _BuyProductState extends State<BuyProduct> {
  final _formKey = GlobalKey<FormState>();
  TextStyle labelTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.green.shade600,
  );

  String? phoneNumber;
  var distTalVil = {};
  TextEditingController _startDate = TextEditingController();
  DateTime date = DateTime.now();
  int available = 0;
  var dateStartInMs;
  

  String? _valueLevel = "Village";
  List<dynamic> mainCropType = [
    {"id": "पीक", "label": "पीक"},
    {"id": "भाजी", "label": "भाजी"},
    {"id": "पशुधन", "label": "पशुधन"}
  ];

  List<dynamic> allSubCropTypes = [
    {"id": "गहू", "label": "गहू", "parentId": "पीक"},
    {"id": "ज्वारी", "label": "ज्वारी", "parentId": "पीक"},
    {"id": "तांदूळ", "label": "तांदूळ", "parentId": "पीक"},
    {"id": "मका", "label": "मका", "parentId": "पीक"},
    {"id": "नाचणी", "label": "नाचणी", "parentId": "पीक"},
    {"id": "भुईमूग", "label": "भुईमूग", "parentId": "पीक"},
    {"id": "सोयाबीन", "label": "सोयाबीन", "parentId": "पीक"},
    {"id": "मेथी", "label": "मेथी", "parentId": "भाजी"},
    {"id": "पोकळा", "label": "पोकळा", "parentId": "भाजी"},
    {"id": "करडई", "label": "करडई", "parentId": "भाजी"},
    {"id": "पालक", "label": "पालक", "parentId": "भाजी"},
    {"id": "कांदा", "label": "कांदा", "parentId": "भाजी"},
    {"id": "टोमॅटो", "label": "टोमॅटो", "parentId": "भाजी"},
    {"id": "बटाटा", "label": "बटाटा", "parentId": "भाजी"},
    {"id": "दोडका", "label": "दोडका", "parentId": "भाजी"},
    {"id": "शेवगा", "label": "शेवगा", "parentId": "भाजी"},
    {"id": "पावटा", "label": "पावटा", "parentId": "भाजी"},
    {"id": "गवारी", "label": "गवारी", "parentId": "भाजी"},
    {"id": "वांगी", "label": "वांगी", "parentId": "भाजी"},
    {"id": "काकडी", "label": "काकडी", "parentId": "भाजी"},
    {"id": "गाजर", "label": "गाजर", "parentId": "भाजी"},
    {"id": "मुळा", "label": "मुळा", "parentId": "भाजी"},
    {"id": "कोथिंबीर", "label": "कोथिंबीर", "parentId": "भाजी"},
    {"id": "आले", "label": "आले", "parentId": "भाजी"},
    {"id": "लसूण", "label": "लसूण", "parentId": "भाजी"},
    {"id": "कारले", "label": "कारले", "parentId": "भाजी"},
    {"id": "गाई", "label": "गाई", "parentId": "पशुधन"},
    {"id": "म्हशी", "label": "म्हशी", "parentId": "पशुधन"},
    {"id": "शेळ्या", "label": "शेळ्या", "parentId": "पशुधन"},
    {"id": "डुकरे", "label": "डुकरे", "parentId": "पशुधन"}
  ];

  var cropTypes = []; 
  String? selectedMainType;
  String? selectedSubType;

  String? selectedBuyDate = " ";

  @override
  Widget build(BuildContext context) {
    final Map userDetails = ModalRoute.of(context)!.settings.arguments as Map;
    distTalVil["District"] = userDetails["Dist"].toString();
    distTalVil["Taluka"] = userDetails["Tal"].toString();
    distTalVil["Village"] = userDetails["Vil"].toString();
    distTalVil["State"] = userDetails["State"].toString();
    phoneNumber = userDetails["PhoneNum"].toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "खरेदी",
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
                          "मुख्य प्रकार",
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
                            hint: Text("मुख्य प्रकार"),
                            value: selectedMainType,
                            validator: (value) => value == null
                                ? "कृपया मुख्य प्रकार निवडा"
                                : null,
                            items: mainCropType
                                .map((e) => DropdownMenuItem<String>(
                                      child: Text(e["label"]),
                                      value: e["id"],
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() {
                              selectedMainType = null;
                              cropTypes.clear();
                              selectedMainType = value;
                              cropTypes = allSubCropTypes
                                  .where((element) =>
                                      element["parentId"] == selectedMainType)
                                  .toList();
                            }),
                            onSaved: (newValue) => setState(() {
                              selectedMainType = newValue;
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
                          "उप प्रकार",
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
                            hint: Text("उप प्रकार"),
                            value: selectedSubType,
                            validator: (value) =>
                                value == null ? "कृपया उप प्रकार निवडा" : null,
                            items: cropTypes
                                .map((e) => DropdownMenuItem<String>(
                                      child: Text(e["label"]),
                                      value: e["id"],
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() {
                              selectedSubType = value;
                            }),
                            onSaved: (newValue) => setState(() {
                              selectedSubType = newValue;
                            }),
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
                        "खरेदी दिवस",
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
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "खरेदी परिसर",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
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
                        groupValue: _valueLevel,
                        onChanged: (value) {
                          setState(() {
                            _valueLevel = value.toString();
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text("तालुका पातळी"),
                        value: "Taluka",
                        groupValue:_valueLevel,
                        onChanged: (value) {
                          setState(() {
                            _valueLevel = value.toString();
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
                        groupValue: _valueLevel,
                        onChanged: (value) {
                          setState(() {
                            _valueLevel = value.toString();
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text("राज्य पातळी"),
                        value: "State",
                        groupValue: _valueLevel,
                        onChanged: (value) {
                          setState(() {
                            _valueLevel = value.toString();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              cropTypes.clear();
                              fetchBuyProductServices(
                                  selectedMainType!, selectedSubType!);
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
                            /*Navigator.pushNamedAndRemoveUntil(
                                context, '/checkProduct', (route) => false);*/
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              minimumSize: Size(40, 50) // Background color
                              ),
                          child: Text("पर्याय पहा"))
                    ],
                  )
                ])),
      )),
    );
  }

  fetchBuyProductServices(String mainType, String subType) {
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
        .collectionGroup(mainType + subType)
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        var data = doc.data();
        String mobileNumber = data["Phone Number"].toString();
        String startDate = data["Start Date ms"].toString();
        String endDate = data["End Date ms"].toString();
        String sellLevel = data["Sell Level"].toString();
        String loc = data[_valueLevel].toString();
        if (mobileNumber != phoneNumber &&
            startDate.compareTo(available.toString()) <= 0 &&
            endDate.compareTo(available.toString()) >= 0 &&
            sellLevel == _valueLevel.toString() &&
            loc == distTalVil[_valueLevel].toString()) {
          setState(() {
            cropTypes.add(data);
          });
        }
      });
    }).whenComplete(() {
      if (cropTypes.isNotEmpty) {
        Future.delayed(Duration(seconds: 5), () {
          Navigator.pushNamed(context, "/checkProduct", arguments: cropTypes);
        });
      } else {
        Get.snackbar(
          "तसदीबद्दल क्षमस्व",
          "उत्पादने उपलब्ध नाहीत",
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
