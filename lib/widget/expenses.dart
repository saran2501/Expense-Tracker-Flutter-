import 'package:expense_tracker/widget/chart/chart.dart';
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
    });
  }

  void _removeExpense(Expense expense) {
    final expenseindex= _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
       });
       ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text('expense deleted'),
           action:SnackBarAction(label: 'Undo', onPressed: (){
            setState(() {
               _registeredExpenses.insert(expenseindex, expense);
            });
         
        }
        ),
        ),
      );
   
  }

  @override
  Widget build(BuildContext context) {
    Widget maincontent = const Center(child: Text('No Expense added ',style: TextStyle(fontSize: 25),));

    if (_registeredExpenses.isNotEmpty) {
      maincontent = ExpenseList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
     appBar: AppBar(
  title: const Text("Expense Tracker"),
  actions: [
    IconButton(
      onPressed: _openAddExpenseOverlay,
      icon: const Icon(
        Icons.add,
        size: 45, // Increase the size of the icon
      ),
      color: Theme.of(context).iconTheme.color, // Ensures color consistency with the theme
      tooltip: 'Add Expense', // Provides additional information on hover (for web)
    ),
  ],
),

      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child: maincontent),
        ],
      ),
    );
  }
}

