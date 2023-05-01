import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dharati/widgets/MyFarmServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class MyFarmingServices extends StatefulWidget {
  const MyFarmingServices({super.key});

  @override
  State<MyFarmingServices> createState() => _MyFarmingServicesState();
}

class _MyFarmingServicesState extends State<MyFarmingServices> {
  bool loading = true;
  bool get loadingSts => loading;
  List<dynamic> documents = [];
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  final firestoreInstance = FirebaseFirestore.instance;
  var myFarmingServiceList = ["अवजारे", "मनुष्यबळ"];
  var myFarmingServiceMap = {
    "अवजारे": [
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
      "ट्रॅक्टरफळी"
    ],
    "मनुष्यबळ": ["मनुष्यबळ"]
  };
  @override
  void initState() {
    super.initState();
    documents.clear();
    getFarmingServices();
  }

  @override
  Widget build(BuildContext context) {
    final Map userDetails = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "उपलब्ध शेती सेवा",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: loadingSts
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return MyFarmService(documents[index]);
                },
              ),
            ),
    );
  }

  void getFarmingServices() {
    firestoreInstance
        .collection("Farming Services")
        .doc(uid)
        .get()
        .then((value) {
      for (String seva in myFarmingServiceList) {
        for (String sevaType in myFarmingServiceMap[seva]!) {
          try {
            firestoreInstance
                .collection("Farming Services")
                .doc(uid)
                .collection(seva + sevaType)
                .doc(uid)
                .get()
                .then((value) {
              if (value.exists) {
                var data = value.data();
                setState(() {
                  documents.add(data);
                });
              }
            });
          } on Exception catch (e) {}
        }
      }
      Future.delayed(Duration(seconds: 2), () {
        if (documents.isEmpty) {
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
          Navigator.pop(context);
        } else {
          setState(() {
            loading = false;
          });
        }
      });
    });
  }
}
