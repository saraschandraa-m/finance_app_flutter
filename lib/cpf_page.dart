import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CpfPage extends StatefulWidget {
  const CpfPage({super.key});

  @override
  State<StatefulWidget> createState() => _CpfPageState();
}

class _CpfPageState extends State<CpfPage> {
  final salaryController = TextEditingController();
  final numberOfYearsController = TextEditingController();

  double salary = 0.0;
  int numberOfYears = 0;
  bool showTable = false;

  String ordinaryAccount = "";
  String specialAccount = "";
  String mediSaveAccount = "";

  @override
  void initState() {
    super.initState();
    showTable = false;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('cpf_page'),
      onVisibilityChanged: (VisibilityInfo info) {
        bool isVisible = info.visibleFraction != 0;
        if (!isVisible) {
          salaryController.clear();
          numberOfYearsController.clear();

          numberOfYears = 0;
          salary = 0.0;
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
                    'CPF Calculator',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                //Salary Container
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x7f3d3c4a),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: const Color(0xff777784)),
                  ),
                  margin: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                  child: TextField(
                    controller: salaryController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.white60,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter your Salary",
                      contentPadding: EdgeInsets.only(
                          left: 16, bottom: 16, top: 16, right: 16),
                    ),
                  ),
                ),

                //Years Container
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
                      hintText: "Enter number of years",
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
                      if (salaryController.text.isEmpty ||
                          numberOfYearsController.text.isEmpty) {
                      } else {
                        setState(() {
                          salary =
                              double.parse(salaryController.text.toString());
                          numberOfYears = int.parse(
                              numberOfYearsController.text.toString());

                          ordinaryAccount =
                              "s\$ ${salary * 0.23 * numberOfYears}";
                          specialAccount =
                              "s\$ ${salary * 0.06 * numberOfYears}";
                          mediSaveAccount =
                              "s\$ ${salary * 0.08 * numberOfYears}";

                          showTable = true;
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
                    visible: showTable,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        children: [
                          const Text(
                            'CPF Values',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0x7f3d3c4a),
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: const Color(0xff777784)),
                            ),
                            margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Center(
                                        child: Text(
                                          'Ordinary Account\n (23%)',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: const Color(0xff777784),
                                      width: 2,
                                      height: 50,
                                    ),
                                    const Expanded(
                                      child: Center(
                                        child: Text(
                                          'Special Account\n (6%)',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: const Color(0xff777784),
                                      width: 2,
                                      height: 50,
                                    ),
                                    const Expanded(
                                      child: Center(
                                        child: Text(
                                          'Medisave Account\n (8%)',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: const Color(0xff777784),
                                  height: 2,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          ordinaryAccount,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: const Color(0xff777784),
                                      width: 2,
                                      height: 40,
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          specialAccount,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: const Color(0xff777784),
                                      width: 2,
                                      height: 40,
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          mediSaveAccount,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
