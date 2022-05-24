import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'dashboard.dart';

class dashboard_loading extends StatefulWidget {
  const dashboard_loading({Key? key}) : super(key: key);
  static const String id='dashboard_loading';

  @override
  State<dashboard_loading> createState() => _dashboard_loadingState();
}

class _dashboard_loadingState extends State<dashboard_loading> {

  late UserAccount currentUser=UserAccount();

  void loadUser() async{
    currentUser=await getActiveUserData();

    Navigator.push(context, MaterialPageRoute(builder: (context){
      return dashboard(currentUser);
    }));
  }

  @override
  Widget build(BuildContext context) {
    loadUser();

    return Scaffold(
      backgroundColor: kAccentColor1,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Hero(
                    tag: 'logo',
                    child: CircleAvatar(
                      backgroundColor: kAccentColor1,
                      radius: 100.0,
                      child: Image.asset('assets/images/CryptoPal-logo-black.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                    width: double.infinity,
                    child: Center(
                      child: Hero(
                        tag: 'name',
                        child: Text(
                          'CryptoPal',
                          style: kMainTitleStyle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50.0,
                child: Center(
                  child: Text(
                    'Advisory platform for cryptocurrency investments',
                    style:kInstructionStyle,
                  ),
                ),
              ),
              const SizedBox(
                height: 70.0,
              ),
              const SizedBox(
                width: 50.0,
                height: 50.0,
                child: SpinKitFoldingCube(
                  color: kBaseColor1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
