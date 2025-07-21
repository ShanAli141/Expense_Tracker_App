// ignore_for_file: use_build_context_synchronously, file_names, avoid_print

import 'package:first_project/Screens/Auth/Signup_Screen.dart';
import 'package:first_project/Screens/expense_home.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final LocalAuthentication auth = LocalAuthentication();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  Future<void> _authenticate(BuildContext context) async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();
      List<BiometricType> availableBiometrics = await auth
          .getAvailableBiometrics();

      if (!canCheckBiometrics ||
          !isDeviceSupported ||
          availableBiometrics.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No biometric data enrolled on this device'),
          ),
        );
        return;
      }

      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated && context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Authentication failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          120,
        ), // double the default height (~56)
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/images/logo.png", width: 180, height: 180),

            Padding(
              padding: EdgeInsets.all(30),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter your RCL Number and password to access Dashboard',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailcontroller,
                    decoration: const InputDecoration(
                      labelText: 'Enter your Email',
                      hintText: 'agent234@remitchoice.email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Remit@1234',

                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.visibility),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      const Text('Remember me'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: Text("Signup"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.deepPurple, // Custom background color
                      foregroundColor: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // Rounded corners
                      ),
                      elevation: 8, // Shadow
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      try {
                        print("Login button pressed");

                        final email = emailcontroller.text.trim();
                        final password = passwordcontroller.text.trim();

                        print("Attempting sign in with: $email");

                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                        print("Sign in successful");

                        // Now navigate to home screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpenseHome(),
                          ),
                        );
                      } catch (e, stack) {
                        print("Login error: $e");
                        print("Stack trace: $stack");

                        // Optionally show error to user
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Login failed: $e")),
                        );
                      }
                    },

                    child: const Text('Log In'),
                  ),

                  TextButton.icon(
                    onPressed: () => _authenticate(context),
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Login with Fingerprint'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
