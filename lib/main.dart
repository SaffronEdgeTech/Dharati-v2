import 'dart:async';
import 'package:dharati/screens/buyFarmingServices.dart';
import 'package:dharati/screens/buyProduct.dart';
import 'package:dharati/screens/checkProduct.dart';
import 'package:dharati/screens/chooseService.dart';
import 'package:dharati/screens/dosageCalculator.dart';
import 'package:dharati/screens/myFarmingServices.dart';
import 'package:dharati/screens/myProducts.dart';
import 'package:dharati/screens/sellFarmingServices.dart';
import 'package:dharati/screens/sellProduct.dart';
import 'package:dharati/screens/showFarmingServices.dart';
import 'package:dharati/services/FirebaseAllServices.dart';
import 'package:dharati/screens/userDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dharati/screens/phone.dart';
import 'package:dharati/screens/otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dharati/services/firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DharatiApp());
}

class DharatiApp extends StatefulWidget {
  const DharatiApp({super.key});
  @override
  State<DharatiApp> createState() => _DharatiAppState();
}

class _DharatiAppState extends State<DharatiApp> {
  bool userLoggedIn = false;

  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(FirebaseAllServices());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: userLoggedIn ? const ChooseService() : const PhoneNum(),
      routes: {
        '/phone': (context) => const PhoneNum(),
        '/otp': (context) => const OTPVerification(),
        '/userdetails': (context) => const UserDetails(),
        '/dosageCalculator': (context) => const DosageCalculation(),
        '/buyProduct': (context) => const BuyProduct(),
        '/sellProduct': (context) => const SellProduct(),
        '/buyFarmingServices': (context) => const BuyFarmingServices(),
        '/sellFarmingServices': (context) => const SellFarmingServices(),
        '/chooseService': (context) => const ChooseService(),
        '/checkProduct': (context) => const CheckProduct(),
        '/showServices':(context) => const FarmingServices(),
        '/myFarmingServices':(context) => const MyFarmingServices(),
        '/myProducts':(context) => const MyProducts(),
      },
    );
  }

  checkLoginStatus() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          userLoggedIn = true;
        });
      } else {
        setState(() {
          userLoggedIn = false;
        });
      }
    });
  }
}
