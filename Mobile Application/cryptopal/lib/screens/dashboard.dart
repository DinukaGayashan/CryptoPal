import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
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
      body: LiquidPullToRefresh(
        backgroundColor: kAccentColor1,
        color: kTransparentColor,
        onRefresh: () async {
          Navigator.pushNamedAndRemoveUntil(context, dashboard_loading.id, (route) => false);
          //Navigator.pushReplacementNamed(context, dashboard_loading.id);
          //Navigator.popAndPushNamed(context, dashboard_loading.id);
          //Navigator.pushNamed(context, dashboard_loading.id);
          //currentUser=await getActiveUserData();
          //Navigator.popUntil(context,(route)=> route.settings.name==dashboard_loading.id);
          //Navigator.pop(context);
        },
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                color: kTransparentColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Predictions',
                        style: kButtonTextStyle,
                      ),
                      Text(
                        'Accuracy: '+(100-currentUser.error).roundToDouble().toString(),
                        style: kButtonTextStyle,
                      ),
                      SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: LiquidCircularProgressIndicator(
                          value: (100-currentUser.error)/100.roundToDouble(),
                          valueColor: const AlwaysStoppedAnimation(Colors.green),
                          backgroundColor: Colors.white,
                          borderColor: Colors.red,
                          borderWidth: 0.0,
                          direction: Axis.vertical,
                          center: CircleAvatar(
                            radius: 25.0,
                            child: Image.asset('assets/images/CryptoPal-logo-black.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                        width: 300.0,
                        child: LiquidLinearProgressIndicator(
                          value: (100-currentUser.error)/100.roundToDouble(),
                          valueColor: const AlwaysStoppedAnimation(kAccentColor2), // Defaults to the current Theme's accentColor.
                          backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                          borderColor: Colors.red,
                          borderWidth: 0.0,
                          direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                          center: const Text("Accuracy"),
                        ),
                      ),
                      SizedBox(
                          child: SfRadialGauge(
                              title: const GaugeTitle(
                                  text: 'Speedometer',
                                  textStyle:
                                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                              axes: <RadialAxis>[
                                RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
                                  GaugeRange(
                                      startValue: 0,
                                      endValue: 50,
                                      color: Colors.green,
                                      startWidth: 10,
                                      endWidth: 10),
                                  GaugeRange(
                                      startValue: 50,
                                      endValue: 100,
                                      color: Colors.orange,
                                      startWidth: 10,
                                      endWidth: 10),
                                  GaugeRange(
                                      startValue: 100,
                                      endValue: 150,
                                      color: Colors.red,
                                      startWidth: 10,
                                      endWidth: 10)
                                ], pointers: const <GaugePointer>[
                                  NeedlePointer(value: 90)
                                ], annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Container(
                                          child: const Text('90.0',
                                              style: TextStyle(
                                                  fontSize: 25, fontWeight: FontWeight.bold))),
                                      angle: 90,
                                      positionFactor: 0.5)
                                ])
                              ])
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              color: Colors.amber[600],
              child: const Center(child: Text('Entry A')),
            ),
          ],
        ),
      ),
    );
  }
}
