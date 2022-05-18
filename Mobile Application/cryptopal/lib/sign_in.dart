import 'package:flutter/material.dart';
import 'constants.dart';

class sign_in extends StatelessWidget {
  const sign_in({Key? key}) : super(key: key);

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
                CircleAvatar(
                  backgroundColor: kAccentColor1,
                  radius: 50.0,
                  child: Image.asset('assets/images/CryptoPal-logo-black.png'),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const SizedBox(
                  height: 50.0,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'CryptoPal',
                      style: kTitleStyle,
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
                      'Sign in',
                      style: kSubjectStyle,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    //controller: _emailController,
                    style: kInstructionStyle,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter email',
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: InputBorder.none,
                      fillColor: kTransparentColor,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    //controller: _passwordController,
                    style: kInstructionStyle,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      /*suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off_outlined)),*/
                      hintText: 'Enter password',
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: InputBorder.none,
                      fillColor: kTransparentColor,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          SizedBox(
                              height: 15.0,
                              width: 24.0,
                              child: Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: kAccentColor2,
                                ),
                                child: Checkbox(
                                    activeColor: kAccentColor2,
                                    value: false,
                                    //value: _isChecked,
                                    onChanged: (bool? value) {
                                      // _handleRememberMe(value!);
                                    }),
                              )),
                          const SizedBox(
                              width: 5.0
                          ),
                          const Text(
                            "Remember Me",
                            style: kInstructionStyle,
                          ),
                        ],
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: kInstructionStyle,
                        ),
                        onPressed: () {},
                        child: const Text('Forgot Password'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: MaterialButton(
                    color: kAccentColor2,
                    height:40.0,
                    minWidth: double.infinity,
                    onPressed: () {},
                    child: const Text(
                      'Sign in',
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
                        'Don\'t have an account?',
                        style: kInstructionStyle,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: kInstructionStyle,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign_up');
                        },
                        child: const Text('Sign up'),
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