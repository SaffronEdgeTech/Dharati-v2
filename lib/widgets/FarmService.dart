import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FarmService extends StatelessWidget {
  var doc;
  FarmService(this.doc);

  TextStyle labelTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.green.shade600,
  );
  TextStyle cardData = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        margin: const EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "सेवा",
                        textAlign: TextAlign.center,
                        style: labelTextStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(doc["Service"],
                          textAlign: TextAlign.center, style: cardData),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "सेवा प्रकार",
                        textAlign: TextAlign.center,
                        style: labelTextStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(doc["Service Type"],
                          textAlign: TextAlign.center, style: cardData),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "सेवा पासून",
                        textAlign: TextAlign.center,
                        style: labelTextStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(doc["Start Date"],
                          textAlign: TextAlign.center, style: cardData),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "सेवा पर्यंत",
                        textAlign: TextAlign.center,
                        style: labelTextStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(doc["End Date"],
                          textAlign: TextAlign.center, style: cardData),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "गाव",
                        textAlign: TextAlign.center,
                        style: labelTextStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(doc["Village"],
                          textAlign: TextAlign.center, style: cardData),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "तालुका",
                        textAlign: TextAlign.center,
                        style: labelTextStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(doc["Taluka"],
                          textAlign: TextAlign.center, style: cardData),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "जिल्हा",
                        textAlign: TextAlign.center,
                        style: labelTextStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(doc["District"],
                          textAlign: TextAlign.center, style: cardData),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "भ्रमणध्वनी क्रमांक",
                        textAlign: TextAlign.center,
                        style: labelTextStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        doc["Phone Number"],
                        textAlign: TextAlign.center,
                        style: cardData,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      final Uri url = Uri(
                          scheme: "tel", path: doc["Phone Number"].toString());
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        Get.snackbar(
                          "तसदीबद्दल क्षमस्व",
                          "",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          isDismissible: true,
                          dismissDirection: DismissDirection.horizontal,
                          margin: EdgeInsets.all(15),
                          forwardAnimationCurve: Curves.easeOutBack,
                          colorText: Colors.white,
                        );
                      }
                    },
                    label: Text(
                      "संपर्क करा",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
