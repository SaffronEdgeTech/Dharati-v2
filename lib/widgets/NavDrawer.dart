import 'package:dharati/services/FirebaseAllServices.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              menuItems(context),
            ],
          ),
        ),
      );

  Widget menuItems(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: 50),
        child: Wrap(
          children: [
            const Divider(
              color: Color.fromARGB(255, 9, 138, 13),
              thickness: 0.5,
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: const Text("Log Out"),
              onTap: () async {
                await FirebaseAllServices.instance.logOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/phone", (route) => false);
              },
            ),
            const Divider(
              color: Color.fromARGB(255, 9, 138, 13),
              thickness: 0.5,
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.black,
              ),
              title: const Text("Delete"),
              onTap: () async {
                await FirebaseAllServices.instance.delete();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/phone", (route) => false);
              },
            ),
            const Divider(
              color: Color.fromARGB(255, 9, 138, 13),
              thickness: 0.5,
            ),
          ],
        ),
      );
}
