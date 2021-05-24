import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_attest/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_attest/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Инстанс FirebaseFirestore, позволяет получать колекцию
final _firestoreInstance = FirebaseFirestore.instance;

/// авторизованный пользователь
User? authorizedUser;

/// Экран Чата
class GeneralChatScreen extends StatefulWidget {
  static const String id = 'general_chat_screen';

  @override
  _GeneralChatScreenState createState() => _GeneralChatScreenState();
}

class _GeneralChatScreenState extends State<GeneralChatScreen> {
  final messageTextController = TextEditingController();
  /// Инстанс авторизации
  final _authInstance = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    getUser();
  }

  /// Получение текущего пользователя
  void getUser() {
    try {
      final user = _authInstance.currentUser;
      if (user != null) {
        authorizedUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              _authInstance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, StartScreen.id, (route) => false);
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _authInstance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, StartScreen.id, (route) => false);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (messageTextController.text.isNotEmpty) {
                        _firestoreInstance.collection('messages').add({
                          'text': messageTextController.text,
                          'sender': authorizedUser?.email,
                        });
                        messageTextController.clear();
                      }
                    },
                    child: Text(
                      'Send',
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

/// Виджет области сообщений,
/// читает изменения стрима колекции firestore
class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreInstance.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        List<MessageBubble> messageBubbles = [];
        snapshot.data!.docs.forEach((data) {
          final String messageText = data['text'] ?? '';
          final String messageSender = data['sender'] ?? '';

          final currentUser = authorizedUser?.email;
          if (messageText.isNotEmpty && messageSender.isNotEmpty) {
            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
        });

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}


/// Виджет для сообщения
/// [sender] - отправитель
/// [text] - текст сообщения
/// [isMe] - флажок будет тру, если сам пользователь отправитель
class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
