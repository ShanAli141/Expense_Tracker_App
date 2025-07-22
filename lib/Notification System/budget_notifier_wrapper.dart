import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/Notification%20System/budget_checker.dart';
import 'package:first_project/Screens/expense_home.dart';
import 'package:flutter/material.dart';

class BudgetNotifierWrapper extends StatefulWidget {
  const BudgetNotifierWrapper({super.key});

  @override
  State<BudgetNotifierWrapper> createState() => _BudgetNotifierWrapperState();
}

class _BudgetNotifierWrapperState extends State<BudgetNotifierWrapper> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Future.microtask(() async {
        await checkBudgetAndNotify(user.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const ExpenseHome();
  }
}
