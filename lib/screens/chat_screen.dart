import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Firebase authentication variable
  final _auth = FirebaseAuth.instance;
  // Variable that connects us to the Firebase Firestore database
  final _fireStore = FirebaseFirestore.instance;
  // User variable that stores the logged in user.
  late User loggedInUser;
  // String variable that stores the message that the user types
  late String messageText;

  @override
  void initState() {
    super.initState();

    // Calls getCurrentUser() method.
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      // Stores currentUser in temporary variable user
      final user = _auth.currentUser;

      // Checks if currentUser in not null
      if (user != null) {
        // Stores user in loggedInUser variable
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[

          // Logout Button
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                //Implements logout functionality
                _auth.signOut();
                exit(0);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              // Custom decoration from constants.dart
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(

                    // TextField for user entered messages
                    child: TextField(
                      onChanged: (value) {
                        // Assign the value of TextField to message variable
                        messageText = value;
                      },
                      // Custom decoration from constants.dart
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),

                  // Send Button
                  TextButton(
                    onPressed: () {
                      // Send the messageText + email to the Firestore database
                      _fireStore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: const Text(
                      'Send',
                      // Custom style from constants.dart
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
