import 'package:first_project/Bloc/budget_cubit.dart';
import 'package:first_project/Bloc/expense_cubit.dart';
import 'package:first_project/Bloc/theme_cubit.dart';
import 'package:first_project/Hive Model/budget_model.dart';
import 'package:first_project/Hive Model/expense.dart';
import 'package:first_project/Notification System/budget_notifier_wrapper.dart';
import 'package:first_project/Notification System/notification_system.dart';
import 'package:first_project/Notification System/work_manager.dart';
import 'package:first_project/Screens/Auth/Login_Screen.dart';
import 'package:first_project/Screens/splash_screen.dart';
import 'package:first_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

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
  final settingsBox = await Hive.openBox('settings');
  final languageCode = settingsBox.get('languageCode') as String?;
  Locale? savedLocale;
  if (languageCode != null) {
    savedLocale = Locale(languageCode);
  }
  runApp(MyApp(expenseBox: expenseBox, savedLocale: savedLocale));
}

class MyApp extends StatefulWidget {
  final Box<Expense> expenseBox;
  final Locale? savedLocale;

  const MyApp({super.key, required this.expenseBox, this.savedLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  @override
  void initState() {
    super.initState();
    _locale = widget.savedLocale ?? const Locale('en');
  }

  void _setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    final settingsBox = Hive.box('settings');
    await settingsBox.put('languageCode', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ExpenseCubit(widget.expenseBox)..loadExpenses(),
        ),
        BlocProvider(create: (_) => BudgetCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return MaterialApp(
                locale: _locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                debugShowCheckedModeBanner: false,
                theme: ThemeData.light(), // Light theme
                darkTheme: ThemeData.dark(), // Dark theme
                themeMode: context.watch<ThemeCubit>().state,
                // Uses Bloc state
                home: _handleAuth(snapshot),
              );
            },
          );
        },
      ),
    );
  }

  Widget _handleAuth(AsyncSnapshot<User?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SplashScreen();
    } else if (snapshot.hasData) {
      return const BudgetNotifierWrapper();
    } else {
      return LoginScreen(setLocale: _setLocale);
    }
  }
}
