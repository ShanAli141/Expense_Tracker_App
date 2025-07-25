// ignore_for_file: avoid_types_as_parameter_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/Bloc/budget_cubit.dart';
import 'package:first_project/Bloc/expense_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageExpense extends StatefulWidget {
  const ManageExpense({super.key, required String title});

  @override
  State<ManageExpense> createState() => _ManageExpenseState();
}

class _ManageExpenseState extends State<ManageExpense>
    with SingleTickerProviderStateMixin {
  final TextEditingController _budgetController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    try {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
      _animationController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = 'Initialization error: $e';
      });
    }
  }

  @override
  void dispose() {
    try {
      _animationController.dispose();
      _budgetController.dispose();
    } catch (e) {
      print('Dispose error: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: use Theme.of(context).scaffoldBackgroundColor
      body: Container(
        // Use Theme.of(context).canvasColor or similar for default compatibility
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 14,
                      ),
                    ),
                  ),
                Text(
                  "Set Monthly Budget",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    // Use Theme.of(context).textTheme.titleLarge.color
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _budgetController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter monthly budget",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedScaleButton(
                      onPressed: () async {
                        try {
                          final value = double.tryParse(_budgetController.text);
                          if (value == null || value <= 0) {
                            setState(() {
                              _errorMessage =
                                  'Please enter a valid positive number';
                            });
                            return;
                          }
                          context.read<BudgetCubit>().updateBudget(value);
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .set({
                                  'monthlyBudget': value,
                                }, SetOptions(merge: true));
                            setState(() {
                              _errorMessage = '';
                            });
                            _animationController.forward(from: 0);
                          } else {
                            setState(() {
                              _errorMessage = 'User not logged in';
                            });
                          }
                        } catch (e) {
                          setState(() {
                            _errorMessage = 'Error updating budget: $e';
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                BlocBuilder<BudgetCubit, double>(
                  builder: (context, budget) {
                    return BlocBuilder<ExpenseCubit, ExpenseState>(
                      builder: (context, state) {
                        double spent = 0;
                        try {
                          if (state is ExpenseLoaded) {
                            spent = state.expenses.fold(
                              0.0,
                              (sum, e) => sum + (e.amount),
                            );
                          }
                        } catch (e) {
                          setState(() {
                            _errorMessage = 'Error calculating expenses: $e';
                          });
                        }
                        final remaining = budget - spent;
                        final progress = budget > 0
                            ? (spent / budget).clamp(0.0, 1.0)
                            : 0.0;

                        return Container(
                          padding: const EdgeInsets.all(16),
                          // decoration: BoxDecoration(
                          //   // Use Theme.of(context).cardColor
                          //   borderRadius: BorderRadius.circular(16),
                          //   boxShadow: [
                          //     BoxShadow(
                          //       // Use Theme.of(context).shadowColor
                          //       offset: const Offset(4, 4),
                          //       blurRadius: 10,
                          //       spreadRadius: 1,
                          //     ),
                          //     BoxShadow(
                          //       // Use Theme.of(context).shadowColor
                          //       offset: const Offset(-4, -4),
                          //       blurRadius: 10,
                          //       spreadRadius: 1,
                          //     ),
                          //   ],
                          // ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Monthly Budget: PKR ${budget.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  // Use Theme.of(context).colorScheme.primary
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Used: PKR ${spent.toStringAsFixed(0)}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Remaining: PKR ${remaining < 0 ? 0 : remaining.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  // Use Theme.of(context).colorScheme.primary
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value: progress,
                                minHeight: 12,
                                // Use Theme.of(context).colorScheme.background
                                // Use Theme.of(context).colorScheme.primary
                                borderRadius: BorderRadius.circular(6),
                              ),
                              if (progress >= 1)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    "⚠ Budget Exceeded!",
                                    style: TextStyle(
                                      // Use Theme.of(context).colorScheme.error
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedScaleButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedScaleButton({super.key, required this.onPressed});

  @override
  State<AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _buttonController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    try {
      _buttonController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      );
      _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
      );
    } catch (e) {
      print('Button initialization error: $e');
    }
  }

  @override
  void dispose() {
    try {
      _buttonController.dispose();
    } catch (e) {
      print('Button dispose error: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: ElevatedButton(
            onPressed: () {
              try {
                _buttonController.forward().then(
                  (_) => _buttonController.reverse(),
                );
                widget.onPressed();
              } catch (e) {
                print('Button press error: $e');
              }
            },
            style: ElevatedButton.styleFrom(
              // Use Theme.of(context).colorScheme.primary
              // Use Theme.of(context).colorScheme.onPrimary
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              // Use Theme.of(context).colorScheme.primaryVariant
            ),
            child: const Text(
              "Set",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
