import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globallyrics/assets/images.dart';
import 'package:globallyrics/assets/vectors.dart';
import 'package:globallyrics/screens/main_navigator.dart';
import 'package:globallyrics/screens/signin.dart';
import 'package:globallyrics/widgets/app_bar.dart';
import 'package:globallyrics/widgets/basic_app_button.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _siginText(context),
      appBar: BasicAppbar(
        title: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Image.asset(
            AppImages.logo,
            height: 250,
            width: 250,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _registerText(),
            const SizedBox(height: 50),
            _fullNameField(context),
            const SizedBox(height: 20),
            _emailField(context),
            const SizedBox(height: 20),
            _passwordField(context),
            const SizedBox(height: 20),
            BasicAppButton(
              onPressed: () async {
                // Simulate a fake registration
                await Future.delayed(const Duration(seconds: 1));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account created (mock logic)'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const MainNavigator(),
                  ),
                  (route) => false,
                );
              },
              title: 'Create Account',
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Register',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField(BuildContext context) {
    return TextField(
      controller: _fullName,
      decoration: const InputDecoration(
        hintText: 'Full Name',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: const InputDecoration(
        hintText: 'Enter Email',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      decoration: const InputDecoration(
        hintText: 'Password',
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme,
      ),
    );
  }

  Widget _siginText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Do you have an account? ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SigninPage(),
                ),
              );
            },
            child: const Text('Sign In'),
          )
        ],
      ),
    );
  }
}
