import 'package:cryptopal_web/widgets.dart';
import 'package:flutter/material.dart';
import 'help.dart';
import 'constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: background(context,
          Column(
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 100.0,
                  child: Image.asset('assets/images/CryptoPal-logo-white.png'),
                ),
              ),
              const SizedBox(
                height: 50.0,
                width: double.infinity,
                child: Center(
                  child: Hero(
                    tag: 'name',
                    child: DefaultTextStyle(
                      style: kMainTitleStyle,
                      child: Text(
                        'CryptoPal',
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/ShareApp');
                  },
                  child: Text(
                    'Share App'
                  ),
              ),
            ],
          ),
        ));
  }
}
