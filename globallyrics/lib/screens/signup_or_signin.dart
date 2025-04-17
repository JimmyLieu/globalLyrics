import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:globallyrics/assets/vectors.dart';
import 'package:globallyrics/screens/signup.dart';
import 'package:globallyrics/widgets/basic_app_button.dart';

class SignupOrSignin extends StatelessWidget {
  const SignupOrSignin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppVectors.logo
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  const Text(
                    'Enjoy Listinening To Music',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  const Text(
                    'Global Lyrics is doing it like no other',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color:Color(0xffBEBEBE)
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
              
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: BasicAppButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                               MaterialPageRoute(
                                builder: (BuildContext context)=> SignupPage()
                               )
                              );
                          }, 
                          title: 'Register'
                          ),
              ),
             const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: (){},
                  child: Text(
                    'Sign In',
                    style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xffBEBEBE)
                    ),
                  ),
                ),
              )
             ],
            )
                ],
              ),
            )
          ),
        ]
      )
    );
  }
}