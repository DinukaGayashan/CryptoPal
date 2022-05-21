const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

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
