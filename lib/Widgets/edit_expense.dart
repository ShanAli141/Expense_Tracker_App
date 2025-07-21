import 'package:first_project/Hive%20Model/hive_expense_model.dart';
import 'package:flutter/material.dart';

class ExpenseEditScreen extends StatefulWidget {
  final int index;
  final Expense expense;

  const ExpenseEditScreen({
    super.key,
    required this.index,
    required this.expense,
  });

  @override
  State<ExpenseEditScreen> createState() => _ExpenseEditScreenState();
}

class _ExpenseEditScreenState extends State<ExpenseEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _purposeController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _purposeController = TextEditingController(text: widget.expense.purpose);
    _amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
    _selectedDate = widget.expense.date;
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    final title = _titleController.text.trim();
    final purpose = _purposeController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid title and amount")),
      );
      return;
    }

    final updatedExpense = Expense(
      title: title,
      amount: amount,
      purpose: purpose,
      date: _selectedDate,
    );

    Navigator.pop(context, updatedExpense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _purposeController,
              decoration: const InputDecoration(labelText: "Purpose"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text("Pick Date"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text("Update Expense"),
            ),
          ],
        ),
      ),
    );
  }
}
