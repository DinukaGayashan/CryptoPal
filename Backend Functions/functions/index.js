const functions = require("firebase-functions");
const admin = require("firebase-admin");
const https = require("node:https");
const PolygonAPIKey="dfaoNptLepezfrOyWOBcAshNWt2BtnqQ";
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
  const PolygonURL="https://api.polygon.io/v1/open-close/crypto/" + cryptocurrency + "/USD/" + year + "-" + month + "-" + date + "?adjusted=true&apiKey=" + PolygonAPIKey;
  https.get(PolygonURL, (res) => {
    let str="";
    let obj;
    res.on("data", function(chunk) {
      str+=chunk;
    });
    res.on("end", function() {
      obj = JSON.parse(str);
      admin.firestore().collection(obj.symbol).doc(obj.day.split("T")[0])
          .set({openPrice: obj.open, closePrice: obj.close});
    });
  }).on("error", (e) => {
    console.error(e);
  });
}

exports.scheduledAPICall = functions.pubsub.schedule("0 1 * * *")
    .timeZone("America/New_York")
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
    await delay(numberOfCryptocurrencies*15*1000);
  }
});
