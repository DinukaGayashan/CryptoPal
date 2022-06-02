const functions = require("firebase-functions");
const admin = require("firebase-admin");
const https = require("node:https");
const keys=require("./keys");
const PolygonAPIKey=keys.PolygonAPIKey;
admin.initializeApp(functions.config().firebase);

const cryptocurrencies=["BTC", "ETH", "LTC", "XRP", "DOGE"];
const numberOfCryptocurrencies=cryptocurrencies.length;
const timeOfADay=24*60*60*1000;

function delay(time) {
  return new Promise((resolve) => setTimeout(resolve, time));
}

async function checkCollectionForUser(email, col) {
  const userCollectionRef = admin.firestore().collection(col);
  const querySnapshot = await userCollectionRef
      .where("email", "==", email).get();
  return querySnapshot.size >= 1;
}

exports.checkUser = functions.https.onCall(async (data, context) => {
  const user = await checkCollectionForUser(data.email, "users");
  if (user) {
    return "user";
  } else {
    return "no";
  }
});

async function addAllCryptoData(year, month, date) {
  for (let i=0; i<numberOfCryptocurrencies; i++) {
    addCryptoData(cryptocurrencies[i], year, month, date);
    await delay(10*1000);
  }
}

function addCryptoData(cryptocurrency, year, month, date) {
  const PolygonURL="https://api.polygon.io/v2/aggs/ticker/X:" + cryptocurrency + "USD/range/1/day/" + year + "-" + month + "-" + date + "/"+ year + "-" + month + "-" + date +"?adjusted=true&sort=asc&limit=120&apiKey=" + PolygonAPIKey;

  https.get(PolygonURL, (res) => {
    let str="";
    let obj;
    res.on("data", function(chunk) {
      str+=chunk;
    });
    res.on("end", function() {
      obj = JSON.parse(str);
      admin.firestore().collection("realPrices")
          .doc(year + "-" + month + "-" + date + " " + cryptocurrency + "-USD")
          .set({
            openPrice: obj.results[0].o,
            closePrice: obj.results[0].c,
            highestPrice: obj.results[0].h,
            lowestPrice: obj.results[0].l,
            currency: cryptocurrency + "-USD",
            date: year + "-" + month + "-" + date,
          });
    });
  }).on("error", (e) => {
    console.error(e);
  });
}

exports.scheduledAPICall = functions.pubsub.schedule("every 6 hours")
    .onRun((context) => {
      const ts = Date.now()-timeOfADay;
      const day = new Date(ts);
      const date = day.getDate();
      const month = day.getMonth() + 1;
      const year = day.getFullYear();
      const monthString = month < 10 ? "0" + month : month;
      const dateString = date < 10 ? "0" + date : date;

      addAllCryptoData(year, monthString, dateString);
    });

exports.addPastCryptoData = functions.https.onCall(async (data, context) => {
  const numberOfDays = data.numberOfDays;
  const beforeDays = data.beforeDays;
  let ts = Date.now() -(beforeDays*timeOfADay);
  for (let i=0; i<numberOfDays; i++) {
    ts = ts - timeOfADay;
    const day = new Date(ts);
    const date = day.getDate();
    const month = day.getMonth() + 1;
    const year = day.getFullYear();
    const monthString = month < 10 ? "0" + month : month;
    const dateString = date < 10 ? "0" + date : date;
    addAllCryptoData(year, monthString, dateString);
    if (numberOfDays>1) {
      await delay(numberOfCryptocurrencies*11*1000);
    }
  }
});
