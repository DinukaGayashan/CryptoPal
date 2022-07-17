import 'package:cryptopal/screens/initialization/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:intl/intl.dart';
import 'package:cryptopal/screens/initialization/welcome.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);
  static const String id = 'RegistrationForm';

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late String name;
  late DateTime birthday;
  late final User? user;
  bool emailVerified=false;

  void getUser() {
    try {
      user = _auth.currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future checkEmailVerification() async {
    User? user=_auth.currentUser;
    await user?.reload();
    if(user?.emailVerified==true){
      if (_formKey.currentState!.validate()) {
        try {
          await _firestore
              .collection('users')
              .doc(user?.uid)
              .set(
            {
              'email': user?.email,
              'name': name,
              'birthday': DateFormat('yyyy-MM-dd')
                  .format(birthday),
            },
            SetOptions(merge: true),
          );
          Navigator.pushReplacementNamed(
              context, SignIn.id);
        } catch (e) {
          snackBar(context,
              message: e.toString(), color: kRed);
        }
      }
    } else {
      snackBar(context,
          message:
          'Please verify your email to continue.',
          color: kRed);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = user?.email;

    return Scaffold(
      backgroundColor: kBaseColor1,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassBackground(
            context,
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Center(
                      child: Text(
                        'Registration Form',
                        style: kTopBarStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    const Text(
                      'Name',
                      style: kInstructionStyle2,
                    ),
                    SizedBox(
                      height: 70.0,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        style: kDetailsStyle,
                        cursorHeight: 25,
                        cursorColor: kAccentColor1,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kAccentColor1),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: kAccentColor3),
                          ),
                          hintText: 'Enter your name',
                          hintStyle: kHintStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Birthday',
                      style: kInstructionStyle2,
                    ),
                    SizedBox(
                      height: 130,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        maximumDate: DateTime.now(),
                        onDateTimeChanged: (DateTime value) {
                          birthday = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            userEmail.toString(),
                            style: kDetailsStyle,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          OutlinedButton(
                            child: SizedBox(
                              width: 150.0,
                              height: 50.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  Icon(
                                    Icons.email_outlined,
                                    color: kBaseColor2,
                                  ),
                                  Text(
                                    '  Verify Email',
                                    style: kInstructionStyle,
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              try {
                                user?.sendEmailVerification();
                                snackBar(context,
                                    message:
                                        'Verification email sent successfully.',
                                    color: kGreen);
                              } catch (e) {
                                snackBar(context,
                                    message: e.toString(), color: kRed);
                              }
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Wrong Email?',
                              style: kLinkStyle,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text(
                                      "Delete User Account\n",
                                      style: kSubSubjectStyle,
                                    ),
                                    content: Text(
                                      "Are you sure that you want to delete account created for " +
                                          userEmail.toString() +
                                          " email address?",
                                      style: kInstructionStyle,
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text(
                                          "No",
                                          style: kLinkStyle,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          "Yes",
                                          style: kLinkStyle,
                                        ),
                                        onPressed: () {
                                          try {
                                            user?.delete();
                                            snackBar(context,
                                                message: 'Account for email ' +
                                                    userEmail.toString() +
                                                    ' is deleted.',
                                                color: kGreen);
                                            Navigator.of(context).pop();
                                            Navigator.pushReplacementNamed(
                                                context, Welcome.id);
                                          } catch (e) {
                                            snackBar(context,
                                                message: e.toString(),
                                                color: kRed);
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: CupertinoButton(
                        color: kAccentColor1,
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        onPressed: () async {
                          await checkEmailVerification();
                        },
                        child: const Text(
                          'Submit',
                          style: kButtonTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
