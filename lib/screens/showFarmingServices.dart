import 'package:dharati/widgets/FarmService.dart';
import 'package:flutter/material.dart';

class FarmingServices extends StatefulWidget {
  const FarmingServices({super.key});

  @override
  State<FarmingServices> createState() => _FarmingServicesState();
}

class _FarmingServicesState extends State<FarmingServices> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> documents =
        ModalRoute.of(context)!.settings.arguments as List;
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
      body: SafeArea(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return FarmService(documents[index]);
          },
        ),
      ),
    );
  }
}
