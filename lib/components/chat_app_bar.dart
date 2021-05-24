import 'package:flutter/material.dart';


/// Виджет Апп бара,
/// [onPressed] - функция которая вызовется при нажатии кнопки назад
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onPressed;

  const ChatAppBar({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        splashRadius: 25,
        onPressed: onPressed,
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.blue,
        ),
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
