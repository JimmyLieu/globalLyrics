import 'package:flutter/material.dart';
import 'package:globallyrics/assets/images.dart';
import 'package:globallyrics/screens/main_navigator.dart';
import 'package:globallyrics/screens/signup.dart';
import 'package:globallyrics/widgets/app_bar.dart';
import 'package:globallyrics/widgets/basic_app_button.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signupText(context),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80), 
                  _registerText(),
                  const SizedBox(height: 40),
                  _emailField(context),
                  const SizedBox(height: 20),
                  _passwordField(context),
                  const SizedBox(height: 20),
                  BasicAppButton(
                    onPressed: () async {
                      await Future.delayed(const Duration(seconds: 1));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Signed in (mock logic)'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const MainNavigator(),
                        ),
                        (route) => false,
                      );
                    },
                    title: 'Sign In',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Sign In',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
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

  Widget _signupText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Not A Member? ',
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
                  builder: (BuildContext context) => SignupPage(),
                ),
              );
            },
            child: const Text('Register Now'),
          )
        ],
      ),
    );
  }
}
