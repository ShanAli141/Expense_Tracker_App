// ignore_for_file: avoid_print

import 'package:first_project/Hive%20Model/hive_expense_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Expense States
abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;
  final double total;

  ExpenseLoaded(this.expenses)
    : total = expenses.fold(0, (sum, item) => sum + item.amount);
}

class ExpenseError extends ExpenseState {
  final String message;
  ExpenseError(this.message);
}

// Expense Cubit
class ExpenseCubit extends Cubit<ExpenseState> {
  final Box<Expense> _expenseBox;

  ExpenseCubit(this._expenseBox) : super(ExpenseInitial()) {
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    try {
      emit(ExpenseLoading());
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(ExpenseError("User not logged in"));
        return;
      }

      // Fetch from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .get();

      final expenses = snapshot.docs.map((doc) {
        final data = doc.data();
        return Expense(
          title: data['title'] as String,
          purpose: data['purpose'] as String,
          amount: (data['amount'] as num).toDouble(),
          date: DateTime.parse(data['date'] as String),
        );
      }).toList();

      // Sync with Hive
      await _expenseBox.clear();
      for (var expense in expenses) {
        await _expenseBox.add(expense);
      }

      emit(ExpenseLoaded(expenses));
    } catch (e) {
      emit(ExpenseError("Failed to load expenses: $e"));
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user logged in");
        emit(ExpenseError("User not logged in"));
        return;
      }
      print("Adding expense for user: ${user.uid}");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .add({
            'title': expense.title,
            'purpose': expense.purpose,
            'amount': expense.amount,
            'date': expense.date.toIso8601String(),
          });
      print("Expense added to Firestore");
      await _expenseBox.add(expense);
      print("Expense added to Hive");
      loadExpenses();
    } catch (e) {
      print("Add expense error: $e");
      emit(ExpenseError("Failed to add expense: $e"));
    }
  }

  Future<void> deleteExpense(int index) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(ExpenseError("User not logged in"));
        return;
      }

      // Delete from Hive
      final expense = _expenseBox.getAt(index);
      await _expenseBox.deleteAt(index);
      print("Writing to Firestore...");

      // Delete from Firestore
      if (expense != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('expenses')
            .where('title', isEqualTo: expense.title)
            .where('amount', isEqualTo: expense.amount)
            .where('date', isEqualTo: expense.date.toIso8601String())
            .get();
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }
      print("Successfully written to Firestore!");

      loadExpenses();
    } catch (e) {
      emit(ExpenseError("Failed to delete expense: $e"));
    }
  } //

  Future<void> editExpense(int index, Expense updatedExpense) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(ExpenseError("User not logged in"));
        return;
      }

      // Update in Hive
      final oldExpense = _expenseBox.getAt(index);
      await _expenseBox.putAt(index, updatedExpense);

      // Update in Firestore
      if (oldExpense != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('expenses')
            .where('title', isEqualTo: oldExpense.title)
            .where('amount', isEqualTo: oldExpense.amount)
            .where('date', isEqualTo: oldExpense.date.toIso8601String())
            .get();
        for (var doc in snapshot.docs) {
          await doc.reference.update({
            'title': updatedExpense.title,
            'purpose': updatedExpense.purpose,
            'amount': updatedExpense.amount,
            'date': updatedExpense.date.toIso8601String(),
          });
        }
      }

      loadExpenses();
    } catch (e) {
      emit(ExpenseError("Failed to edit expense: $e"));
    }
  }

  Future<void> clearAll() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(ExpenseError("User not logged in"));
        return;
      }

      // Clear Hive
      await _expenseBox.clear();

      // Clear Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      loadExpenses();
    } catch (e) {
      emit(ExpenseError("Failed to clear expenses: $e"));
    }
  }

  void filterExpenses(bool Function(Expense) test) {
    try {
      final filtered = _expenseBox.values.where(test).toList();
      emit(ExpenseLoaded(filtered));
    } catch (e) {
      emit(ExpenseError("Failed to filter expenses: $e"));
    }
  }

  double getTotalAmount() {
    if (state is ExpenseLoaded) {
      return (state as ExpenseLoaded).total;
    }
    return 0;
  }
}
