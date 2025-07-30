import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/Screens/Auth/Login_Screen.dart';
import 'package:first_project/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordVisible = false;
  String? _sendingCountry;
  String? _receivingCountry;
  String? _dialCode;
  bool _hasReferralCode = false;
  bool _agreesToTerms = false;
  bool _wantsPromotions = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<void> _signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Signup successful!')));

      // Navigator.pushReplacementNamed(context, '/home');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signup failed: ${e.message}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> countries = ['Country 1', 'Country 2', 'Country 3'];
    List<String> dialCodes = ['+1', '+44', '+91'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset("assets/images/logo.png", height: 90, width: 90),
              const SizedBox(height: 20),

              // First Name and Last Name
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        prefixIcon: Icon(Icons.person, color: Colors.grey),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        prefixIcon: Icon(Icons.person, color: Colors.grey),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Sending Country
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Sending Country',
                  prefixIcon: Icon(Icons.public, color: Colors.grey),
                  border: UnderlineInputBorder(),
                ),
                value: _sendingCountry,
                items: countries
                    .map(
                      (country) => DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _sendingCountry = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Receiving Country
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Receiving Country',
                  prefixIcon: Icon(Icons.public, color: Colors.grey),
                  border: UnderlineInputBorder(),
                ),
                value: _receivingCountry,
                items: countries
                    .map(
                      (country) => DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _receivingCountry = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  border: const UnderlineInputBorder(),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Show',
                          style: TextStyle(color: Colors.orange),
                        ),
                        Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Phone Number
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Dial Code',
                        prefixIcon: Icon(Icons.phone, color: Colors.grey),
                        border: UnderlineInputBorder(),
                      ),
                      value: _dialCode,
                      items: dialCodes
                          .map(
                            (code) => DropdownMenuItem(
                              value: code,
                              child: Text(code),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _dialCode = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Enter Number',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Checkboxes
              Row(
                children: [
                  Checkbox(
                    value: _hasReferralCode,
                    onChanged: (value) {
                      setState(() {
                        _hasReferralCode = value!;
                      });
                    },
                  ),
                  const Text('Do you have Referral Code?'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _agreesToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreesToTerms = value!;
                      });
                    },
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'By clicking create Account agreeing to our ',
                        //style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Terms and Conditions & Privacy Policy',
                            style: const TextStyle(color: Colors.orange),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Add link action here
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Create Account Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _signUp();
                    // Add signup action here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text(
                    'CREATE ACCOUNT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Promotional Consent
              Row(
                children: [
                  Checkbox(
                    value: _wantsPromotions,
                    onChanged: (value) {
                      setState(() {
                        _wantsPromotions = value!;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Remit choice may contact you regarding special promotions that we often run for our customer, including FX rate promotions, feel discounts and prize draws. If you don’t wish to receive message please uncheck check box.',
                      //style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Login Link
              RichText(
                text: TextSpan(
                  text: 'ALREADY HAVE AN ACCOUNT ? ',
                  //style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Login',
                      style: const TextStyle(
                        color: Colors.orange,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
