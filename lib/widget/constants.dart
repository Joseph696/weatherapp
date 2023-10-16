import 'package:flutter/material.dart';

class Constants {
  final primaryColor = Color.fromARGB(255, 134, 107, 252);
  final secondaryColor = const Color(0xffa1c6fd);
  final tertiarycolor = const Color(0xff205cf1);
  final blackColor = const Color(0xff0000);
  final greyColor = const Color(0xd9dadb);

  final Shader shader = const LinearGradient(
    colors: <Color>[Color(0xffABcff2), Color.fromARGB(255, 75, 111, 147)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0,
      70.0)); // final shader = Color.fromARGB(255, 240, 238, 245);

  final LinearGradientBlue = const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.topLeft,
      stops: [0.0, 1.0],
      colors: <Color>[Color(0xffABcff2), Color.fromARGB(255, 101, 156, 211)]);

  final LinearGradientPurple = const LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      stops: [0.0, 1.0],
      colors: <Color>[Color(0xff51087e), Color.fromARGB(0, 132, 47, 142)]);
}
