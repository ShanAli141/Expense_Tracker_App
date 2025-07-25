// ignore_for_file: unnecessary_string_escapes, unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/Bloc/expense_cubit.dart';
import 'package:first_project/Bloc/theme_cubit.dart';
import 'package:first_project/Screens/Profile/profile_screen.dart';
import 'package:first_project/Screens/manage_expense.dart' show ManageExpense;
import 'package:first_project/Screens/placeholder.dart';
import 'package:first_project/Widgets/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_expense_screen.dart';

class ExpenseHome extends StatefulWidget {
  const ExpenseHome({super.key});

  @override
  State<ExpenseHome> createState() => _ExpenseHomeState();
}

class _ExpenseHomeState extends State<ExpenseHome> {
  int _selectedIndex = 0;
  double budget = 0;
  double totalExpenses = 0;
  // Define bottom nav pages/screens
  final List<Widget> _pages = [
    const MainScreen(),
    const ManageExpense(title: 'Manage'), // Main list screen
    const PlaceholderScreen(title: 'Reports'),
    const ProfileScreen(title: 'Settings'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void toggleAppTheme(BuildContext context) {
    context.read<ThemeCubit>().toggleTheme();
  }

  @override
  void initState() {
    super.initState();
    context.read<ExpenseCubit>().loadExpenses();
    checkBudgetUsage();
    // Load from Hive
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 60),
          child: Text(
            "Expense Tracker",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 228, 165, 72),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Icon(
              context.watch<ThemeCubit>().state == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () => toggleAppTheme(context),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 228, 165, 72),
        unselectedItemColor: const Color.fromARGB(255, 228, 165, 72),
        selectedIconTheme: IconThemeData(size: 30),
        unselectedIconTheme: IconThemeData(size: 24),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_sharp),
            label: 'Manage',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
                );
              },
              child: const Icon(Icons.add),
              backgroundColor: const Color.fromARGB(255, 228, 165, 72),
            )
          : null,
    );
  }

  Future<void> checkBudgetUsage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final double userBudget = (userDoc.data()?['monthlyBudget'] ?? 0)
        .toDouble();

    final expensesSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('expenses')
        .get();

    double total = 0;
    for (var doc in expensesSnap.docs) {
      total += (doc.data()['amount'] ?? 0).toDouble();
    }

    if (mounted) {
      setState(() {
        budget = userBudget;
        totalExpenses = total;
      });
    }
    final double usedPercent = (total / userBudget) * 100;

    if (usedPercent >= 80 && mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Budget Limit Alert"),
          content: Text(
            "You've used ${usedPercent.toStringAsFixed(1)}% of your monthly budget.",
          ),
        ),
      );
    }
  }
}

extension DateFormatter on DateTime {
  String toShortDateString() {
    return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/${year}";
  }
}
