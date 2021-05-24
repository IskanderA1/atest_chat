import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_attest/screens/start_screen.dart';
import 'package:flash_chat_attest/screens/auth_screen.dart';
import 'package:flash_chat_attest/screens/registr_screen.dart';
import 'package:flash_chat_attest/screens/general_chat_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: StartScreen.id,
      routes: {
        StartScreen.id: (context) => StartScreen(),
        AuthScreen.id: (context) => AuthScreen(),
        RegistrScreen.id: (context) => RegistrScreen(),
        GeneralChatScreen.id: (context) => GeneralChatScreen(),
      },
    );
  }
}
