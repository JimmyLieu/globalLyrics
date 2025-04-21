import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globallyrics/assets/images.dart';
import 'package:globallyrics/assets/vectors.dart';
import 'package:globallyrics/screens/signup_or_signin.dart';
import 'package:globallyrics/widgets/basic_app_button.dart';


class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image Container
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AppImages.introBG),
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.15),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Column(
              children: [
                // Logo
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(AppVectors.logo),
                ),
                const Spacer(),
                const Text(
                  'Changing The Game',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 21),
                const Text(
                  'A new innovative way to listen to music',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xffBEBEBE),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                
                // BasicAppButton 
                BasicAppButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const SignupOrSignin()
                        )
                     );
                    },
                    title: 'Get Started'
                  )
              ],
                ),
          ),
              ],
            ),
          );
  }
}