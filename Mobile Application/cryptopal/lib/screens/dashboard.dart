import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/user_account.dart';

class dashboard extends StatefulWidget {
  const dashboard(this.currentUser, {Key? key}) : super(key: key);
  static const String id='dashboard';
  final UserAccount currentUser;

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAccentColor1,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: logoAppBar(context),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          /*child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Crypto"),
          ),*/
        ),
      ),
    );
  }
}
