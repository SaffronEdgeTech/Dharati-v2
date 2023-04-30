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

  Future<void> addLocationdata(String district, String taluka, String village,
      String nextPage, var userDetailsMap) async {
    final user = _auth.currentUser!;
    final id = user.uid;
    final phoneNo = user.phoneNumber;
    await db.collection("New Users").doc(id).set(
      {
        "ID": id,
        "Phone Number": phoneNo,
        "District": district,
        "Taluka": taluka,
        "Village": village,
        "State": "महाराष्ट्र",
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
      String vil) async {
    String tempService = service;
    String tempServiceType = serviceType;
    tempService = tempService.replaceAll(" ", "");
    tempService = tempService.replaceAll("/", "");
    tempServiceType = tempServiceType.replaceAll(" ", "");
    tempServiceType = tempServiceType.replaceAll("/", "");
    final user = _auth.currentUser!;
    final id = user.uid;
    final phoneNo = user.phoneNumber;
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
      },
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
      String vil) async {
    final user = _auth.currentUser!;
    final id = user.uid;
    final phoneNo = user.phoneNumber;
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
        "Main Type": mainType,
        "Sub Type": subType,
        "Start Date": sellStartDate,
        "Start Date ms": sellStartDateInMs,
        "End Date": sellEndDate,
        "End Date ms": sellEndDateInMs,
        "Sell Level": sellLevel,
        "State": "महाराष्ट्र",
      },
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
