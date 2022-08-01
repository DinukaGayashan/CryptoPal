import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:glass/glass.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cryptopal_web/constants.dart';
import 'package:cryptopal_web/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenshots = [];

    for (int i = 0; i < 16; i++) {
      screenshots.add(Image.asset('assets/images/screenshots/ss ($i).jpg'));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 70),
        child: AppBar(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 25.0,
                  child: Image.asset('assets/images/CryptoPal-logo-white.png'),
                ),
                const DefaultTextStyle(
                  style: kTitleStyle,
                  child: Text(
                    'CryptoPal',
                  ),
                ),
                const DefaultTextStyle(
                  style: kTransparentSmallStyle,
                  child: Text(
                    ' web',
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          backgroundColor: Colors.transparent,
        ).asGlass(
          tintColor: kBaseColor1,
          frosted: false,
        ),
      ),
      body: background(
        context,
        ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 70,
              color: kTransparentColor7,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                      child: DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: kCardSmallTextStyle,
                        child: AnimatedTextKit(
                          pause: const Duration(milliseconds: 50),
                          repeatForever: true,
                          animatedTexts: [
                            RotateAnimatedText(
                                'Update on cryptocurrency market'),
                            RotateAnimatedText(
                                'Practise cryptocurrency price prediction'),
                            RotateAnimatedText(
                                'Experience the cryptocurrency price variation'),
                            RotateAnimatedText('Customize your experience'),
                            RotateAnimatedText(
                                'Share your status to the world'),
                            RotateAnimatedText(
                                'Enjoy cryptocurrency investing'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 250,
                      child: Image.asset(
                          'assets/images/screenshots/colors/color (${Random().nextInt(16)}).png'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Advisory platform for cryptocurrency investments\n',
                      style: kCardTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ).asGlass(
              frosted: false,
              tintColor: kBaseColor1,
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 5,
                    vertical: 20),
                child: Column(
                  children: [
                    const Text(
                      'Features',
                      style: kCardTextStyle3,
                    ),
                    const Text(
                      'This application helps you to get an idea about your price prediction capability, '
                      'provides forecast prices by machine learning and news related to cryptocurrencies.',
                      style: kCardSmallTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.attach_money,
                          size: 50,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: RichText(
                            text: const TextSpan(
                                text: 'Market',
                                style: kCardTextStyle,
                                children: [
                                  TextSpan(
                                    text:
                                        '\nMarket prices of the currencies user has chosen are available from the starting day of particular cryptocurrency trading.',
                                    style: kTransparentStyle,
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: RichText(
                            textAlign: TextAlign.right,
                            text: const TextSpan(
                                text: 'News',
                                style: kCardTextStyle,
                                children: [
                                  TextSpan(
                                    text:
                                        '\nNews related to cryptocurrencies are available from different news providers and they can be viewed within the app itself.',
                                    style: kTransparentStyle,
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.newspaper,
                          size: 50,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.auto_graph,
                          size: 50,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: RichText(
                            text: const TextSpan(
                                text: 'Predictions',
                                style: kCardTextStyle,
                                children: [
                                  TextSpan(
                                    text:
                                        '\nUser can add price predictions for cryptocurrencies and after that prediction date prediction results will be calculated.',
                                    style: kTransparentStyle,
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: RichText(
                            textAlign: TextAlign.right,
                            text: const TextSpan(
                                text: 'Statistics',
                                style: kCardTextStyle,
                                children: [
                                  TextSpan(
                                    text:
                                        '\nPrediction accuracy, error value and deviation will be calculated and with those results for a cryptocurrency and overall user results. '
                                        'Also these historical results will be stored and used to generate meaningful results to understand user capability of price prediction.',
                                    style: kTransparentStyle,
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.equalizer,
                          size: 50,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.next_week,
                          size: 50,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: RichText(
                            text: const TextSpan(
                                text: 'Forecasts',
                                style: kCardTextStyle,
                                children: [
                                  TextSpan(
                                    text:
                                        '\nMachine Learning generated forecast prices of cryptocurrencies and their accuracy levels, probabilities are available.',
                                    style: kTransparentStyle,
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: RichText(
                            textAlign: TextAlign.right,
                            text: const TextSpan(
                                text: 'Share',
                                style: kCardTextStyle,
                                children: [
                                  TextSpan(
                                    text:
                                        '\nCustom user card is available for every user with varying colors according to the level of the user. '
                                        'User level is calculated with the score which is contributed by the overall accuracy and the past predictions user has made.',
                                    style: kTransparentStyle,
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.share,
                          size: 50,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ).asGlass(
              tintColor: kTransparentColor1,
              frosted: false,
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 15,
                    vertical: 20),
                child: Column(
                  children: [
                    const Text(
                      'Screenshots',
                      style: kCardTextStyle3,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 210,
                      child: CarouselSlider.builder(
                        itemCount: screenshots.length,
                        itemBuilder: (context, index, realIndex) {
                          final screenshot = screenshots[index];
                          return buildImage(screenshot, index);
                        },
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height - 250,
                          autoPlay: true,
                          enlargeCenterPage: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).asGlass(
              frosted: false,
              tintColor: kTransparentColor3,
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 15,
                    vertical: 30),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                          text: 'Try using\n',
                          style: kCardSmallTextStyle,
                          children: [
                            TextSpan(
                              text: 'CryptoPal',
                              style: kTitleStyle,
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Available for Android',
                      style: kTransparentStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    downloadButton(),
                    // TextButton(
                    //     onPressed: (){
                    //       Navigator.pushNamed(context, '/ShareApp');
                    //     },
                    //     child: const Text(
                    //       'Share App',
                    //       style: kLinkStyle,
                    //     ),
                    // ),
                  ],
                ),
              ),
            ).asGlass(
              frosted: false,
              tintColor: kTransparentColor6,
            ),
            Container(
              color: kBackgroundColor,
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      const Center(
                        child: Text(
                          'DEVELOPER',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Bierstadt',
                            color: kTransparentColor3,
                            letterSpacing: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: GestureDetector(
                          child: const Text(
                            'Dinuka Gayashan',
                            style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'ReenieBeanie',
                              color: kBaseColor2,
                            ),
                          ),
                          onTap: () async {
                            await launch(
                                'https://dinukagayashan.github.io/_di-Website');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(final screenshot, index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        child: screenshot,
        color: kAccentColor3,
      );
}
