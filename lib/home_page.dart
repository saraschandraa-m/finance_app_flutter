import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app_flutter/compound_interest_page.dart';
import 'package:finance_app_flutter/cpf_page.dart';
import 'package:finance_app_flutter/expense_tracker_page.dart';
import 'package:finance_app_flutter/login_page.dart';
import 'package:finance_app_flutter/rule_of_72_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";

  final PageController pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  bool showFab = true;
  ExpenseTrackerPage expenseTrackerPage = ExpenseTrackerPage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Finance App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      extendBody: true,
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          Center(
            child: expenseTrackerPage,
          ),
          const Center(
            child: CompoundInterestPage(),
          ),
          const Center(
            child: RuleOf72Page(),
          ),
          const Center(
            child: CpfPage(),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: showFab,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (BuildContext context) {
                return TransactionEnterBottomSheet(
                    expenseTrackerPage: expenseTrackerPage);
              },
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color(0xff777784),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            pageController.jumpToPage(index);
            showFab = index == 0 ? true : false;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/ic_menu_expense_tracker.png",
              width: 70,
              height: 70,
              color:
                  _selectedIndex == 0 ? Colors.blue : const Color(0xff777784),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/ic_menu_compound_interest.png",
              width: 70,
              height: 70,
              color:
                  _selectedIndex == 1 ? Colors.blue : const Color(0xff777784),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/ic_menu_rule_of_72.png",
              width: 70,
              height: 70,
              color:
                  _selectedIndex == 2 ? Colors.blue : const Color(0xff777784),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/ic_menu_cpf.png",
              width: 70,
              height: 70,
              color:
                  _selectedIndex == 3 ? Colors.blue : const Color(0xff777784),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

class TransactionEnterBottomSheet extends StatefulWidget {
  ExpenseTrackerPage expenseTrackerPage;

  TransactionEnterBottomSheet({
    super.key,
    required this.expenseTrackerPage,
  });

  @override
  State<StatefulWidget> createState() =>
      _TransactionEnterBottomSheet(expenseTrackerPage: expenseTrackerPage);
}

class _TransactionEnterBottomSheet extends State<TransactionEnterBottomSheet> {
  final categoryController = TextEditingController();
  final amountController = TextEditingController();

  int? _selectedValue;

  ExpenseTrackerPage expenseTrackerPage;

  _TransactionEnterBottomSheet({
    required this.expenseTrackerPage,
  });

  void addTransaction() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    Map<String, Object> values = {};
    values["type"] = _selectedValue!;
    values["expenseTitle"] = categoryController.text.toString();
    values["amount"] = double.parse(amountController.text.toString());
    values["currentTimeMilli"] = DateTime.now().millisecondsSinceEpoch;

    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('transactions')
          .doc(currentUser.uid)
          .collection('transactions')
          .add(values)
          .then((documentSnapshot) {
        Navigator.pop(context);
        setState(() {
          expenseTrackerPage.getState().refresh();
        });
      }).catchError((error) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xff777784)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter Transaction',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: RadioListTile<int>(
                  title: const Text(
                    'Credit',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  value: 0,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                    // _selectedValue = value; // Update the selected value
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: RadioListTile<int>(
                  title: const Text(
                    'Debit',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  value: 1,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                ),
              ),
            ],
          ),

          //Category Controller
          Container(
            decoration: BoxDecoration(
              color: const Color(0x7f3d3c4a),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: const Color(0xff777784)),
            ),
            margin: const EdgeInsets.fromLTRB(0, 48, 0, 16),
            child: TextField(
              controller: categoryController,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.white60,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter transaction title",
                contentPadding:
                    EdgeInsets.only(left: 16, bottom: 16, top: 16, right: 16),
              ),
            ),
          ),

          //Amount Controller
          Container(
            decoration: BoxDecoration(
              color: const Color(0x7f3d3c4a),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: const Color(0xff777784)),
            ),
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.white60,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter transaction amount",
                contentPadding:
                    EdgeInsets.only(left: 16, bottom: 16, top: 16, right: 16),
              ),
            ),
          ),

          //Add Button
          Container(
            margin: const EdgeInsets.fromLTRB(0, 16, 16, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0)),
              onPressed: () {
                if (_selectedValue == null ||
                    categoryController.text.isEmpty ||
                    amountController.text.isEmpty) {
                } else {
                  addTransaction();
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
        ],
      ),
    );
  }
}
