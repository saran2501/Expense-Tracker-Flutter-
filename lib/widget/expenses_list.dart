import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widget/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const  ExpenseList({super.key, required this.expenses,required this.onRemoveExpense});
  final void Function(Expense expense) onRemoveExpense;
  final List<Expense> expenses;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) => Dismissible(
            key: ValueKey(expenses[index]),
            onDismissed:(direction){
              onRemoveExpense(expenses[index]);
            } ,
            child: ExpenseItem(expense: expenses[index])));
  }
}
