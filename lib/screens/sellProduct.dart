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
  String verifyId = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextStyle labelTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.green.shade600,
  );
  List<dynamic> mainType = [
    {"id": "तृणधान्य पीक", "label": "तृणधान्य पीक"},
    {"id": "कडधान्य पीक", "label": "कडधान्य पीक"},
    {"id": "गळीतधान्य पीक", "label": "गळीतधान्य पीक"},
    {"id": "नगदी पीक", "label": "नगदी पीक"},
    {"id": "चारा", "label": "चारा"},
    {"id": "फळे", "label": "फळे"},
    {"id": "भाजीपाला", "label": "भाजीपाला"},
    {"id": "पशुधन", "label": "पशुधन"},
    {"id": "कृषी अवजारे", "label": "कृषी अवजारे"},
  ];
  List<dynamic> allSubTypes = [
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
    {"id": "बोअरवेल", "label": "बोअरवेल", "parentId": "कृषी अवजारे"},
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
  String? name;
  String? surName;
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
    name = userDetails["Name"].toString();
    surName = userDetails["Surname"].toString();
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
                          validator: (value) =>
                              value == null ? "कृपया मुख्य प्रकार निवडा" : null,
                          items: mainType
                              .map((e) => DropdownMenuItem<String>(
                                    child: Text(e["label"]),
                                    value: e["id"],
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() {
                            selectedSubType = null;
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
        vil!,
        name!,
        surName!);
  }
}
