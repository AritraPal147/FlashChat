import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/lib/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  // Firebase authentication variable
  final _auth = FirebaseAuth.instance;
  // Variable to store the user input email.
  late String email;
  // Variable to store the user input password.
  late String password;
  // Boolean controller value for modal progress HUD
  bool showLoadingAnimation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showLoadingAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Hero provides simple movement animation of our flash chat logo
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  // Stores the value input inside the TextField into email variable
                  email = value;
                },
                // Custom TextField decoration from constants.dart
                decoration: kTextFieldDecoration,
                // Changes the keyboard to email type keyboard, i.e., adds @ to the keyboard bottom row
                keyboardType: TextInputType.emailAddress,
                ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  // Stores the value input inside the TextField into password variable
                  password = value;
                },
                // Custom TextField decoration from constants.dart, with changes hintText
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter you password',
                ),
                // Password shows up in screen obscured, i.e., dots are shown in TextField
                obscureText: true,
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.blueAccent,
                title: 'Register',
                onPressed: () async {
                  setState(() {
                    // Shows Loading animation
                    showLoadingAnimation = true;
                  });
                  try {
                    // TODO: Check password size >= 6 characters
                    // Creates user with given email and password
                    await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (context.mounted) {
                      // Navigate to Chat Screen when new user is created.
                      Navigator.pushNamed(context, ChatScreen.id);
                    }

                    setState(() {
                      // Stops loading animation
                      showLoadingAnimation = false;
                    });
                  } catch (e) {
                    // TODO: Implement registration error handling such as already existing user
                    print(e);
                  }
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
