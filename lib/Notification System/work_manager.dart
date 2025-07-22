import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'budget_checker.dart';
import 'notification_system.dart' show NotificationHelper;

class WorkmanagerService {
  static const taskName = "checkBudgetUsage";

  static void initialize() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      await Firebase.initializeApp();
      await NotificationHelper.initialize();

      final uid = inputData?['uid'];
      if (uid != null) {
        await checkBudgetAndNotify(uid);
      }

      return Future.value(true);
    });
  }
}
