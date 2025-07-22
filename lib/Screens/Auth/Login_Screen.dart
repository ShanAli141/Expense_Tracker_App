// ignore_for_file: use_build_context_synchronously, file_names, avoid_print, unused_local_variable

import 'package:first_project/Screens/Auth/Signup_Screen.dart';
import 'package:first_project/Screens/expense_home.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final LocalAuthentication auth = LocalAuthentication();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _logoScaleAnimation;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    try {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      );
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
      _logoScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
      );
      _animationController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = 'Initialization error: $e';
      });
    }
  }

  @override
  void dispose() {
    try {
      _animationController.dispose();
      emailController.dispose();
      passwordController.dispose();
    } catch (e) {
      print('Dispose error: $e');
    }
    super.dispose();
  }

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
            backgroundColor: Colors.red,
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ExpenseHome()),
          );
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Authentication failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              ScaleTransition(
                scale: _logoScaleAnimation,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 180,
                  height: 180,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 180, color: Colors.red),
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Enter your RCL Number and password to access Dashboard',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: emailController,
                        label: 'Enter your Email',
                        hint: 'agent234@remitchoice.email',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: passwordController,
                        label: 'Password',
                        hint: 'Remit@1234',
                        obscureText: true,
                        suffixIcon: const Icon(Icons.visibility),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (value) {},
                                activeColor: Colors.blue,
                              ),
                              const Text('Remember me'),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              try {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              } catch (e) {
                                setState(() {
                                  _errorMessage = 'Navigation error: $e';
                                });
                              }
                            },
                            child: const Text(
                              'Signup',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AnimatedScaleButton(
                        text: 'Log In',
                        onPressed: () async {
                          try {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            if (email.isEmpty || password.isEmpty) {
                              setState(() {
                                _errorMessage =
                                    'Please enter email and password';
                              });
                              return;
                            }
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ExpenseHome(),
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() {
                              _errorMessage = 'Login failed: $e';
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      AnimatedScaleButton(
                        text: 'Login with Fingerprint',
                        icon: const Icon(
                          Icons.fingerprint,
                          color: Colors.white,
                        ),
                        onPressed: () => _authenticate(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(4, 4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey), // visible border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue,
            ), // color when focused
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          suffixIcon: suffixIcon,
          labelStyle: const TextStyle(color: Colors.grey),
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class AnimatedScaleButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Icon? icon;

  const AnimatedScaleButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  State<AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _buttonController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    try {
      _buttonController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      );
      _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
      );
    } catch (e) {
      print('Button initialization error: $e');
    }
  }

  @override
  void dispose() {
    try {
      _buttonController.dispose();
    } catch (e) {
      print('Button dispose error: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: ElevatedButton.icon(
            onPressed: () {
              try {
                _buttonController.forward().then(
                  (_) => _buttonController.reverse(),
                );
                widget.onPressed();
              } catch (e) {
                print('Button press error: $e');
              }
            },
            icon: widget.icon ?? const SizedBox.shrink(),
            label: Text(
              widget.text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              shadowColor: Colors.blueAccent,
            ),
          ),
        );
      },
    );
  }
}
