<h3 align="center">
  <img alt="CryptoPal_logo" src="https://github.com/DinukaGayashan/CryptoPal/blob/master/assets/CryptoPal-logo-with-name.png?raw=true" width=800/><br>
  <i>Advisory platform for cryptocurrency investment</i>
</h3>

<p align = "center">
  Project by <a href="https://www.linkedin.com/in/dinukagayashan/">Dinuka Gayashan</a>
</p>
<br>

## What's here?
This is the complete repository that contains the whole project CryptoPal. This includes the implementations of mobile application, Backend, Machine Learning models and App landing webpage.

<br>

## Overview
Cryptocurrency investment has gained a huge interest lately although cryptocurrencies are considered high-risk investments. To overcome issues with cryptocurrecny investments, CryptoPal is an advisory software system that helps users to get an idea, and experience cryptocurrency investment. It acknowledges users with market data and related news, provides users with forecast prices generated with machine learning models and allows users to add price predictions and view the statistics of their predictions. This will lead users to improve their prediction capability and experience the cryptocurrency price behavior which leads to an overall improvement in users’ ability to invest in cryptocurrencies.

### Features
* Provide cryptocurrency market data.
* Provide news related to cryptocurrencies.
* Allow users to add price predictions and view their prediction statistics.
* Provide users with machine learning price forecasts.

<br>

## Design
The mobile application is at the front-end of the software system. It is facilitated by the cloud back-end service which is consist of database, authentication, cloud functions, and hosting. Machine learning modes are deployed in a separate cloud service and it is served as an API. 

![system_architecture](https://github.com/DinukaGayashan/CryptoPal/blob/master/assets/system_architecture.png?raw=true)

To automate the data fetching, calling machine learning models, and other related back-end functionalities, cloud functions are being used.

<br>

## Built with
[Flutter](https://flutter.dev/) is used for frontend development; mobile application and webpage.

[Firebase](https://firebase.google.com/) is used as the mobile application backend service.

[Heroku](https://www.heroku.com/) is used to deploy machine learning models.

[Polygon.io](https://polygon.io/) and [NewsAPI](https://newsapi.org/) APIs are used to fetch required data.

<br>

### View more on
Project Webpage - https://cryptopal-e288a.web.app/

Project Report - https://www.overleaf.com/read/mfdyvychckpy

Project Repository - https://github.com/DinukaGayashan/CryptoPal