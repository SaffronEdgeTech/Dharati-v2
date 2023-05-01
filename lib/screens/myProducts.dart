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
  var myProductList = ["पीक", "भाजी", "पशुधन"];
  var myProductMap = {
    "पीक": ["गहू", "ज्वारी", "तांदूळ", "मका", "नाचणी", "भुईमूग", "सोयाबीन"],
    "भाजी": [
      "मेथी",
      "पोकळा",
      "करडई",
      "पालक",
      "कांदा",
      "टोमॅटो",
      "बटाटा",
      "दोडका",
      "शेवगा",
      "पावटा",
      "गवारी",
      "वांगी",
      "काकडी",
      "गाजर",
      "मुळा",
      "कोथिंबीर",
      "आले",
      "लसूण",
      "कारले"
    ],
    "पशुधन": ["गाई", "म्हशी", "शेळ्या", "डुकरे"]
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
