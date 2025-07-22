import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 1)
class BudgetModel extends HiveObject {
  @HiveField(0)
  double monthlyBudget;

  BudgetModel({required this.monthlyBudget});
}
