import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in.dart';
import 'registration_form.dart';

class sign_up extends StatefulWidget {
  const sign_up({Key? key}) : super(key: key);

  static const String id='sign_up';

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {

  final _auth=FirebaseAuth.instance;
  late String email,password1,password2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAccentColor1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: CircleAvatar(
                    backgroundColor: kAccentColor1,
                    radius: 50.0,
                    child: Image.asset('assets/images/CryptoPal-logo-black.png'),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const SizedBox(
                  height: 50.0,
                  width: double.infinity,
                  child: Center(
                    child: Hero(
                      tag: 'name',
                      child: Text(
                        'CryptoPal',
                        style: kTitleStyle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                const SizedBox(
                  height: 60.0,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Sign up',
                      style: kSubjectStyle,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    style: kInstructionStyle,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Enter email',
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: InputBorder.none,
                      fillColor: kTransparentColor,
                      filled: true,
                    ),
                    onChanged: (value){
                      email=value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    style: kInstructionStyle,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Enter password',
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: InputBorder.none,
                      fillColor: kTransparentColor,
                      filled: true,
                    ),
                    onChanged: (value){
                      password1=value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 9.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    style: kInstructionStyle,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Re-enter password',
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: InputBorder.none,
                      fillColor: kTransparentColor,
                      filled: true,
                    ),
                    onChanged: (value){
                      password2=value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: MaterialButton(
                    color: kAccentColor2,
                    height:40.0,
                    minWidth: double.infinity,
                    onPressed: () async {
                      if(password1.length<6){
                        print("Password must be at least 6 characters long");
                      }
                      else if(password1==password2){
                        try{
                          final newUser=await _auth.createUserWithEmailAndPassword(email: email, password: password1);
                          Navigator.pushNamed(context, registration_form.id);
                        }
                        catch(e){
                          print(e);
                        }
                      }
                      else{
                        print("Not similar passwords");
                      }
                    },
                    child: const Text(
                      'Sign up',
                      style: kButtonTextStyle,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Already have an account?',
                        style: kInstructionStyle,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: kInstructionStyle,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, sign_in.id);
                        },
                        child: const Text('Sign in'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
