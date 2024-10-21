import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class RuleOf72Page extends StatefulWidget {
  const RuleOf72Page({super.key});

  @override
  State<StatefulWidget> createState() => _RuleOf72PageState();
}

class _RuleOf72PageState extends State<RuleOf72Page> {
  final annualInterestController = TextEditingController();
  final yearsToDoubleController = TextEditingController();

  bool showAnnualRateInterest = false;
  bool showYearsToDouble = false;

  String annualInterestRate = "";
  String yearsNeedToDouble = "";

  @override
  void initState() {
    super.initState();
    showYearsToDouble = false;
    showAnnualRateInterest = false;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('rule_of_72'),
      onVisibilityChanged: (VisibilityInfo info) {
        bool isVisible = info.visibleFraction != 0;
        if (!isVisible) {
          annualInterestController.clear();
          yearsToDoubleController.clear();

          annualInterestRate = "";
          yearsNeedToDouble = "";
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(
                  child: Text(
                    'Rule of 72',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                //Annual Interest Container
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x7f3d3c4a),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: const Color(0xff777784)),
                  ),
                  margin: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                  child: TextField(
                    controller: annualInterestController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.white60,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Annual Interest Rate(%)",
                      contentPadding: EdgeInsets.only(
                          left: 16, bottom: 16, top: 16, right: 16),
                    ),
                  ),
                ),

                //Calculate Button
                Container(
                  margin: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0)),
                    onPressed: () {
                      if (annualInterestController.text.isEmpty) {
                      } else {
                        setState(() {
                          int rateOfInterest = int.parse(
                              annualInterestController.text.toString());
                          annualInterestRate =
                              "Rule of 72 Estimate:  ${(72 / rateOfInterest).toDouble().toStringAsPrecision(2)} years";
                          showAnnualRateInterest = true;
                          showYearsToDouble = false;
                          yearsToDoubleController.clear();
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.all(16),
                      child: const Center(
                        child: Text(
                          'Calculate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: showAnnualRateInterest,
                  child: Text(
                    annualInterestRate,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                ),

                Container(
                  color: const Color(0xff777784),
                  margin: EdgeInsets.all(16),
                  height: 2,
                ),

                //Years To Double Interest Container
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x7f3d3c4a),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: const Color(0xff777784)),
                  ),
                  margin: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                  child: TextField(
                    controller: yearsToDoubleController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.white60,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Years to Double Investment",
                      contentPadding: EdgeInsets.only(
                          left: 16, bottom: 16, top: 16, right: 16),
                    ),
                  ),
                ),

                //Calculate Button
                Container(
                  margin: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0)),
                    onPressed: () {
                      if (yearsToDoubleController.text.isEmpty) {
                      } else {
                        setState(() {
                          int yearsToDouble = int.parse(
                              yearsToDoubleController.text.toString());
                          yearsNeedToDouble =
                              "Rule of 72 Estimate:  ${(72 / yearsToDouble).toDouble().toStringAsPrecision(2)}%";
                          showAnnualRateInterest = false;
                          showYearsToDouble = true;
                          annualInterestController.clear();
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.all(16),
                      child: const Center(
                        child: Text(
                          'Calculate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: showYearsToDouble,
                  child: Text(
                    yearsNeedToDouble,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
