import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/Hive%20Model/budget_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class BudgetCubit extends Cubit<double> {
  BudgetCubit() : super(0) {
    loadLocalBudget(); // renamed method
  }

  void loadLocalBudget() {
    final box = Hive.box<BudgetModel>('budgetBox');
    final budget = box.get('budget')?.monthlyBudget ?? 0;
    emit(budget);
  }

  void updateBudget(double amount) {
    final box = Hive.box<BudgetModel>('budgetBox');
    box.put('budget', BudgetModel(monthlyBudget: amount));
    emit(amount);
  }

  Future<void> loadBudgetFromFirestore(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data()!.containsKey('monthlyBudget')) {
        final budget = doc['monthlyBudget'];
        context.read<BudgetCubit>().updateBudget(budget.toDouble());
      }
    }
  }
}
