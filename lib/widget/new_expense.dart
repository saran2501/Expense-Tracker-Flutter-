import 'dart:io';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

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
  DateTime _date = DateTime.now();
  Category _selectedcat = Category.none;
  TransactionType _selectedTransactionType = TransactionType.expense;
  File? selectedfile;

  void _presentdatepicker() async {
    final now = DateTime.now();
    final intialdate = DateTime(now.year - 1, now.month, now.day);
    final pickdate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: intialdate,
      lastDate: now,
    );

    setState(() {
      _date = pickdate!;
    });
  }

  void _submitdata() {
    final enteredamount = double.tryParse(_amountcontroller.text);
    final amountisinvalid = enteredamount == null || enteredamount < 0;

    if (_titlecontroller.text.trim().isEmpty || amountisinvalid) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
            'Please make sure a valid title, amount, date, and category are entered',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );

      return;
    }

    widget.onaddExpense(
      Expense(
        title: _titlecontroller.text,
        amount: enteredamount,
        date: _date,
        category: _selectedcat,
        transtype: _selectedTransactionType,
      ),
    );
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
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titlecontroller,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountcontroller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: '₹',
              label: Text('Amount'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: RadioListTile<TransactionType>(
                  title: const Text('Income'),
                  value: TransactionType.income,
                  groupValue: _selectedTransactionType,
                  onChanged: (value) {
                    setState(() {
                      _selectedTransactionType = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<TransactionType>(
                  title: const Text('Expense'),
                  value: TransactionType.expense,
                  groupValue: _selectedTransactionType,
                  onChanged: (value) {
                    setState(() {
                      _selectedTransactionType = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(formatter.format(_date)),
              IconButton(
                onPressed: _presentdatepicker,
                icon: const Icon(Icons.calendar_month_outlined),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              DropdownButton(
                value: _selectedcat,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedcat = value;
                  });
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submitdata,
                child: const Text('Save'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _pickimage();
                  },
                  icon: const Icon(
                    Icons.image,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Text(
                    'Click the icon to add a screenshot of payment apps to add it directly',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: selectedfile != null
                ? Image.file(
                    selectedfile!,
                    fit: BoxFit.contain,
                  )
                : const Center(child: Text('Select an Image')),
          ),
        ],
      ),
    );
  }

  Future _pickimage() async {
    final Imageobtained = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (Imageobtained == null) return;

    setState(() {
      selectedfile = File(Imageobtained.path);
      _cropAndExtractText(selectedfile!);
    });
  }

  Future<void> _cropAndExtractText(File file) async {
    img.Image? originalImage = img.decodeImage(await file.readAsBytes());

    if (originalImage == null) {
      return;
    }

    int width = originalImage.width;
    int height = originalImage.height;

    int y = (height * 0.15).toInt();
    int cropHeight = (height * 0.8).toInt();

    int x = (width * 0.7).toInt();
    int cropWidth = (width * 0.7).toInt();

    img.Image croppedImage = img.copyCrop(originalImage, x, y, cropWidth, cropHeight);

    File croppedFile = File('${file.path}_cropped.jpg')..writeAsBytesSync(img.encodeJpg(croppedImage));

    _extracttext(croppedFile);
  }

  Future<void> _extracttext(File file) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    String text = recognizedText.text;

    text = text.replaceAll(RegExp(r'7(?=\d)'), '₹');

    print('Full recognized text after processing:');
    print(text);
    String writing = "Online payments";
    double totalSpent = _calculateTotalSpent(text);
    _amountcontroller.text = totalSpent.toStringAsFixed(2);
    _titlecontroller.text = writing;

    print('Total Spent: ₹$totalSpent');
  }

  double _calculateTotalSpent(String text) {
    List<String> lines = text.split('\n');

    double total = 0.0;

    for (String line in lines) {
      RegExp regExp = RegExp(r'₹?\d{1,3}(,\d{3})*(\.\d{2})?');

      Iterable<RegExpMatch> matches = regExp.allMatches(line);

      for (var match in matches) {
        String matchStr = match.group(0)!;

        if (!RegExp(r'^\d{1,2}:\d{2}(:\d{2})?$').hasMatch(matchStr)) {
          String cleanedMatchStr = matchStr.replaceAll('₹', '').replaceAll(',', '');
          double amount = double.tryParse(cleanedMatchStr) ?? 0.0;

          if (!line.contains('+')) {
            total += amount;
          }
        }
      }
    }

    return total;
  }
}
