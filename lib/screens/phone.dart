import 'package:dharati/services/FirebaseAllServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneNum extends StatefulWidget {
  const PhoneNum({super.key});

  @override
  State<PhoneNum> createState() => _PhoneNumState();
}

class _PhoneNumState extends State<PhoneNum> {
  String countryISOCode = 'IN';
  String completeNumber = '#';
  String number = '#';
  int minLength = 10;
  int maxLength = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Krushee-Sanskrutee.png',
                width: 300,
                height: 300,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'संपर्क क्रमांक पडताळणी',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'तुमचा संपर्क क्रमांक टाका',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              IntlPhoneField(
                decoration: InputDecoration(
                  hintText: 'संपर्क क्रमांक',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                dropdownTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
                countries: ["IN"],
                invalidNumberMessage: "अवैध संपर्क क्रमांक",
                initialCountryCode: countryISOCode,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
                onChanged: (phone) {
                  countryISOCode = phone.countryISOCode;
                  completeNumber = phone.completeNumber;
                  number = phone.number;
                  minLength = countries
                      .firstWhere(
                        (country) =>
                            country.code.toLowerCase() ==
                            countryISOCode.toLowerCase(),
                      )
                      .minLength;
                  maxLength = countries
                      .firstWhere(
                        (country) =>
                            country.code.toLowerCase() ==
                            countryISOCode.toLowerCase(),
                      )
                      .maxLength;
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    int len = number.length;
                    if (len >= minLength && len <= maxLength) {
                      FirebaseAllServices.instance
                          .phoneAuthentication(completeNumber);
                      Get.toNamed("/otp", arguments: completeNumber);
                    } else {
                      Get.snackbar(
                        "तसदीबद्दल क्षमस्व",
                        "अवैध क्रमांक",
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
                    'ओटीपी पाठवा',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
