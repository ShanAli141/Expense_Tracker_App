import 'package:first_project/Screens/Sumsub%20Verification/sumsub_web_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String? _accessToken;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startVerification();
  }

  Future<void> _startVerification() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Replace the below URL with your actual local or hosted backend server
      final response = await http.post(
        Uri.parse(
          'http://10.0.2.2:3000/api/sumsub/token',
        ), // Updated for local Android emulator
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'externalUserId': 'user123', // Replace with real user ID if needed
          'levelName': 'basic-kyc-level',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _accessToken = data['token']; // Extract token from response
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to get token. Status Code: ${response.statusCode}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error occurred: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Document Verification",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : _error != null
            ? Text(_error!, style: TextStyle(color: Colors.red))
            : _accessToken != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Access Token retrieved:"),
                  SelectableText(
                    _accessToken!,
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SumsubWebview(
                            token: 'test_shan Ali',
                          ), // Pass actual token
                        ),
                      );
                    },
                    child: Text("Start Verification"),
                  ),
                ],
              )
            : Text("No token available"),
      ),
    );
  }
}
