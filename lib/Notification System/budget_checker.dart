import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/Notification%20System/notification_system.dart';

Future<void> checkBudgetAndNotify(String uid) async {
  try {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await userDocRef.get();

    if (!snapshot.exists || !snapshot.data()!.containsKey('monthlyBudget')) {
      print("User document or monthlyBudget not found.");
      return;
    }

    final double monthlyBudget = (snapshot['monthlyBudget'] as num).toDouble();
    String? lastStatus = snapshot.data()!['lastBudgetStatus'];

    final expensesSnapshot = await userDocRef.collection('expenses').get();
    double totalSpent = 0;
    for (var doc in expensesSnapshot.docs) {
      if (doc.data().containsKey('amount')) {
        totalSpent += (doc['amount'] as num).toDouble();
      }
    }

    final double spentPercentage = (totalSpent / monthlyBudget) * 100;

    if (spentPercentage >= 100) {
      if (lastStatus != 'exceeded') {
        await NotificationHelper.showNotification(
          'Budget Exceeded',
          'You have exceeded your budget limit!',
        );
        lastStatus = 'exceeded';
      }
    } else if (spentPercentage >= 80) {
      if (lastStatus != 'warning') {
        await NotificationHelper.showNotification(
          'Budget Alert',
          'You’ve used ${spentPercentage.toStringAsFixed(1)}% of your budget.',
        );
        lastStatus = 'warning';
      }
    } else {
      if (lastStatus != 'under') {
        lastStatus = 'under';
      }
    }

    // Always update the latest status
    await userDocRef.update({'lastBudgetStatus': lastStatus});
  } catch (e) {
    print("Error in budget notification: $e");
  }
}
