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
            const Text("Mixtape uses Spotify to get its data!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(30, 215, 96, 1))),
            const Text("So we need your permission to do stuff",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(30, 215, 96, 1))),
            const Text("Please login to your spotify to continue!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(30, 215, 96, 1))),
            Padding(
                padding: const EdgeInsets.only(top: 40),
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
                          left: 30, right: 30, top: 10, bottom: 10),
                      child: Text(
                        'Mix with Spotify!',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )))
          ],
        )));
  }
}
