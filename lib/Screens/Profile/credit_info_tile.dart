import 'package:flutter/material.dart';

class CreditInfoTile extends StatelessWidget {
  const CreditInfoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(
        Icons.account_balance_wallet,
        color: Color.fromARGB(255, 71, 112, 189),
      ),
      title: Text('AVAILABLE CREDIT', style: TextStyle(color: Colors.black)),
      subtitle: Text(
        '0.00\nyou can redeem your credit while sending payments.',
        style: TextStyle(color: Colors.black54),
      ),
      tileColor: Color(0xFFF5F5F5),
    );
  }
}
