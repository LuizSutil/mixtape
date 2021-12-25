import 'package:flutter/material.dart';
import 'package:mixtape/login/login_intro.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        body: Ink(
            child: InkWell(
          onTap: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const InitAuth()))
          },
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                const Image(
                  width: 300,
                  height: 300,
                  image: AssetImage('assets/MixtapeLogo.png'),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text("Welcome to ",
                          style: TextStyle(
                              fontSize: 25,
                              color: Color.fromRGBO(30, 215, 96, 1))),
                      Text(
                        "Mix",
                        style: TextStyle(
                            fontSize: 25,
                            color: Color.fromRGBO(0, 255, 255, 1)),
                      ),
                      Text("ta",
                          style: TextStyle(
                              fontSize: 25,
                              color: Color.fromRGBO(255, 0, 255, 1))),
                      Text("pe",
                          style: TextStyle(
                              fontSize: 25,
                              color: Color.fromRGBO(255, 255, 0, 1)))
                    ])
              ])),
        )));
  }
}
