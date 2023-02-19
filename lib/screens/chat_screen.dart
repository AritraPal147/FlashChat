import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

// Variable that connects us to the Firebase Firestore database
final _fireStore = FirebaseFirestore.instance;
// User variable that stores the logged in user.
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Text Controller variable
  final messageTextController = TextEditingController();
  // Firebase authentication variable
  final _auth = FirebaseAuth.instance;

  // String variable that stores the message that the user types
  late String messageText;
  // Firestore.instance.collection(CollectionName).document(Timestamp.now()).setData(messageMap);

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
      // TODO: Implement error handling.
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
                _auth.signOut();
                exit(0);
              }),
        ],

        // Heading of Screen
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // StreamBuilder is a widget which builds itself based on a snapshot from
            // interacting with a Stream.
            const MessageBuilder(),
            Container(
              // Custom decoration from constants.dart
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    // TextField for user entered messages
                    child: TextField(
                      controller: messageTextController,
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
                      // Clears message TextField when Send button is pressed
                      messageTextController.clear();
                      // Send the messageText + email to the Firestore database
                      _fireStore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'timestamp': Timestamp.now(),
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

class MessageBuilder extends StatelessWidget {
  const MessageBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // stream is a QuerySnapshot ->
      // Contains the results of a query. It can contain zero or more DocumentSnapshot objects.
      stream: _fireStore.collection('messages').orderBy('timestamp', descending: true).snapshots(),
      // snapshot is an AsyncSnapshot ->
      // An immutable representation of the most recent interaction with an
      // asynchronous computation.
      builder: (context, snapshot) {
        // If no data is received
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        // Returns list of DocumentSnapshots, basically all the messages stored in the database
        final messages = snapshot.data!.docs;
        List<MessageBubble> messageBubbles = [];
        // String that stores message text received from the Stream
        late String msgText;
        // String that stores message sender received from the Stream
        late String msgSender;

        for (var message in messages) {
          // Converts the message.data() object into a Map of strings
          final messageMap = message.data() as Map<String, dynamic>;
          // Stores email of current user
          final currentUser = loggedInUser.email;

          messageMap.forEach((key, value) {
            if (key == 'sender') {
              // If sender data is present, put value into msgSender
              msgSender = value;
            } else if (key == 'text'){
              // If text is present, put value into msgText
              msgText = value;
            }
          });

          // Creates a Text widget using the text and sender fetched from Firebase
          final messageBubble = MessageBubble(
              sender: msgSender,
              text: msgText,
              isMe: currentUser == msgSender);
          messageBubbles.add(messageBubble);
        }
        // Adds all the Text widgets to the screen in a column.
        return Expanded(
          child: ListView(
            // Sticks the bottom of the listview to the top of virtual keyboard
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({
    super.key, 
    required this.sender, 
    required this.text,
    required this.isMe,
  });

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            )
              : const BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
              elevation: 5.0,
              color: isMe ? Colors.white : Colors.lightBlueAccent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                    text,
                  style: TextStyle(
                    color: isMe ? Colors.black: Colors.white,
                    fontSize: 15.0
                  ),
                ),
              )),
        ],
      ),
    );
  }
}



