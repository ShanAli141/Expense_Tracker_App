// ignore_for_file: use_build_context_synchronously

import 'package:first_project/Bloc/expense_cubit.dart';
import 'package:first_project/Hive%20Model/expense.dart';
import 'package:first_project/Screens/expense_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _purposeController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

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

    final newExpense = Expense(
      title: title,
      amount: amount,
      date: _selectedDate,
      purpose: purpose.isEmpty ? "No purpose specified" : purpose,
    );

    context
        .read<ExpenseCubit>()
        .addExpense(newExpense)
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Expense added successfully")),
          );
          Navigator.pop(context);
        })
        .catchError((e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Failed to add expense: $e")));
        });
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

  @override
  void dispose() {
    _titleController.dispose();
    _purposeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _purposeController,
              decoration: const InputDecoration(
                labelText: "Purpose (Optional)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text("Date: ${_selectedDate.toLocal().toShortDateString()}"),
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
              child: const Text("Add Expense"),
            ),
          ],
        ),
      ),
    );
  }
}
