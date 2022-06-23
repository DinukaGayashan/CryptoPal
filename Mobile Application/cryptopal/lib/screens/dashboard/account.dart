import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';

import 'package:cryptopal/utility/user_account.dart';

class Account extends StatefulWidget {
  const Account(this.currentUser, {Key? key}) : super(key: key);
  final UserAccount currentUser;

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassBackground(
            context,
            ListView(
              children: <Widget>[
                topBar(context, 'Account'),
                const SizedBox(
                  height: 10.0,
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
