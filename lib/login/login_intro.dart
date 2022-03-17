import 'package:flutter/material.dart';
import 'package:mixtape/login/spotify_auth.dart';

class InitAuth extends StatelessWidget {
  const InitAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text("Welcome to ",
                      style: TextStyle(
                          fontSize: 25, color: Color.fromRGBO(30, 215, 96, 1))),
                  Text(
                    "Mix",
                    style: TextStyle(
                        fontSize: 25, color: Color.fromRGBO(0, 255, 255, 1)),
                  ),
                  Text("ta",
                      style: TextStyle(
                          fontSize: 25, color: Color.fromRGBO(255, 0, 255, 1))),
                  Text("pe",
                      style: TextStyle(
                          fontSize: 25, color: Color.fromRGBO(255, 255, 0, 1)))
                ]),
            const Image(
              width: 150,
              height: 150,
              image: AssetImage('assets/MixtapeLogo.png'),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // ignore: avoid_print
                      print("login");
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Color.fromRGBO(30, 215, 96, 1),
                            fontSize: 20),
                      ),
                    ))),
            const Text("Or",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(30, 215, 96, 1))),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)),
                      backgroundColor: const Color.fromRGBO(30, 215, 96, 1),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SpotifyAuth()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, top: 10, bottom: 10),
                      child: Text(
                        "Mix now!",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )))
          ],
        )));
  }
}
