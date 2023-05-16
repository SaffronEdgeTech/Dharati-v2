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
  List<dynamic> documents = [];

  num dateStartInMs = 0;

  String? _valueLevel = "Village";
  List<dynamic> mainCropType = [
    {"id": "तृणधान्य पीक", "label": "तृणधान्य पीक"},
    {"id": "कडधान्य पीक", "label": "कडधान्य पीक"},
    {"id": "गळीतधान्य पीक", "label": "गळीतधान्य पीक"},
    {"id": "नगदी पीक", "label": "नगदी पीक"},
    {"id": "चारा", "label": "चारा"},
    {"id": "फळे", "label": "फळे"},
    {"id": "भाजीपाला", "label": "भाजीपाला"},
    {"id": "पशुधन", "label": "पशुधन"},
    {"id": "कृषी अवजारे", "label": "कृषी अवजारे"}
  ];

  List<dynamic> allSubCropTypes = [
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
    {"id": "ऊस-खोडवा", "label": "ऊस-खोडवा", "parentId": "नगदी पीक"},
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
    {"id": "म्हैस", "label": "म्हैस", "parentId": "पशुधन"},
    {"id": "बैल", "label": "बैल", "parentId": "पशुधन"},
    {"id": "गाय", "label": "गाय", "parentId": "पशुधन"},
    {"id": "बकरी", "label": "बकरी", "parentId": "पशुधन"},
    {"id": "मेंढी", "label": "मेंढी", "parentId": "पशुधन"},
    {"id": "गावरान कोंबडी", "label": "गावरान कोंबडी", "parentId": "पशुधन"},
    {"id": "ट्रॅक्टर", "label": "ट्रॅक्टर", "parentId": "कृषी अवजारे"},
    {"id": "पलटी नांगर", "label": "पलटी नांगर", "parentId": "कृषी अवजारे"},
    {"id": "रोटाव्हेटर", "label": "रोटाव्हेटर", "parentId": "कृषी अवजारे"},
    {"id": "ट्रेलर", "label": "ट्रेलर", "parentId": "कृषी अवजारे"},
    {"id": "फवारणी यंत्र", "label": "फवारणी यंत्र", "parentId": "कृषी अवजारे"},
    {"id": "तोडणी यंत्र", "label": "तोडणी यंत्र", "parentId": "कृषी अवजारे"},
    {"id": "ट्रॅक्टर फळी", "label": "ट्रॅक्टर फळी", "parentId": "कृषी अवजारे"},
    {"id": "मळणी यंत्र ", "label": "मळणी यंत्र", "parentId": "कृषी अवजारे"},
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
    {"id": "हार्वेस्टर", "label": "हार्वेस्टर", "parentId": "कृषी अवजारे"},
    {"id": "जेसिबी", "label": "जेसिबी", "parentId": "कृषी अवजारे"},
    {"id": "बोअरवेल", "label": "बोअरवेल", "parentId": "कृषी अवजारे"}
  ];

  var cropTypes = [];
  String? selectedMainType;
  String? selectedSubType;

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
                              selectedSubType = null;
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
                                _startDate.text = DateFormat("dd-MM-yyyy")
                                    .format(selectedDate);
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
                              documents.clear();
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
    mainType = mainType.replaceAll(" ", "");
    subType = subType.replaceAll(" ", "");
    mainType = mainType.replaceAll("/", "");
    subType = subType.replaceAll("/", "");
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
        if (mobileNumber != phoneNumber.toString() &&
            startDate.compareTo(dateStartInMs.toString()) <= 0 &&
            endDate.compareTo(dateStartInMs.toString()) >= 0 &&
            sellLevel == _valueLevel.toString() &&
            loc == distTalVil[_valueLevel].toString()) {
          setState(() {
            documents.add(data);
          });
        }
      });
    }).whenComplete(() {
      if (documents.isNotEmpty) {
        Future.delayed(Duration(seconds: 5), () {
          Navigator.pushNamed(context, "/checkProduct", arguments: documents);
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
