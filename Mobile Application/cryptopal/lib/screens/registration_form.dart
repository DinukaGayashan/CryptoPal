import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptopal/utility/constants.dart';
import 'package:cryptopal/utility/widgets.dart';
import 'package:intl/intl.dart';
import 'package:cryptopal/screens/dashboard_loading.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);
  static const String id = 'RegistrationForm';

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey=GlobalKey<FormState>();
  late String name;
  late DateTime birthday;
  late final User? user;

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
      backgroundColor: Colors.transparent,
      /*appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: logoAppBar(context),
      ),*/
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: glassCard(context, SingleChildScrollView(
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
                        style: kSubSubjectStyle,
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
                              borderSide: BorderSide(color: kAccentColor1),),
                          disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: kAccentColor3),),
                          hintText: 'Enter your name',
                          hintStyle: kHintStyle,
                        ),
                        validator: (value){
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
                      color: kAccentColor1,
                      height: 45.0,
                      minWidth: double.infinity,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          /*ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );*/
                          try {
                            await _firestore.collection('users').doc(user?.uid).set(
                              {
                                'email': user?.email,
                                'name': name,
                                'birthday': DateFormat('yyyy-MM-dd').format(birthday),
                              },
                              SetOptions(merge: true),
                            );
                            Navigator.pushNamed(context, DashboardLoading.id);
                          } catch (e) {
                            print(e);
                          }
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
        ),
      ),
    );
  }
}
