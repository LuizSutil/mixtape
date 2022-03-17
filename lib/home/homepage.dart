import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mixtape/intro_page.dart';
import 'package:mixtape/login/login_intro.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<UserProfile> fetchUserData(context) async {
  final response = await http.get(Uri.parse('http://localhost:8000/aboutme'));

  if (response.statusCode == 200) {
    return UserProfile.fromJson(jsonDecode(response.body));
  } else {
    // this should push to login page, gonna create login page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const InitAuth()));
    throw Exception('Failed to load album');
  }
}

Future<String> RegisterUserPassword(
    String pwdText, UserProfile userData) async {
  print(pwdText);
  print(userData.displayName);
  final Map<String, String> mixAccountInfo = {
    "name": userData.displayName,
    "email": userData.email,
    "password": pwdText
  };

  final response = await http.post(Uri.parse('http://localhost:8000/register'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: json.encode(mixAccountInfo));

  if (response.statusCode == 201) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    return "yay";
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('rip');
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

  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    futureUserData = fetchUserData(context);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  // ignore: annotate_overrides
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
                      return Column(children: [
                        const Text("Hello"),
                        Text(snapshot.data!.displayName.toString()),
                        Image.network(
                          snapshot.data!.profileImage.toString(),
                          scale: 3,
                        ),
                        const Text("This will be your mixtape email!"),
                        Text(snapshot.data!.email.toString()),
                        const Text("Please add a mixtape password"),
                      ]);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ),
              SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    // logout(context);
                    final userData = await fetchUserData(context);
                    RegisterUserPassword(_passwordController.text, userData);
                  },
                  child: const Text("register")),
              ElevatedButton(
                  onPressed: () {
                    logout(context);

                    print(_passwordController.text);
                  },
                  child: const Text("logout")),
              // ElevatedButton(
              //     onPressed: () async {
              //       await storage.write(
              //           key: "test", value: "engenharia de software");
              //       ;
              //     },
              //     child: const Text("escrever sstorage")),
              // ElevatedButton(
              //     onPressed: () async {
              //       String? value = await storage.read(key: "test");
              //       print(value);
              //     },
              //     child: const Text("read sstorage")),
            ]));
  }
}

class UserProfile {
  final String profileImage;
  final String displayName;
  final String email;

  UserProfile(
      {required this.profileImage,
      required this.displayName,
      required this.email});

  factory UserProfile.fromJson(dynamic json) {
    return UserProfile(
        profileImage: json['profile_image'],
        displayName: json['display_name'],
        email: json['email']);
  }
}
