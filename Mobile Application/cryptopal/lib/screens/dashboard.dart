import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:glass/glass.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:cryptopal/utility/user_account.dart';
import 'dashboard_loading.dart';

class dashboard extends StatefulWidget {
  const dashboard(this.currentUser, {Key? key}) : super(key: key);
  static const String id = 'dashboard';
  final UserAccount currentUser;

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kAccentColor1,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90.0),
          child: logoAppBar(context),
        ),
        body: LiquidPullToRefresh(
          backgroundColor: kAccentColor1,
          color: kTransparentColor,
          onRefresh: () async {
            Navigator.pushNamedAndRemoveUntil(
                context, dashboard_loading.id, (route) => false);
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
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Predictions',
                          style: kCardTextStyle,
                        ),
                        /*SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: LiquidCircularProgressIndicator(
                            value: currentUser.accuracy / 100.roundToDouble(),
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.green),
                            backgroundColor: Colors.white,
                            borderColor: Colors.red,
                            borderWidth: 0.0,
                            direction: Axis.vertical,
                            center: CircleAvatar(
                              radius: 25.0,
                              child: Image.asset(
                                  'assets/images/CryptoPal-logo-black.png'),
                            ),
                          ),
                        ),*/
                        SizedBox(
                          height: 200.0,
                          width: 200.0,
                          child: SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 100,
                                showLabels: false,
                                showTicks: false,
                                axisLineStyle: const AxisLineStyle(
                                  thickness: 0.2,
                                  cornerStyle: CornerStyle.bothCurve,
                                  color: kBaseColor1,
                                  thicknessUnit: GaugeSizeUnit.factor,
                                ),
                                pointers: <GaugePointer>[
                                  RangePointer(
                                    animationType: AnimationType.ease,
                                    enableAnimation: true,
                                    animationDuration: kAnimationTime.toDouble(),
                                    value: currentUser.accuracy.roundToDouble(),
                                    cornerStyle: CornerStyle.bothCurve,
                                    width: 0.2,
                                    sizeUnit: GaugeSizeUnit.factor,
                                  ),
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                    positionFactor: 0.1,
                                    angle: 90,
                                    widget: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          currentUser.accuracy
                                                  .round()
                                                  .toString() +
                                              '%',
                                          style: kCardNumberStyle,
                                        ),
                                        const Text(
                                          'Accuracy',
                                          style: kCardTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ).asGlass(
                  tintColor: Colors.white,
                  clipBorderRadius: BorderRadius.circular(40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Errors',
                          style: kCardTextStyle,
                        ),
                        SizedBox(
                          width: 500.0,
                          height: 100.0,
                          child: SfLinearGauge(
                            orientation: LinearGaugeOrientation.vertical,
                            minimum: 0,
                            maximum: 100,
                            showLabels: false,
                            showTicks: false,
//showAxisTrack: false,
                            isMirrored: true,
                            barPointers: [
                              for(int i=currentUser.pastPredictions.length;i>0 && i>currentUser.pastPredictions.length-10;i--)
                                LinearBarPointer(
                                  enableAnimation: true,
                                  animationDuration: kAnimationTime,
//animationType: AnimationType.ease,
                                  value: (currentUser.pastPredictions[i-1].errorPercentage<0?(-currentUser.pastPredictions[i-1].errorPercentage):currentUser.pastPredictions[i-1].errorPercentage)>=100.0?100.0:(currentUser.pastPredictions[i-1].errorPercentage<0?(-currentUser.pastPredictions[i-1].errorPercentage):currentUser.pastPredictions[i-1].errorPercentage),
                                  color: currentUser.pastPredictions[i-1].errorPercentage>0?kGreen:kRed,
                                  edgeStyle: LinearEdgeStyle.bothCurve,
                                  offset: i*10,
                                  position: LinearElementPosition.outside,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ).asGlass(
                  tintColor: Colors.white,
                  clipBorderRadius: BorderRadius.circular(15),
                ),
              ),

              /*SizedBox(
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'Horizon',
                  ),
                  child: AnimatedTextKit(
                      animatedTexts: [
                        RotateAnimatedText('AWESOME'),
                        RotateAnimatedText('OPTIMISTIC'),
                        RotateAnimatedText('DIFFERENT'),
                      ]

                ),
              ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }





}

