import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SumsubWebview extends StatelessWidget {
  final String token;

  const SumsubWebview({required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    final url = 'http://10.0.2.2:5050/sumsub_verification.html?token=$token';

    return Scaffold(
      appBar: AppBar(title: Text('Sumsub Verification')),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
