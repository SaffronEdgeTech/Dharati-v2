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
    final List<dynamic> documents = ModalRoute.of(context)!.settings.arguments as List;
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return FarmService(documents[index]);
          },
        ),
      ),
    );
  }
}
