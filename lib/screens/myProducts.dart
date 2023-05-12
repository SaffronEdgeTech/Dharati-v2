import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dharati/widgets/MyProducts.dart';
import 'package:dharati/widgets/ProductService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  bool loading = true;
  bool get loadingSts => loading;
  List<dynamic> documents = [];
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  final firestoreInstance = FirebaseFirestore.instance;
  var myProductList = [
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
  var myProductMap = {
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

  @override
  void initState() {
    super.initState();
    documents.clear();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final Map userDetails = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "उपलब्ध उत्पादने",
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
                  return MyProductService(documents[index]);
                },
              ),
            ),
    );
  }

  void getProducts() {
    firestoreInstance.collection("Products").doc(uid).get().then((value) {
      for (String product in myProductList) {
        for (String productType in myProductMap[product]!) {
          try {
            firestoreInstance
                .collection("Products")
                .doc(uid)
                .collection(product + productType)
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
            "उत्पादने उपलब्ध नाहीत",
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
