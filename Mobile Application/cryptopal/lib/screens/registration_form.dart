import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cryptopal/utility/constants.dart';
import 'dashboard.dart';

class registration_form extends StatefulWidget {
  const registration_form({Key? key}) : super(key: key);

  static const String id='registration_form';

  @override
  State<registration_form> createState() => _registration_formState();
}

class _registration_formState extends State<registration_form> {

  late String name;
  late DateTime birthday;
  late final User? user;
  final _auth=FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() {
    try{
      user= _auth.currentUser;
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAccentColor1,
      appBar: AppBar(
        backgroundColor: kAccentColor1,
        elevation: 0.0,
        toolbarHeight: 80.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: CircleAvatar(
                backgroundColor: kAccentColor1,
                radius: 25.0,
                child: Image.asset('assets/images/CryptoPal-logo-black.png'),
              ),
            ),
            const Hero(
              tag: 'name',
              child: Text(
                "CryptoPal",
                style: kTitleStyle,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                const Center(
                  child: Text(
                    'Registration Form',
                    style: kSubSubjectStyle,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                const Text(
                  'Name',
                  style: kInstructionStyle2,
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  style: kDetailsStyle,
                  cursorHeight: 25,
                  cursorColor: kAccentColor3,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: kAccentColor3
                        )
                    ),
                    hintText: 'Enter your name',
                    hintStyle: kHintStyle,
                  ),
                  onChanged: (value){
                    name=value;
                  },
                ),
                const SizedBox(
                  height: 30.0,
                ),
                const Text(
                  'Birthday',
                  style: kInstructionStyle2,
                ),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime value) {
                      birthday=value;
                    },
                  ),
                ),
                /*const SizedBox(
                  height: 30.0,
                ),
                const Text(
                  'Contact Number',
                  style: kInstructionStyle2,
                ),
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(),
                  style: kDetailsStyle,
                  cursorHeight: 25,
                  cursorColor: kAccentColor3,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: kAccentColor3
                        )
                    ),
                    hintText: 'Enter your contact number',
                    hintStyle: kHintStyle,
                  ),
                ),*/
                const SizedBox(
                  height: 40.0,
                ),
                MaterialButton(
                  color: kAccentColor3,
                  height:40.0,
                  minWidth: double.infinity,
                  onPressed: () async {
                    try{
                      await _firestore.collection('users').doc(user?.uid).set(
                          {
                            'email': user?.email,
                            'name': name,
                            'birthday': birthday,
                          }
                      );
                      Navigator.pushNamed(context, dashboard.id);
                    }
                    catch(e){
                      print(e);
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: kButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
