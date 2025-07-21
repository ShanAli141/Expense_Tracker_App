import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:first_project/main.dart';
import 'package:first_project/Hive Model/hive_expense_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Initialize Hive and register adapter
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(ExpenseAdapter());

    // Open the Hive box
    final expenseBox = await Hive.openBox<Expense>('expenses');

    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(expenseBox: expenseBox));

    // Example test (customize for your real app)
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
