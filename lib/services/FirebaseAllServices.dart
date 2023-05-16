import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseAllServices extends GetxController {
  static FirebaseAllServices get instance => Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  var verifyId = ''.obs;

  Future<void> phoneAuthentication(String phoneNum, String nextPage) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNum,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
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
          this.verifyId.value = verificationId;
          if (nextPage == "/otp") {
            Get.toNamed("/otp", arguments: phoneNum);
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verifyId.value = verificationId;
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

  Future<bool> verifyOTP(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: this.verifyId.value, smsCode: otp);
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

  logOut() async {
    try {
      await _auth.signOut();
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
  }

  delete() async {
    try {
      await _auth.currentUser!.delete();
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
  }

  // Database Operations

  Future<void> addData(
      String acre,
      String guntha,
      String mainCrop,
      String subCrop,
      String date,
      num dateInMs,
      String internalCrop,
      String irrigationType,
      String irrigationSource,
      String seletedFertilizerType,
      var details) async {
    final user = _auth.currentUser!;
    final id = user.uid;
    await db.collection("New Users").doc(id).set(
      {
        "Acre": acre,
        "Guntha": guntha,
        "Main Crop": mainCrop,
        "Internal Crop": internalCrop,
        "Irrigation Type": irrigationType,
        "Irrigation Source": irrigationSource,
        "Fertilizer Type": seletedFertilizerType,
        "Sub Crop": subCrop,
        "Crop Date": date,
        "Crop Date in ms": dateInMs
      },
      SetOptions(merge: true),
    ).then((value) {
      Get.snackbar(
        "धन्यवाद",
        "माहिती यशस्वीरित्या जतन केली आहे!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(15),
        forwardAnimationCurve: Curves.easeOutBack,
        colorText: Colors.white,
      );
      Future.delayed(const Duration(seconds: 5), () {
        Get.toNamed("/dosageCalculator", arguments: details);
      });
    }).onError((error, stackTrace) {
      Get.snackbar(
        "तसदीबद्दल क्षमस्व",
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(15),
        forwardAnimationCurve: Curves.easeOutBack,
        colorText: Colors.white,
      );
    });
  }

  Future<void> addInfo(String district, String taluka, String village,
      String name, String surName, String nextPage, var userDetailsMap) async {
    final user = _auth.currentUser!;
    final id = user.uid;
    final phoneNo = user.phoneNumber;
    String uName = name;
    String uSurName = surName;
    name = uName[0].toUpperCase() + uName.substring(1);
    surName = uSurName[0].toUpperCase() + uSurName.substring(1);
    await db.collection("New Users").doc(id).set(
      {
        "ID": id,
        "Phone Number": phoneNo,
        "District": district,
        "Taluka": taluka,
        "Village": village,
        "State": "महाराष्ट्र",
        "Name": name,
        "Surname": surName
      },
      SetOptions(merge: true),
    ).then((value) async {
      addProductLocationData(district.toString(), taluka.toString(),
          village.toString(), id.toString(), name, surName);
      addFarmingServiceLocationData(district.toString(), taluka.toString(),
          village.toString(), id.toString(), name, surName);
      Get.snackbar(
        "धन्यवाद",
        "माहिती यशस्वीरित्या जतन केली आहे!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(15),
        forwardAnimationCurve: Curves.easeOutBack,
        colorText: Colors.white,
      );
      Future.delayed(const Duration(seconds: 5), () {
        Get.toNamed(nextPage, arguments: userDetailsMap);
      });
    }).onError((error, stackTrace) {
      Get.snackbar(
        "तसदीबद्दल क्षमस्व",
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(15),
        forwardAnimationCurve: Curves.easeOutBack,
        colorText: Colors.white,
      );
    });
  }

  var myProdList = [
    "तृणधान्यपीक",
    "कडधान्यपीक",
    "गळीतधान्यपीक",
    "नगदीपीक",
    "चारा",
    "फळे",
    "भाजीपाला",
    "पशुधन",
    "कृषीअवजारे"
  ];
  var myProdMap = {
    "तृणधान्यपीक": [
      "भात",
      "बाजरी",
      "रब्बीज्वारी",
      "खरीपज्वारी",
      "गहू",
      "मका",
      "नाचणी",
      "वरी",
      "बर्टी"
    ],
    "कडधान्यपीक": [
      "हरभरा",
      "तूर",
      "मूग",
      "उडीद",
      "कुळीथ",
      "मटकी",
      "राजमा",
      "चवळी",
    ],
    "गळीतधान्यपीक": [
      "भुईमूग",
      "सोयाबीन",
      "सूर्यफूल",
      "करडई",
      "तीळ",
      "दुय्यमतेलवर्गीयपीक"
    ],
    "नगदीपीक": ["ऊस", "ऊस-खोडवा", "कापूस"],
    "चारा": [
      "ज्वारी",
      "बाजरी",
      "मका",
      "चवळी",
      "ओट",
      "बरसीम(घोडाघास)",
      "लसूणघास",
      "संकरितनेपियरगवत",
      "स्टायलो"
    ],
    "फळे": ["आंबा", "केळी", "द्राक्षे", "डाळिंब"],
    "भाजीपाला": [
      "कांदा",
      "मिरची",
      "टोमॅटो",
      "वांगी",
      "भेंडी",
      "वाल",
      "कोबी",
      "फुलकोबी",
      "मेथी",
      "पालक",
      "ब्रोकोली",
      "बटाटा",
      "वाटाणा",
      "हळद",
      "आले"
    ],
    "पशुधन": ["म्हैस", "बैल", "गाय", "बकरी", "मेंढी", "गावरानकोंबडी"],
    "कृषीअवजारे": [
      "ट्रॅक्टर",
      "पलटीनांगर",
      "रोटाव्हेटर",
      "ट्रेलर",
      "फवारणीयंत्र",
      "तोडणीयंत्र",
      "ट्रॅक्टरफळी",
      "मळणी यंत्र",
      "कल्टिव्हेटरमशागत",
      "हॅरोदंताळे",
      "पेरणीयंत्र",
      "ड्रोन",
      "हार्वेस्टर",
      "जेसिबी",
      "बोअरवेल"
    ]
  };

  Future<void> addProductLocationData(String district, String taluka,
      String village, String id, String name, String surName) async {
    db.collection("Products").doc(id).get().then((value) {
      for (String prodlistVal in myProdList) {
        for (String prodmapVal in myProdMap[prodlistVal]!) {
          try {
            db
                .collection("Products")
                .doc(id)
                .collection(prodlistVal + prodmapVal)
                .doc(id)
                .get()
                .then((value) async {
              if (value.exists) {
                String uName = name;
                String uSurName = surName;
                name = uName[0].toUpperCase() + uName.substring(1);
                surName = uSurName[0].toUpperCase() + uSurName.substring(1);
                await db
                    .collection("Products")
                    .doc(id)
                    .collection(prodlistVal + prodmapVal)
                    .doc(id)
                    .set(
                  {
                    "District": district,
                    "Taluka": taluka,
                    "Village": village,
                    "State": "महाराष्ट्र",
                    "Name": name,
                    "Surname": surName
                  },
                  SetOptions(merge: true),
                ).onError((error, stackTrace) {
                  Get.snackbar(
                    "तसदीबद्दल क्षमस्व",
                    error.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    isDismissible: true,
                    dismissDirection: DismissDirection.horizontal,
                    margin: EdgeInsets.all(15),
                    forwardAnimationCurve: Curves.easeOutBack,
                    colorText: Colors.white,
                  );
                });
              }
            });
          } on Exception catch (e) {}
        }
      }
    });
  }

  var myFarmingServiceList = [
    "कृषीअवजारे",
    "मनुष्यबळ",
    "पशुधन",
    "सेंद्रियखतेवतणनाशके",
    "सिंचनव्यवस्था",
    "बियाणे",
    "विद्युतव्यवस्था",
    "वाहतूकव्यवस्था"
  ];
  var myFarmingServiceMap = {
    "कृषीअवजारे": [
      "ट्रॅक्टर",
      "रोटाव्हेटर",
      "पलटीनांगर",
      "ट्रेलर",
      "फवारणीयंत्र",
      "बोअरवेल",
      "तोडणीयंत्र",
      "मळणीयंत्र",
      "कल्टिव्हेटरमशागत",
      "हॅरोदंताळे",
      "पेरणीयंत्र",
      "ड्रोन",
      "जेसिबी",
      "हार्वेस्टर",
      "ट्रॅक्टरफळी",
      "पॉवरटिलर"
    ],
    "मनुष्यबळ": ["मशागत", "मळणी", "कोळपणी", "फवारणी", "तोडणी", "पेरणी", "इतर"],
    "पशुधन": ["बैलजोडी", "शेळ्या-मेंढ्या"],
    "सेंद्रियखतेवतणनाशके": [
      "शेणखत",
      "गांडूळखत",
      "पंचगव्य",
      "जीवामृत",
      "दशपर्णी",
      "कंपोस्ट",
      "इतर"
    ],
    "सिंचनव्यवस्था": [
      "बोअरवेलखुदाई",
      "बोअरवेलमोटर",
      "जलव्यवस्थापन",
      "विहीरखुदाई",
      "विहीरगाळकाढणे",
      "विहीरमोटर",
      "भूअंतर्गतजलवाहिनी(PVC Pipes)आणिहार्डवेअर",
      "ठिबकसिंचनव्यवस्थापन",
      "इतर"
    ],
    "बियाणे": [
      "भात",
      "बाजरी",
      "रब्बीज्वारी",
      "खरीपज्वारी",
      "गहू",
      "मका",
      "नाचणी",
      "वरी",
      "बर्टी",
      "हरभरा",
      "तूर",
      "मूग",
      "उडीद",
      "कुळीथ",
      "मटकी",
      "राजमा",
      "चवळी",
      "भुईमूग",
      "सोयाबीन",
      "सूर्यफूल",
      "करडई",
      "तीळ",
      "ऊस",
      "ऊसरोपे",
      "कापूस",
      "आंबा",
      "केळी",
      "द्राक्ष",
      "डाळिंब",
      "चिक्कू",
      "पेरू",
      "कांदा",
      "मिरची",
      "टोमॅटो",
      "वांगी",
      "भेंडी",
      "वाल",
      "कोबी",
      "फुलकोबी",
      "मेथी",
      "पालक",
      "ब्रोकोली",
      "बटाटा",
      "हळद",
      "आले",
      "वाटाणा",
      "इतर"
    ],
    "विद्युतव्यवस्था": [
      "बोअरवेलमोटर",
      "विहीरमोटर",
      "उपसासिंचनमोटर(१०HPपेक्षाअधिक)",
      "इतर"
    ],
    "वाहतूकव्यवस्था": [
      "ट्रॅक्टर-छोटा",
      "ट्रॅक्टर-मोठा",
      "टेम्पो-लहान",
      "टेम्पो-मध्यम",
      "टेम्पो-मोठा",
      "बैलगाडी",
      "ट्रक",
      "इतर"
    ]
  };

  Future<void> addFarmingServiceLocationData(String district, String taluka,
      String village, String id, String name, String surName) async {
    db.collection("Farming Services").doc(id).get().then((value) {
      for (String farmServicelistVal in myFarmingServiceList) {
        for (String farmServicemapVal
            in myFarmingServiceMap[farmServicelistVal]!) {
          try {
            db
                .collection("Farming Services")
                .doc(id)
                .collection(farmServicelistVal + farmServicemapVal)
                .doc(id)
                .get()
                .then((value) async {
              if (value.exists) {
                String uName = name;
                String uSurName = surName;
                name = uName[0].toUpperCase() + uName.substring(1);
                surName = uSurName[0].toUpperCase() + uSurName.substring(1);
                await db
                    .collection("Farming Services")
                    .doc(id)
                    .collection(farmServicelistVal + farmServicemapVal)
                    .doc(id)
                    .set(
                  {
                    "District": district,
                    "Taluka": taluka,
                    "Village": village,
                    "State": "महाराष्ट्र",
                    "Name": name,
                    "Surname": surName
                  },
                  SetOptions(merge: true),
                ).onError((error, stackTrace) {
                  Get.snackbar(
                    "तसदीबद्दल क्षमस्व",
                    error.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    isDismissible: true,
                    dismissDirection: DismissDirection.horizontal,
                    margin: EdgeInsets.all(15),
                    forwardAnimationCurve: Curves.easeOutBack,
                    colorText: Colors.white,
                  );
                });
              }
            });
          } on Exception catch (e) {}
        }
      }
    });
  }

  Future<void> addFarmingServices(
      String service,
      String serviceType,
      String serviceStartDate,
      num serviceStartDateInMs,
      String serviceEndDate,
      num serviceEndDateInMs,
      String serviceLevel,
      String dist,
      String tal,
      String vil,
      String name,
      String surName) async {
    String tempService = service;
    String tempServiceType = serviceType;
    tempService = tempService.replaceAll(" ", "");
    tempService = tempService.replaceAll("/", "");
    tempServiceType = tempServiceType.replaceAll(" ", "");
    tempServiceType = tempServiceType.replaceAll("/", "");
    final user = _auth.currentUser!;
    final id = user.uid;
    final phoneNo = user.phoneNumber;
    String uName = name;
    String uSurName = surName;
    name = uName[0].toUpperCase() + uName.substring(1);
    surName = uSurName[0].toUpperCase() + uSurName.substring(1);
    await db
        .collection("Farming Services")
        .doc(id)
        .collection(tempService + tempServiceType)
        .doc(id)
        .set(
      {
        "ID": id,
        "Phone Number": phoneNo,
        "District": dist,
        "Taluka": tal,
        "Village": vil,
        "Service": service,
        "Service Type": serviceType,
        "Start Date": serviceStartDate,
        "Start Date ms": serviceStartDateInMs,
        "End Date": serviceEndDate,
        "End Date ms": serviceEndDateInMs,
        "Service Level": serviceLevel,
        "State": "महाराष्ट्र",
        "Name": name,
        "Surname": surName
      },
      SetOptions(merge: true),
    ).then((value) {
      Get.snackbar(
        "धन्यवाद",
        "माहिती यशस्वीरित्या जतन केली आहे!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(15),
        forwardAnimationCurve: Curves.easeOutBack,
        colorText: Colors.white,
      );
      Future.delayed(const Duration(seconds: 5), () {
        Get.offNamedUntil("/chooseService", (route) => false);
      });
    }).onError((error, stackTrace) {
      Get.snackbar(
        "तसदीबद्दल क्षमस्व",
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(15),
        forwardAnimationCurve: Curves.easeOutBack,
        colorText: Colors.white,
      );
    });
  }

  Future<void> addSellProducts(
      String mainType,
      String subType,
      String sellStartDate,
      num sellStartDateInMs,
      String sellEndDate,
      num sellEndDateInMs,
      String sellLevel,
      String dist,
      String tal,
      String vil,
      String name,
      String surName) async {
    String tempService = mainType;
    String tempServiceType = subType;
    tempService = tempService.replaceAll(" ", "");
    tempService = tempService.replaceAll("/", "");
    tempServiceType = tempServiceType.replaceAll(" ", "");
    tempServiceType = tempServiceType.replaceAll("/", "");
    final user = _auth.currentUser!;
    final id = user.uid;
    final phoneNo = user.phoneNumber;
    String uName = name;
    String uSurName = surName;
    name = uName[0].toUpperCase() + uName.substring(1);
    surName = uSurName[0].toUpperCase() + uSurName.substring(1);
    await db
        .collection("Products")
        .doc(id)
        .collection(mainType + subType)
        .doc(id)
        .set(
      {
        "ID": id,
        "Phone Number": phoneNo,
        "District": dist,
        "Taluka": tal,
        "Village": vil,
        "Main Type": tempService,
        "Sub Type": tempServiceType,
        "Start Date": sellStartDate,
        "Start Date ms": sellStartDateInMs,
        "End Date": sellEndDate,
        "End Date ms": sellEndDateInMs,
        "Sell Level": sellLevel,
        "State": "महाराष्ट्र",
        "Name": name,
        "Surname": surName
      },
      SetOptions(merge: true),
    ).then((value) {
      Get.snackbar(
        "धन्यवाद",
        "माहिती यशस्वीरित्या जतन केली आहे!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(15),
        forwardAnimationCurve: Curves.easeOutBack,
        colorText: Colors.white,
      );
      Future.delayed(const Duration(seconds: 5), () {
        Get.offNamedUntil("/chooseService", (route) => false);
      });
    }).onError((error, stackTrace) {
      Get.snackbar(
        "तसदीबद्दल क्षमस्व",
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(15),
        forwardAnimationCurve: Curves.easeOutBack,
        colorText: Colors.white,
      );
    });
  }
}
