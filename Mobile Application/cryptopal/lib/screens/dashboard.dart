import 'package:flutter/material.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'dashboard_loading.dart';

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
      body: RefreshIndicator(
        onRefresh: () async {
          Navigator.pushNamed(context, dashboard_loading.id);
        },
        child: ListView(
          children: <Widget>[
            Container(
              height: 50,
              color: Colors.amber[600],
              child: const Center(child: Text('Entry A')),
            ),
            Container(
              height: 50,
              color: Colors.amber[500],
              child: const Center(child: Text('Entry B')),
            ),
            Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry C')),
            ),
          ],
        ),
          /*const SafeArea(
          child: SingleChildScrollView(
            child: Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              height: 1000.0,
              child: Text("Crypto"),
            ),
          ),
          ),
        ),*/
      ),
    );
  }
}
