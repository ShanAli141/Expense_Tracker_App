// ignore_for_file: unnecessary_string_escapes, unnecessary_brace_in_string_interps

import 'package:first_project/Bloc/expense_cubit.dart';
import 'package:first_project/Screens/placeholder.dart';
import 'package:first_project/Screens/profile_screen.dart';
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

  // Define bottom nav pages/screens
  final List<Widget> _pages = [
    const MainScreen(), // Main list screen
    const PlaceholderScreen(title: 'Reports'),
    const ProfileScreen(title: 'Settings'),
  ];
  testing() {
    const ab = "Testing";
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ExpenseCubit>().loadExpenses(); // Load from Hive
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Expense Tracker",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Home'),
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
              backgroundColor: Colors.blue,
            )
          : null,
    );
  }
}

extension DateFormatter on DateTime {
  String toShortDateString() {
    return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/${year}";
  }
}
