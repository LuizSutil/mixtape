import 'package:flutter/material.dart';
import 'package:mixtape/intro_page.dart';

void main() {
  runApp(MaterialApp(
      title: 'Mixtape',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IntroPage()));
}
