import 'package:dharati/widgets/NavDrawer.dart';
import 'package:flutter/material.dart';
import 'package:dharati/services/FirebaseAllServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

class SellProduct extends StatefulWidget {
  const SellProduct({super.key});

  @override
  State<SellProduct> createState() => _SellProductState();
}

class _SellProductState extends State<SellProduct> {
  TextEditingController otp = TextEditingController();
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
  List<dynamic> mainType = [
    {"id": "पीक", "label": "पीक"},
    {"id": "भाजी", "label": "भाजी"},
    {"id": "पशुधन", "label": "पशुधन"}
  ];
  List<dynamic> allSubTypes = [
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
  // final counts = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  var cropTypes = [];
  String? selectedMainType;
  String? selectedSubType;
  //String? count = "1";
  TextEditingController _startDate = TextEditingController();
  TextEditingController _endDate = TextEditingController();
  var dateStartInMs;
  var dateEndInMs;
  String? phoneNum;
  String sellLevel = "Village";
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
        
        title: Text(
          "विक्री",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      drawer: NavDrawer(details:userDetails),
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
                          validator: (value) =>
                              value == null ? "कृपया मुख्य प्रकार निवडा" : null,
                          items: mainType
                              .map((e) => DropdownMenuItem<String>(
                                    child: Text(e["label"]),
                                    value: e["id"],
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            selectedMainType = null;
                            cropTypes.clear();
                            selectedMainType = value;
                            cropTypes = allSubTypes
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
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "विक्री कालावधी पासून",
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
                        "विक्री कालावधी पर्यंत",
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
                  'विक्री परिसर',
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
                        groupValue: sellLevel,
                        onChanged: (value) {
                          setState(() {
                            sellLevel = value.toString();
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text("तालुका पातळी"),
                        value: "Taluka",
                        groupValue: sellLevel,
                        onChanged: (value) {
                          setState(() {
                            sellLevel = value.toString();
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
                        groupValue: sellLevel,
                        onChanged: (value) {
                          setState(() {
                            sellLevel = value.toString();
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text("राज्य पातळी"),
                        value: "State",
                        groupValue: sellLevel,
                        onChanged: (value) {
                          setState(() {
                            sellLevel = value.toString();
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
                        FirebaseAllServices.instance
                            .phoneAuthentication(phoneNum.toString(), "NoPage");
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
                      'नोंद करा',
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

  void verifyOTP() async {
    if (otp.length == 6) {
      var isVerified = await FirebaseAllServices.instance.verifyOTP(otp.text);
      if (isVerified) {
        Navigator.pop(context);
        FirebaseAllServices.instance.addSellProducts(
            selectedMainType!,
            selectedSubType!,
            _startDate.text,
            dateStartInMs!,
            _endDate.text,
            dateEndInMs!,
            sellLevel,
            dist!,
            tal!,
            vil!);
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
}
