import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:tradelinkedai/core/components/app_button.dart';
import 'package:tradelinkedai/core/components/app_text_field.dart';
import 'package:tradelinkedai/core/components/sb.dart';
import 'package:tradelinkedai/core/constants/app_strings.dart';
import 'package:tradelinkedai/core/extensions/build_context_extension.dart';
import 'package:tradelinkedai/core/providers/auth.dart';
import 'package:tradelinkedai/widget/custom_rich_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await authProvider.login(email, password,"");

      // if (!authProvider.isRegistered) {
      //   // Show an error message if login fails
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(authProvider.registerErrorMsg)),
      //   );
      // }
    }
  }

  void _sigUpScreen() {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    auth.handleState(Status.Registered);
  }

  void _googleSignIn() async {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.signInWithGoogle();
  }

    void _appleSignIn() async {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.signInWithApple();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  AppStrings.welcomeBack,
                  textAlign: TextAlign.center,
                  style: context.headlineMedium?.copyWith(
                    color: context.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SB.h(8),
                Text(
                  AppStrings.loginDescription,
                  textAlign: TextAlign.center,
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SB.h(35),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextField(
                          controller: _emailController,
                          title: AppStrings.email,
                          hintText: AppStrings.enterEmail,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomTextField(
                          controller: _passwordController,
                          title: AppStrings.password,
                          hintText: AppStrings.enterPassword,
                          textInputAction: TextInputAction.done,
                          isPasswordField: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SB.h(15),
                      Consumer<AuthProvider>(
                        builder: (context, auth, child) {
                          if (auth.loggedInStatus == Status.Loading) {
                            return CircularProgressIndicator(); // Show loading indicator
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppButton.primary(
                              title: AppStrings.login,
                              onPressed: _login,
                            ),
                          );
                        },
                      ),
                      Consumer<AuthProvider>(
                        builder: (context, auth, child) {
                          if (auth.loggedInStatus == Status.Failure) {
                            return Text(
                              auth.loginErrorMsg,
                              style: TextStyle(color: Colors.red),
                            );
                          }
                          return Container(); // Return empty container if no error
                        },
                      ),
                    ],
                  ),
                ),
                SB.h(context.height * 0.15),
                CustomRichText(
                  text: AppStrings.notMember,
                  highlightedText: AppStrings.signUp,
                  onTap: () {
                    _sigUpScreen(); // Navigate to Signup page
                  },
                ),
                SB.h(context.height * 0.05),
                Text(
                  AppStrings.orSignupWith,
                  textAlign: TextAlign.center,
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SB.h(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton.borderIcon(
                      onTap: _googleSignIn,
                      icon: Image.asset(
                        "assets/images/logo/google.png",
                        scale: 10,
                      ),
                    ),
                    if (Platform.isIOS) ...[
                      SB.w(15),
                      AppButton.borderIcon(
                        onTap: () async {
                          _appleSignIn();
                        },
                        icon: Image.asset(
                          "assets/images/logo/apple.png",
                          scale: 10,
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
