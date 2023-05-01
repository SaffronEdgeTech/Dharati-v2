import 'package:flutter/material.dart';

class MyProductService extends StatelessWidget {
  var doc;
  MyProductService(this.doc);

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
  var engToMar = {
    "District": "जिल्हा पातळी",
    "Taluka": "तालुका पातळी",
    "Village": "गाव पातळी",
    "State": "राज्य पातळी",
  };
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
                      child: Text(doc["Main Type"],
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
                      child: Text(doc["Sub Type"],
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
                        "विक्री परिसर",
                        textAlign: TextAlign.center,
                        style: labelTextStyle,
                      ),
                    ),
                    Expanded(
                      child: Text(engToMar[doc["Sell Level"].toString()].toString(),
                          textAlign: TextAlign.center, style: cardData),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
