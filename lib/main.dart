import 'package:first_project/Bloc/budget_cubit.dart';
import 'package:first_project/Bloc/expense_cubit.dart';
import 'package:first_project/Hive%20Model/budget_model.dart';
import 'package:first_project/Hive%20Model/expense.dart';
import 'package:first_project/Notification%20System/budget_notifier_wrapper.dart';
import 'package:first_project/Notification%20System/notification_system.dart';
import 'package:first_project/Notification%20System/work_manager.dart';
import 'package:first_project/Screens/Auth/Login_Screen.dart';
import 'package:first_project/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

//Notification Handler
Future<void> setupPushNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();

  String? token = await messaging.getToken();
  print("FCM Token: $token");

  // Save token to Firestore under the user's document
  final user = FirebaseAuth.instance.currentUser;
  if (user != null && token != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'fcmToken': token,
    });
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message received in foreground: ${message.notification?.title}');
  });
}

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationHelper.initialize();
  await requestNotificationPermission();
  WorkmanagerService.initialize();
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(BudgetModelAdapter());

  final expenseBox = await Hive.openBox<Expense>('expenses');
  await Hive.openBox<BudgetModel>('budgetBox');

  runApp(MyApp(expenseBox: expenseBox));
  // NotificationHelper.showNotification(
  //   "Test Notification",
  //   "This is a test alert from foreground.",
  // );
}

class MyApp extends StatelessWidget {
  final Box<Expense> expenseBox;

  const MyApp({super.key, required this.expenseBox});

  @override
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ExpenseCubit(expenseBox)..loadExpenses()),
        BlocProvider(create: (_) => BudgetCubit()),
      ],
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
      return const BudgetNotifierWrapper(); // <-- updated here
    } else {
      return LoginScreen(); // Not logged in
    }
  }
}
