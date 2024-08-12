import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onaddExpense});
  final void Function(Expense expensee) onaddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titlecontroller = TextEditingController();
  final _amountcontroller = TextEditingController();
  DateTime? _date;
  Category _selectedcat = Category.entertainment;
  void _presentdatepicker() async {
    final now = DateTime.now();
    final intialdate = DateTime(now.year - 1, now.month, now.day);
    final pickdate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: intialdate,
        lastDate: now);

    setState(() {
      _date = pickdate;
    });
  }

  void _submitdata() {
    final enteredamount = double.tryParse(_amountcontroller.text);
    final amountisinvalid = enteredamount == null || enteredamount < 0;

    if (_titlecontroller.text.trim().isEmpty ||
        amountisinvalid ||
        _date == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure a valid title ,amount ,date and categorgy is entered'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'))
          ],
        ),
      );
      
      return;
    }
    widget.onaddExpense(Expense(
        title: _titlecontroller.text,
        amount: enteredamount,
        date: _date!,
        category: _selectedcat));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    _amountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,48,16,16),
      child: Column(
        children: [
          TextField(
            controller: _titlecontroller,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: _amountcontroller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: '₹',
              label: Text('amount'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(_date == null
                  ? 'No Date Selected'
                  : formatter.format(_date!)),
              IconButton(
                onPressed: _presentdatepicker,
                icon: const Icon(Icons.calendar_month_outlined),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              DropdownButton(
                  value: _selectedcat,
                  items: Category.values
                      .map(
                        (Category) => DropdownMenuItem(
                          value: Category,
                          child: Text(
                            Category.name.toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedcat = value;
                    });
                  }),
             const  Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
             const  Spacer(),
              ElevatedButton(
                onPressed: () {
                  _submitdata();
                  
                },
                child: const Text('Save '),
              ),
            ],
          )
        ],
      ),
    );
  }
}
