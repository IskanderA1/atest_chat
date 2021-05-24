import 'package:flash_chat_attest/components/chat_app_bar.dart';
import 'package:flash_chat_attest/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_attest/components/rounded_button.dart';
import 'package:flash_chat_attest/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'general_chat_screen.dart';

/// Экран Регистрации, позволяет ввести логин и пороль,
/// чтобы зарегистрироваться через  Firebase
class RegistrScreen extends StatefulWidget {
  static const String id = 'registr_screen';

  @override
  _RegistrScreenState createState() => _RegistrScreenState();
}

class _RegistrScreenState extends State<RegistrScreen> {
  
  /// Инстанс авторизации
  final _authInstance = FirebaseAuth.instance;
  
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatAppBar(
        onPressed: () => Navigator.pop(context),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  controller: emailController,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  controller: passwordController,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Register',
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await _authInstance.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        Navigator.pushNamed(context, GeneralChatScreen.id);

                        setState(() {
                          isLoading = false;
                        });
                      } catch (e) {
                        print(e);
                        setState(() {
                          isLoading = false;
                        });
                        final snackBar = SnackBar(
                          content: Text('$e'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                ),
                RoundedButton(
                  title: 'Log In',
                  colour: Colors.lightBlueAccent,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AuthScreen.id);
                  },
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
