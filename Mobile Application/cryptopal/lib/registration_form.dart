import 'package:flutter/material.dart';
import 'constants.dart';

class registration_form extends StatelessWidget {
  const registration_form({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAccentColor1,
      appBar: AppBar(
        backgroundColor: kAccentColor3,
        elevation: 8.0,
        toolbarHeight: 80.0,
        title: const Text(
          'Registration Form',
          style: kSubSubjectStyle,
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
                ),
                const SizedBox(
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
                ),
                const SizedBox(
                  height: 30.0,
                ),
                const Text(
                  'Address',
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
                    hintText: 'Enter your address',
                    hintStyle: kHintStyle,
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                MaterialButton(
                  color: kAccentColor3,
                  height:40.0,
                  minWidth: double.infinity,
                  onPressed: () {},
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