import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth=FirebaseAuth.instance;
final _firestore=FirebaseFirestore.instance;
late UserAccount currentUser=UserAccount();

Future<UserAccount> getActiveUserData() async {
  try{
    currentUser.user= _auth.currentUser;
  }
  catch(e){
    print(e);
  }
  try {
    final userSnapshot=await _firestore.collection('users').doc(currentUser.user?.uid).get();
    currentUser.name=userSnapshot.data()!['name'];
    currentUser.birthday=userSnapshot.data()!['birthday'];
    //for(int i=0;i<userSnapshot['predictions/cryptocurrency'];i++)
  }
  catch(e){
    print(e);
  }
  return currentUser;
}

class Prediction{
  late String date;
  late String cryptocurrency;
  late final predictedClosePrice;
  late final errorPercentage;
}

class UserAccount{
  late final User? user;
  late final String name;
  late final DateTime birthday;
  late final List<dynamic> predictions;

}