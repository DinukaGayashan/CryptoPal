import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:intl/intl.dart';
import 'dashboard.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);
  static const String id = 'RegistrationForm';

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  late String name;
  late DateTime birthday;
  late final User? user;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() {
    try {
      user = _auth.currentUser;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAccentColor1,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: logoAppBar(context),
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
                        borderSide: BorderSide(color: kAccentColor3)),
                    hintText: 'Enter your name',
                    hintStyle: kHintStyle,
                  ),
                  onChanged: (value) {
                    name = value;
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
                      birthday = value;
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
                  height: 40.0,
                  minWidth: double.infinity,
                  onPressed: () async {
                    try {
                      await _firestore.collection('users').doc(user?.uid).set(
                        {
                          'email': user?.email,
                          'name': name,
                          'birthday': DateFormat('yyyy-MM-dd').format(birthday),
                        },
                        SetOptions(merge: true),
                      );
                      Navigator.pushNamed(context, Dashboard.id);
                    } catch (e) {
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
