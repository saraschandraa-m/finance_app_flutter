import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseTrackerPage extends StatefulWidget {
  late _ExpenseTrackerPageState expenseTrackerPageState;

  @override
  State<StatefulWidget> createState() {
    expenseTrackerPageState = _ExpenseTrackerPageState();
    return expenseTrackerPageState;
  }

  getState() => expenseTrackerPageState;
}

class Transaction {
  int type = 0;
  String transactionTitle = "";
  double amount = 0.0;
  int currentTimeInMillis = 0;
}

class _ExpenseTrackerPageState extends State<ExpenseTrackerPage> {
  String totalBalance = "";
  String totalCreditAmount = "";
  String totalDebitAmount = "";

  double credit = 0.0;
  double debit = 0.0;

  bool showTransactions = false;

  List<Transaction> transactions = [];

  refresh() {
    loadDataFromFireStore();
  }

  void calculateTotalBalance() {
    credit = 0.0;
    debit = 0.0;
    for (var transaction in transactions) {
      if (transaction.type == 0) {
        credit = credit + transaction.amount;
      } else {
        debit = debit + transaction.amount;
      }
    }
    setState(() {
      totalCreditAmount = "s\$ ${credit}";
      totalDebitAmount = "s\$ ${debit}";
      totalBalance = "s\$ ${credit - debit}";
      showTransactions = true;
    });
  }

  void loadDataFromFireStore() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    transactions.clear();

    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('transactions')
          .doc(currentUser.uid)
          .collection('transactions')
          .get()
          .then((QuerySnapshot querySnapshot) {
        setState(() {
          for (var snapshot in querySnapshot.docs) {
            Transaction item = new Transaction();
            item.type = int.parse(snapshot.get("type").toString());
            item.amount = double.parse(snapshot.get("amount").toString());
            item.currentTimeInMillis =
                int.parse(snapshot.get("currentTimeMilli").toString());
            item.transactionTitle = snapshot.get("expenseTitle").toString();

            transactions.add(item);
          }
          calculateTotalBalance();
        });
      }).catchError((error) {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadDataFromFireStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: 16,
                ),
                Text(
                  totalBalance,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.left,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFF71FF05),
                              border:
                                  Border.all(color: const Color(0xff777784)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Credit',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Container(
                                          height: 20,
                                        ),
                                        Text(
                                          totalCreditAmount,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFFB80505),
                              border:
                                  Border.all(color: const Color(0xff777784)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Debit',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                        Container(
                                          height: 20,
                                        ),
                                        Text(
                                          totalDebitAmount,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: const Icon(
                                      Icons.arrow_upward,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xff020202),
                    border: Border.all(color: const Color(0xff020202)),
                  ),
                ),
                const Text(
                  'Transactions',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: 20,
                ),
                Visibility(
                  visible: showTransactions,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      var dt = DateTime.fromMicrosecondsSinceEpoch(
                          transactions[index].currentTimeInMillis);

                      return TransactionListItem(
                          expenseTitle: transactions[index].transactionTitle,
                          expense: "s\$ ${transactions[index].amount}",
                          dateOfTransaction: DateFormat("dd-MMM-yyyy").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  transactions[index].currentTimeInMillis)),
                          transactionType: transactions[index].type);
                    },
                  ),
                ),
                Container(
                  height: 50,
                ),
              ],
            ),
          ),
        ));
  }
}

class TransactionListItem extends StatelessWidget {
  String expenseTitle = "";
  String expense = "";
  String dateOfTransaction = "";
  int transactionType = 0;

  TransactionListItem({
    required this.expenseTitle,
    required this.expense,
    required this.dateOfTransaction,
    required this.transactionType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: const Color(0xff1F2023),
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            border: Border.all(color: const Color(0xff777784)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      expenseTitle,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      dateOfTransaction,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: transactionType == 0
                    ? const Icon(Icons.arrow_downward, color: Colors.green)
                    : const Icon(Icons.arrow_upward, color: Colors.red),
              )
            ],
          ),
        ));
  }
}
