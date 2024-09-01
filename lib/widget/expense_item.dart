import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense});
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    expense.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                transicon(expense.transtype),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('₹${expense.amount.toStringAsFixed(2)}'),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryicons[expense.category]),
                    const SizedBox(width: 8),
                    Text(expense.formattedDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget transicon(TransactionType transtypes) {
  if (transtypes == TransactionType.income) {
    return const CircleAvatar(
      radius: 20,
      backgroundColor: Color.fromARGB(255, 10, 10, 10),
      child: Icon(
        Icons.arrow_drop_down_outlined,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  if (transtypes == TransactionType.expense) {
    return const CircleAvatar(
      radius: 20,
      backgroundColor: Color.fromARGB(255, 10, 10, 10),
      child: Icon(
        Icons.arrow_drop_up_outlined,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  return Container();
}
