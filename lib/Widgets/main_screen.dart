import 'package:first_project/Bloc/expense_cubit.dart';
import 'package:first_project/Hive%20Model/expense.dart';
import 'package:first_project/Notification%20System/work_manager.dart';
import 'package:first_project/Widgets/edit_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _taskScheduled = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExpenseLoaded) {
          if (!_taskScheduled) {
            _taskScheduled = true;

            final String? userId = FirebaseAuth.instance.currentUser?.uid;
            if (userId != null) {
              Workmanager().registerOneOffTask(
                WorkmanagerService.taskName,
                WorkmanagerService.taskName,
                inputData: {'uid': userId},
              );
            } else {
              debugPrint(
                "User not signed in - cannot register background task.",
              );
            }
          }

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Expenses: \$${state.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: state.expenses.isEmpty
                      ? const Center(child: Text('No expenses found.'))
                      : ListView.builder(
                          itemCount: state.expenses.length,
                          itemBuilder: (context, index) {
                            final expense = state.expenses[index];
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  title: Text(
                                    expense.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${expense.date.toLocal().toString().split(" ")[0]} • ${expense.purpose}',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '\$${expense.amount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () async {
                                          await context
                                              .read<ExpenseCubit>()
                                              .deleteExpense(index);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text("Expense deleted"),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    final updated = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ExpenseEditScreen(
                                          index: index,
                                          expense: expense,
                                        ),
                                      ),
                                    );
                                    if (updated != null && updated is Expense) {
                                      context.read<ExpenseCubit>().editExpense(
                                        index,
                                        updated,
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        } else if (state is ExpenseError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('Initialize expenses...'));
      },
    );
  }
}
