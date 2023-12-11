import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(ExpenseTrackerApp());

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpenseListScreen(),
    );
  }
}

class ExpenseListScreen extends StatefulWidget {
  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<Expense> expenses = []; // List to hold expenses

  void _addExpense(String expenseName) {
    setState(() {
      expenses.add(Expense(name: expenseName, timestamp: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Expense Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Lottie.asset(
              'assets/expence.json', // Replace with your Lottie animation file
              height: 300, // Adjust the height as needed
            ),
            ElevatedButton(
              onPressed: () {
                _navigateToAddExpenseScreen(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.black, // Set this to black
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 12.0,
                ),
              ),
              child: const Text(
                'Add Expense',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddExpenseScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddExpenseScreen()),
    );
    if (result != null) {
      _addExpense(result);
    }
  }
}

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _expenseController = TextEditingController();
  List<Expense> localExpenses =
      []; // Local list to hold expenses for this screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Add Expense',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _expenseController,
              decoration: const InputDecoration(
                labelText: 'Expense Name',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _submitExpense(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
              child: const Text('Save Expense'),
            ),
            const SizedBox(height: 50.0),
            const Row(
              children: [
                Text(
                  'Expenses List:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 100.0,
                ),
                Text(
                  'Date & Time:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: localExpenses.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      '${localExpenses[index].name} ',
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    trailing: Text(
                      '${_formatDateTime(localExpenses[index].timestamp)}, ',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitExpense(BuildContext context) {
    if (_expenseController.text.isNotEmpty) {
      setState(() {
        localExpenses.add(
            Expense(name: _expenseController.text, timestamp: DateTime.now()));
      });
      _expenseController.clear();
    } else {
      if (_expenseController.text.isEmpty) {
        Fluttertoast.showToast(
          msg: "Add your expense please",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}

class Expense {
  final String name;
  final DateTime timestamp;

  Expense({required this.name, required this.timestamp});
}
