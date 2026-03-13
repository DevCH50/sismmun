import 'package:flutter/material.dart';

class LoginBackGround extends StatelessWidget {
  const LoginBackGround({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/img/background1.jpg', // Replace with your image path
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black54,
      colorBlendMode: BlendMode.darken,
    );
  }
}
