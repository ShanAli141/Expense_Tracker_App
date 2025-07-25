// ignore_for_file: use_build_context_synchronously, file_names, avoid_print, unused_local_variable

import 'package:first_project/Bloc/theme_cubit.dart';
import 'package:first_project/Screens/Auth/Signup_Screen.dart';
import 'package:first_project/Screens/expense_home.dart';
import 'package:first_project/l10n/app_localizations.dart'
    show AppLocalizations;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final void Function(Locale)? setLocale;
  const LoginScreen({super.key, this.setLocale});

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
  bool _isObscure = true; // State for password visibility
  bool _rememberMe = false; // State for remember me checkbox

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

  void toggleAppTheme(BuildContext context) {
    context.read<ThemeCubit>().toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Icon(
              context.watch<ThemeCubit>().state == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => toggleAppTheme(context),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.language,
                  size: 30,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () async {
                  final selected = await showDialog<Locale>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text(AppLocalizations.of(context)!.selectLanguage),
                      children: [
                        RadioListTile<Locale>(
                          title: const Text('English'),
                          value: const Locale('en'),
                          groupValue: Localizations.localeOf(context),
                          onChanged: (Locale? value) =>
                              Navigator.pop(context, value),
                        ),
                        RadioListTile<Locale>(
                          title: const Text('اردو'),
                          value: const Locale('ur'),
                          groupValue: Localizations.localeOf(context),
                          onChanged: (Locale? value) =>
                              Navigator.pop(context, value),
                        ),
                        RadioListTile<Locale>(
                          title: const Text('French'),
                          value: const Locale('fr'),
                          groupValue: Localizations.localeOf(context),
                          onChanged: (Locale? value) =>
                              Navigator.pop(context, value),
                        ),
                      ],
                    ),
                  );
                  if (selected != null) {
                    widget.setLocale?.call(selected);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(
                context,
              ).colorScheme.primary, // Match app's primary gradient
              Theme.of(
                context,
              ).colorScheme.background, // Match app's background
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 0),
                ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 180,
                    height: 180,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.error,
                      size: 180,
                      color: Theme.of(context).colorScheme.error,
                    ),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        Text(
                          AppLocalizations.of(context)!.signin,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Enter your RCL Number and password to access Dashboard',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
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
                          obscureText: _isObscure,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                ),
                                Text(AppLocalizations.of(context)!.rememberMe),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                try {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen(),
                                    ),
                                  );
                                } catch (e) {
                                  setState(() {
                                    _errorMessage = 'Navigation error: $e';
                                  });
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)!.signUp,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        AnimatedScaleButton(
                          text: AppLocalizations.of(context)!.logIn,
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            offset: const Offset(4, 4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            offset: const Offset(-4, -4),
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
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              shadowColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
}
