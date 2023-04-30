import 'package:dharati/services/FirebaseAllServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavDrawer extends StatelessWidget {
  final details;
  const NavDrawer({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final TextStyle listOptionsTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: Colors.black,
    );
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "नमस्कार",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              details["PhoneNum"].toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text(
              "सेवा निवडा",
              style: listOptionsTextStyle,
            ),
            onTap: () {
              Get.offNamedUntil("/chooseService", (route) => false);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black,
            ),
            title: Text(
              "उत्पादने",
              style: listOptionsTextStyle,
            ),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed("/myProducts", arguments: details);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.miscellaneous_services,
              color: Colors.black,
            ),
            title: Text("शेती सेवा", style: listOptionsTextStyle),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed("/myFarmingServices", arguments: details);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            title: Text(
              "बाहेर पडा",
              style: listOptionsTextStyle,
            ),
            onTap: () async {
              await FirebaseAllServices.instance.logOut();
              Get.offNamedUntil("/phone", (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
