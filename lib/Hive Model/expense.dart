// File: lib/Model/expense.dart

import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String purpose;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.purpose,
  });
}
