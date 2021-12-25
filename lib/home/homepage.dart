import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mixtape/intro_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<UserProfile> fetchUserData() async {
  final response = await http.get(Uri.parse('http://localhost:8000/aboutme'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // print(UserProfile.fromJson(jsonDecode(response.body)));
    return UserProfile.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<dynamic> logout(context) async {
  final response = await http.get(Uri.parse('http://localhost:8000/logout'));

  final cookieManager = CookieManager();
  cookieManager.clearCookies();

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => const IntroPage()));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class MixTapeHome extends StatefulWidget {
  const MixTapeHome({Key? key}) : super(key: key);

  @override
  _MixTapeHomeState createState() => _MixTapeHomeState();
}

class _MixTapeHomeState extends State<MixTapeHome> {
  late Future<UserProfile> futureUserData;

  @override
  void initState() {
    super.initState();
    futureUserData = fetchUserData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: FutureBuilder<UserProfile>(
                  future: futureUserData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                          child: Image.network(snapshot.data!.url.toString()));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    logout(context);
                  },
                  child: const Text("logout"))
            ]));
  }
}

class UserProfile {
  final String url;

  UserProfile({
    required this.url,
  });

  factory UserProfile.fromJson(String json) {
    return UserProfile(url: json);
  }
}
