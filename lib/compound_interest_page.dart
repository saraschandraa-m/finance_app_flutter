import 'dart:math';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CompoundInterestPage extends StatefulWidget {
  const CompoundInterestPage({super.key});

  @override
  State<StatefulWidget> createState() => _CompoundInterestPageState();
}

class _CompoundInterestPageState extends State<CompoundInterestPage> {
  final principalInvestmentController = TextEditingController();
  final annualInterestRateController = TextEditingController();
  final compoundsPerYearController = TextEditingController();
  final numberOfYearsController = TextEditingController();

  String futureValue = "";
  String principalInterest = "";

  bool showCompoundInterest = false;

  @override
  void initState() {
    super.initState();
    showCompoundInterest = false;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: const Key('compound_interest_page'),
        onVisibilityChanged: (VisibilityInfo info) {
          bool isVisible = info.visibleFraction != 0;
          if (!isVisible) {
            principalInvestmentController.clear();
            annualInterestRateController.clear();
            compoundsPerYearController.clear();
            numberOfYearsController.clear();

            futureValue = "";
            principalInterest = "";
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
                  children: [
                    const Center(
                      child: Text(
                        'Compound Interest Calculator',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    //Principal Investment Container
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0x7f3d3c4a),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color(0xff777784)),
                      ),
                      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: TextField(
                        controller: principalInvestmentController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.white60,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Principal Investment",
                          contentPadding: EdgeInsets.only(
                              left: 16, bottom: 16, top: 16, right: 16),
                        ),
                      ),
                    ),

                    //Annual Interest Rate Container
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0x7f3d3c4a),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color(0xff777784)),
                      ),
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: TextField(
                        controller: annualInterestRateController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.white60,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Annual Interest Rate",
                          contentPadding: EdgeInsets.only(
                              left: 16, bottom: 16, top: 16, right: 16),
                        ),
                      ),
                    ),

                    //Compounds Per Year Container
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0x7f3d3c4a),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color(0xff777784)),
                      ),
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: TextField(
                        controller: compoundsPerYearController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.white60,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Compounds per year",
                          contentPadding: EdgeInsets.only(
                              left: 16, bottom: 16, top: 16, right: 16),
                        ),
                      ),
                    ),

                    //Number of Years Container
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0x7f3d3c4a),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color(0xff777784)),
                      ),
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: TextField(
                        controller: numberOfYearsController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.white60,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Number of Years",
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
                          setState(() {
                            showCompoundInterest = true;

                            double principal = double.parse(
                                principalInvestmentController.text.toString());
                            int annualInterest = int.parse(
                                annualInterestRateController.text.toString());
                            int compoundsPerYear = int.parse(
                                compoundsPerYearController.text.toString());
                            int numberOfYears = int.parse(
                                numberOfYearsController.text.toString());

                            double rateOfInterest = annualInterest / 100;
                            double ratePerYear = double.parse(
                                (rateOfInterest / compoundsPerYear)
                                    .toStringAsPrecision(5));
                            double rate1 = 1 + ratePerYear;
                            int tenure = compoundsPerYear * numberOfYears;
                            double powAdded = double.parse(
                                pow(rate1, tenure).toStringAsPrecision(5));

                            double amount = principal * powAdded;
                            double interest = amount - principal;

                            futureValue = "s\$ $amount";
                            principalInterest = "s\$ $interest";
                          });
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
                      visible: showCompoundInterest,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          children: [
                            const Text(
                              'Compound Interest Values',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                                margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            'Future Value',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            futureValue,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            'Interest on Principal',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            principalInterest,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
