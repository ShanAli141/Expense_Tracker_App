import 'package:flutter/material.dart';

class CreditInfoTile extends StatelessWidget {
  const CreditInfoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(
        Icons.account_balance_wallet,
        color: Color.fromARGB(255, 228, 165, 72),
      ),
      title: Text('AVAILABLE CREDIT'),
      subtitle: Text(
        '0.00\nyou can redeem your credit while sending payments.',
      ),
      tileColor: Color.fromARGB(104, 148, 136, 136),
    );
  }
}
