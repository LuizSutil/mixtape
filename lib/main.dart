import 'package:flutter/material.dart';
import 'package:mixtape/intro_page.dart';
// import 'package:mixtape/login/sign_in.dart';
// import 'package:mixtape/types/user_login_data.dart';

void main() {
  runApp(MaterialApp(
      title: 'Mixtape',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IntroPage()));
  // SignInPage(
  //     foundProfile: UserProfile(
  //         profileImage:
  //             "https://i.postimg.cc/NGPh7gC1/1-9-RCWyx908-QYPP1-W5-EAfe-g.jpg",
  //         displayName: "Luiz Sutil",
  //         email: "lufesg@gmail.com")))
}
