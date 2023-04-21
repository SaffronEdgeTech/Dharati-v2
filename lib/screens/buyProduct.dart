import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BuyProduct extends StatefulWidget {
  const BuyProduct({super.key});

  @override
  State<BuyProduct> createState() => _BuyProductState();
}

class _BuyProductState extends State<BuyProduct> {
  final _formKey = GlobalKey<FormState>();

  String? phoneNumber;
  var distTalVil = {};

  DateTime date = DateTime.now();
  int available = 0;
  TextEditingController tc = TextEditingController();

  String? _valueLevel = "Village";
  List<dynamic> documents = [];
  final mainCropType = ['पीक', 'भाजी', 'पशुधन'];
  var availableSubCropType = [];
  final subCropType1 = [
    'गहू',
    'ज्वारी',
    'तांदूळ',
    'मका',
    'नाचणी',
    'भुईमूग',
    'सोयाबीन',
  ];
  final subCropType2 = [
    'मेथी',
    'पोकळा',
    'करडई',
    'पालक',
    'कांदा',
    'टोमॅटो',
    'बटाटा',
    'दोडका',
    'शेवगा',
    'पावटा',
    'गवारी',
    'वांगी',
    'काकडी',
    'गाजर',
    'मुळा',
    'कोथिंबीर',
    'आले',
    'लसूण',
    'कारले'
  ];
  final subCropType3 = ['गाई', 'म्हशी', 'शेळ्या', 'डुकरे'];
  String? selectedSubType = 'गहू';
  String? selectedMainType = 'पीक';
  String? selectedBuyDate = " ";

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
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(25.0),
        child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Text(
                        'मुख्य प्रकार',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      ButtonTheme(
                        alignedDropdown: true,
                        child: Expanded(
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "मुख्य प्रकार",
                              labelStyle: TextStyle(
                                fontSize: 16,
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
                            value: selectedMainType,
                            validator: (value) => value == "0"
                                ? "कृपया मुख्य प्रकार निवडा"
                                : null,
                            items: mainCropType
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() {
                              selectedSubType = null;
                              availableSubCropType.clear();
                              selectedMainType = value;
                              fetchSubCropType(selectedMainType.toString());
                            }),
                            onSaved: (newValue) => setState(() {
                              selectedMainType = newValue;
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text(
                        'उप प्रकार',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      ButtonTheme(
                        alignedDropdown: true,
                        child: Expanded(
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "उप प्रकार",
                              labelStyle: TextStyle(
                                fontSize: 16,
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
                            value: selectedSubType,
                            validator: (value) =>
                                value == "0" ? "कृपया उप प्रकार निवडा" : null,
                            items: availableSubCropType
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() {
                              selectedSubType = value as String?;
                            }),
                            onSaved: (newValue) => setState(() {
                              selectedSubType = newValue as String?;
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
                    children: [
                      Text(
                        "खरेदी दिवस",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: tc,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today_rounded),
                            labelText: "तारीख निवडा",
                            labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
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
                          readOnly: true,
                          onTap: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2025),
                            );
                            if (newDate == null) return;

                            setState(() {
                              available = newDate.millisecondsSinceEpoch;
                              tc.text =
                                  DateFormat("dd-MM-yyyy").format(newDate);
                            });
                          },
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
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          value: "Village",
                          title: const Text("गाव पातळी"),
                          activeColor: Colors.green,
                          groupValue: _valueLevel,
                          onChanged: (String? value) {
                            setState(() => _valueLevel = value.toString());
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: "Taluka",
                          title: const Text("तालुका पातळी"),
                          activeColor: Colors.green,
                          groupValue: _valueLevel,
                          onChanged: (String? value) {
                            setState(() => _valueLevel = value.toString());
                          },
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
                        child: RadioListTile(
                          value: "District",
                          title: const Text("जिल्हा पातळी"),
                          activeColor: Colors.green,
                          groupValue: _valueLevel,
                          onChanged: (String? value) {
                            setState(() => _valueLevel = value.toString());
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: "State",
                          title: const Text("राज्य पातळी"),
                          activeColor: Colors.green,
                          groupValue: _valueLevel,
                          onChanged: (String? value) {
                            setState(() => _valueLevel = value.toString());
                          },
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

  fetchSubCropType(String? mainCrop) {
    setState(() {
      if (mainCrop == 'पीक') {
        availableSubCropType = subCropType1;
      } else if (mainCrop == 'भाजी') {
        availableSubCropType = subCropType2;
      } else if (mainCrop == 'पशुधन') {
        availableSubCropType = subCropType3;
      }
    });
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
