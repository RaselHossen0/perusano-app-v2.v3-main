import 'dart:math';

import 'package:flutter/material.dart';
import 'package:perusano/services/translateService.dart';

class GaugeData {
  GaugeData(
      {required this.diagnostic,
      required this.numberOfSections,
      required this.colours,
      required this.sectionsText,
      required this.sectionDividerValues,
      required this.gaugeWidth,
      required this.gaugeHeight});
  final int diagnostic;
  final int numberOfSections;
  final List colours;
  final List sectionsText;
  final List sectionDividerValues;
  final double gaugeWidth;
  final double gaugeHeight;
}

class gauge extends StatelessWidget {
  Widget createWeightForLengthDiagnosticGauge(
      int diagnostic,
      int numberOfSections,
      List colours,
      List sectionsText,
      List sectionDividerValues,
      double gaugeWidth,
      double gaugeHeight,
      BuildContext context) {
    print('here');
    print(diagnostic);
    double hArrowPositioning = 0;
    // if (hValue < severeAnemiaLimit) {
    //   // hArrowPositioning = 0;
    //   hArrowPositioning = (hValue * (severeAnemiaLimit / width)) * width;
    //   print("severe");
    //   print(hValue);
    //   print(hArrowPositioning);
    //   hArrowPositioning = 45;
    // } else if (hValue < moderateAnemiaLimit) {
    //   hArrowPositioning =
    //       (hValue * ((moderateAnemiaLimit - severeAnemiaLimit) / width)) *
    //               width +
    //           (width);
    //   print("moderate");
    //   print(hValue);
    //   print(hArrowPositioning);
    //   hArrowPositioning = 45 + 77;
    // } else if (hValue < lightAnemiaLimit) {
    //   hArrowPositioning =
    //       (hValue * ((lightAnemiaLimit - moderateAnemiaLimit) / width)) *
    //               width +
    //           (width + 2);
    //   print("light");
    //   print(hValue);
    //   print(hArrowPositioning);
    //   hArrowPositioning = 93 + 77;
    // } else {
    //   hArrowPositioning =
    //       (hValue * ((noAnemiaLimit - lightAnemiaLimit) / width)) * width +
    //           (width * 3);
    //   print("no");
    //   print(hValue);
    //   print(hArrowPositioning);
    //   hArrowPositioning = 150 + 77;
    //   if (hArrowPositioning > width * 4) {
    //     hArrowPositioning = (width * 4) - 20;
    //   }
    // }
    return SizedBox(
      height: gaugeHeight * 3,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 15,
            child: SizedBox(
              height: gaugeHeight,
              child: Row(
                children: [
                  SizedBox(
                    width: gaugeWidth / 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius:
                            BorderRadius.horizontal(left: Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate(
                            'anemiaCheckPage.strict',
                          ),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 243, 243, 243),
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: gaugeWidth / 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate(
                              'anemiaCheckPage.moderate'),
                          style: const TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: gaugeWidth / 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate('anemiaCheckPage.mild'),
                          style: const TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: gaugeWidth / 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate('anemiaCheckPage.without'),
                          style: const TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: gaugeWidth / 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius:
                            BorderRadius.horizontal(right: Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(
                          TranslateService.translate(
                            'anemiaCheckPage.strict',
                          ),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 243, 243, 243),
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: gaugeHeight + 1,
            left: hArrowPositioning,
            child: const Icon(
              Icons.arrow_drop_down,
              size: 30.2,
            ),
          ),
          Positioned(
            bottom: 10,
            left: hArrowPositioning,
            child: Transform.rotate(
              angle: 90 * pi / 180,
              child: const Icon(
                Icons.horizontal_rule,
                size: 30,
              ),
            ),
          ),
          Positioned(
            bottom: gaugeHeight * 2,
            left: hArrowPositioning,
            child: Text(
              '${diagnostic}g/Dl',
            ),
          ),
          // Positioned(
          //   bottom: 15,
          //   right: 0.0,
          //   child: InkWell(
          //     onTap: () => _showMyDialog(context),
          //     child: const Icon(Icons.info),
          //   ),
          // ),
          Positioned(
            bottom: 0.0,
            left: (gaugeWidth / 5) - 10,
            // child: Text(severeAnemiaLimit.toString()),
            child: const Text('tmp'),
          ),
          Positioned(
            bottom: 0.0,
            left: ((gaugeWidth * 2) / 5) - 10,
            // child: Text(moderateAnemiaLimit.toString()),
            child: const Text('tmp'),
          ),
          Positioned(
            bottom: 0.0,
            left: ((gaugeWidth * 3) / 5) - 15,
            // child: Text(lightAnemiaLimit.toString()),
            child: const Text('tmp'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
