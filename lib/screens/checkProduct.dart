import 'package:dharati/widgets/ProductService.dart';
import 'package:flutter/widgets.dart';
import 'package:dharati/widgets/FarmService.dart';
import 'package:flutter/material.dart';

class CheckProduct extends StatefulWidget {
  const CheckProduct({super.key});
  State<CheckProduct> createState() => _CheckProductState();
}

class _CheckProductState extends State<CheckProduct> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> documents =
        ModalRoute.of(context)!.settings.arguments as List;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "खरेदीसाठी पर्याय",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return ProductService(documents[index]);
          },
        ),
      ),
    );
  }
}
