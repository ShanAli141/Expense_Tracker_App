import 'package:first_project/Bloc/expense_cubit.dart';
import 'package:first_project/Hive%20Model/hive_expense_model.dart';
import 'package:first_project/Screens/Auth/Login_Screen.dart';
import 'package:first_project/Screens/expense_home.dart';
import 'package:first_project/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(ExpenseAdapter());

  final expenseBox = await Hive.openBox<Expense>('expenses');

  runApp(MyApp(expenseBox: expenseBox));
}

class MyApp extends StatelessWidget {
  final Box<Expense> expenseBox;

  const MyApp({super.key, required this.expenseBox});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpenseCubit(expenseBox)..loadExpenses(),
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: _handleAuth(snapshot),
          );
        },
      ),
    );
  }

  Widget _handleAuth(AsyncSnapshot<User?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SplashScreen(); // Show splash or loading spinner
    } else if (snapshot.hasData) {
      return const ExpenseHome(); // Logged-in user
    } else {
      return LoginScreen(); // Not logged in
    }
  }
}
