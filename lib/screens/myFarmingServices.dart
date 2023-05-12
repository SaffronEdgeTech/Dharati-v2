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
