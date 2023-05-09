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
import 'package:dharati/screens/cropManagement.dart';
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
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(FirebaseAllServices());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/phone': (context) => const PhoneNum(),
        '/otp': (context) => const OTPVerification(),
        '/cropManagement': (context) => const CropManagement(),
        '/dosageCalculator': (context) => const DosageCalculation(),
        '/buyProduct': (context) => const BuyProduct(),
        '/sellProduct': (context) => const SellProduct(),
        '/buyFarmingServices': (context) => const BuyFarmingServices(),
        '/sellFarmingServices': (context) => const SellFarmingServices(),
        '/chooseService': (context) => const ChooseService(),
        '/checkProduct': (context) => const CheckProduct(),
        '/showServices': (context) => const FarmingServices(),
        '/myFarmingServices': (context) => const MyFarmingServices(),
        '/myProducts': (context) => const MyProducts(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null && mounted) {
          Get.offNamedUntil("/chooseService", (route) => false);
        } else {
          Get.offNamedUntil("/phone", (route) => false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/Krushee-Sanskrutee.png',
          width: 500,
          height: 500,
        ),
      ),
    );
  }
}
