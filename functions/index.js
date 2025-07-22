const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.budgetNotification = functions.firestore
  .document('users/{userId}/expenses/{expenseId}')
  .onWrite(async (change, context) => {
    const { userId } = context.params;
    const userRef = admin.firestore().collection('users').doc(userId);
    const userSnap = await userRef.get();
    const userData = userSnap.data();

    const totalExpenses = await userRef.collection('expenses').get();
    let total = 0;
    totalExpenses.forEach(doc => total += doc.data().amount || 0);

    if (userData.budget && total >= 0.8 * userData.budget) {
      await admin.messaging().sendToTopic(userId, {
        notification: {
          title: 'Budget Alert',
          body: 'You have used 80% of your budget!',
        }
      });
    }
  });
