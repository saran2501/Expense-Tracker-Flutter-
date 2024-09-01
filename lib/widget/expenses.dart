import 'package:expense_tracker/widget/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widget/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];
  double _totalIncome = 0;
  double _totalExpense = 0;

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onaddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
      if (expense.transtype == TransactionType.income) {
        _totalIncome += expense.amount;
      } else {
        _totalExpense += expense.amount;
      }
    });
  }

  void _removeExpense(Expense expense) {
    final expenseindex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
      if (expense.transtype == TransactionType.income) {
        _totalIncome -= expense.amount;
      } else {
        _totalExpense -= expense.amount;
      }
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseindex, expense);
              if (expense.transtype == TransactionType.income) {
                _totalIncome += expense.amount;
              } else {
                _totalExpense += expense.amount;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget maincontent = const Center(
      child: Text(
        'No Expense added ',
        style: TextStyle(fontSize: 25),
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      maincontent = ExpenseList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 8, 235, 167),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text("Expense Tracker"),
            actions: [
              IconButton(
                onPressed: _openAddExpenseOverlay,
                icon: const Icon(
                  Icons.add,
                  size: 45,
                ),
                color: Theme.of(context).iconTheme.color,
                tooltip: 'Add Expense',
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 240,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 8, 235, 167),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, left: 16, right: 16),
                      child: Row(
                        children: [
                          Text(
                            'Total Balance',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Text(
                        '₹${(_totalIncome - _totalExpense).toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 241, 241, 241),
                            fontSize: 25),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                const     Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                               CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    Color.fromARGB(255, 10, 10, 10),
                                child: Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                               SizedBox(
                                width: 7,
                              ),
                              Text(
                                'Income',
                                style:  TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 241, 241, 241),
                                    fontSize: 25),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                               CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    Color.fromARGB(255, 10, 10, 10),
                                child: Icon(
                                  Icons.arrow_drop_up_outlined,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                               SizedBox(
                                width: 7,
                              ),
                              Text(
                                'Expense',
                                style:  TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 241, 241, 241),
                                    fontSize: 25),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${_totalIncome.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 241, 241, 241),
                                fontSize: 25),
                          ),
                          Text(
                            '₹${_totalExpense.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 241, 241, 241),
                                fontSize: 25),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(child: maincontent),
            ],
          ),
        ],
      ),
    );
  }
}
