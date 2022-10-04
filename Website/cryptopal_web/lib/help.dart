import 'package:flutter/material.dart';
import 'package:cryptopal_web/constants.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  List<bool> isOpen = List.filled(7, false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTransparentColor8,
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          elevation: 0,
          animationDuration: const Duration(milliseconds: 500),
          children: [
            ExpansionPanel(
              backgroundColor: kTransparentColor8,
              canTapOnHeader: true,
              headerBuilder: (context, val) {
                return const Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 10),
                  child: Text(
                    'Overview',
                    style: kCardTextStyle,
                  ),
                );
              },
              body: const Padding(
                padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                child: Text(
                  'CryptoPal helps users to get an idea about cryptocurrency trading. \n\n'
                  'App will show market prices of cryptocurrencies and cryptocurrency related news. \n\n'
                  'User can add predictions about the future cryptocurrency prices and get to know about prediction statistics. \n\n'
                  'User also can view machine learning generated cryptocurrency forecast prices. \n\n'
                  '\nThere are several limitations of the platform.\n\n'
                  'There are only a limited number of cryptocurrencies available.\n'
                  'Only the day OHLC (Open, High, Low, Close) prices are taken into consideration according to UTC.\n'
                  'Only closing price is taken to predicting and forecasting.\n'
                  'App needs to restart at the end of the to update with most recent values.\n',
                  style: kInstructionStyle,
                ),
              ),
              isExpanded: isOpen[0],
            ),
            ExpansionPanel(
              backgroundColor: kTransparentColor8,
              canTapOnHeader: true,
              headerBuilder: (context, val) {
                return const Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 10),
                  child: Text(
                    'Options',
                    style: kCardTextStyle,
                  ),
                );
              },
              body: const Padding(
                padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                child: Text(
                  'User experience can be customized by selecting the required cryptocurrencies to follow. \n\n'
                  'A shareable user card will be generated according to user score. \n\n'
                  'User score is generated with the user predictions on selected cryptocurrencies and overall accuracy level. \n\n',
                  style: kInstructionStyle,
                ),
              ),
              isExpanded: isOpen[1],
            ),
            ExpansionPanel(
              backgroundColor: kTransparentColor8,
              canTapOnHeader: true,
              headerBuilder: (context, val) {
                return const Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 10),
                  child: Text(
                    'Statistics',
                    style: kCardTextStyle,
                  ),
                );
              },
              body: const Padding(
                padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                child: Text(
                  'Statistics are calculated based on the currencies of choice. \n\n'
                  'Error is the difference of the prediction price compared to the actual price. \n\n'
                  'Error Deviation is the magnitude of that error without concerning the positivity or negativity. \n\n'
                  'Accuracy is calculated based on the error deviation of the prediction. \n'
                  'Accuracy% = 100% - (Error Deviation / Actual Price) x 100%\n\n'
                  'Overall accuracy is calculated by taking the average of accuracies of all predictions. \n\n',
                  style: kInstructionStyle,
                ),
              ),
              isExpanded: isOpen[2],
            ),
            ExpansionPanel(
              backgroundColor: kTransparentColor8,
              canTapOnHeader: true,
              headerBuilder: (context, val) {
                return const Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 10),
                  child: Text(
                    'Predictions',
                    style: kCardTextStyle,
                  ),
                );
              },
              body: const Padding(
                padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                child: Text(
                  'User can make price predictions on the currencies of choice on any future date. \n\n'
                  'User predictions are classified as past and future according to prediction dates. \n\n'
                  'User prediction statistics are also generated on cryptocurrencies. \n\n',
                  style: kInstructionStyle,
                ),
              ),
              isExpanded: isOpen[3],
            ),
            ExpansionPanel(
              backgroundColor: kTransparentColor8,
              canTapOnHeader: true,
              headerBuilder: (context, val) {
                return const Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 10),
                  child: Text(
                    'Forecasts',
                    style: kCardTextStyle,
                  ),
                );
              },
              body: const Padding(
                padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                child: Text(
                  'Forecasts are shown on the currencies of choice. \n\n'
                  'Forecast prices are machine learning generated values according to the past prices and it does not consider any other criteria. \n\n'
                  'Only consider them for guesses based on past patterns and not as prediction advice. \n\n'
                  'Accuracy of a currency forecast is calculated with the RMSE (Root Mean Square Error) of the machine learning model. \n'
                  'Accuracy% = 100% - (RMSE / Average Price) x 100%\n\n'
                  'Probability of price being in a range is calculated by considering the normal distribution around the forecast price, number of forecasted days and accuracy level of the currency. \n'
                  'Probability% = Probability of forecast price being in the range x (Accuracy level) ^ Number of forecasted days\n\n',
                  style: kInstructionStyle,
                ),
              ),
              isExpanded: isOpen[4],
            ),
            ExpansionPanel(
              backgroundColor: kTransparentColor8,
              canTapOnHeader: true,
              headerBuilder: (context, val) {
                return const Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 10),
                  child: Text(
                    'Market',
                    style: kCardTextStyle,
                  ),
                );
              },
              body: const Padding(
                padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                child: Text(
                  'Market prices are shown on the currencies of choice. \n\n'
                  'Last day closing price and last day price change percentage is shown. \n\n'
                  'Open, Close & OHLC price variation graphs are shown from the start day of that particular currency trading start date. \n\n',
                  style: kInstructionStyle,
                ),
              ),
              isExpanded: isOpen[5],
            ),
            ExpansionPanel(
              backgroundColor: kTransparentColor8,
              canTapOnHeader: true,
              headerBuilder: (context, val) {
                return const Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 10),
                  child: Text(
                    'News',
                    style: kCardTextStyle,
                  ),
                );
              },
              body: const Padding(
                padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                child: Text(
                  'News related to cryptocurrencies and cryptocurrency markets are available. \n\n'
                  'Most recent 100 news articles are displayed and the news article on news channel can be viewed within the app. \n\n',
                  style: kInstructionStyle,
                ),
              ),
              isExpanded: isOpen[6],
            ),
          ],
          expansionCallback: (i, value) {
            setState(() {
              isOpen[i] = !value;
            });
          },
        ),
      ),
    );
  }
}
