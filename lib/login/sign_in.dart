import 'package:flutter/material.dart';
import 'package:mixtape/types/user_login_data.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mixtape/intro_page.dart';

class SignInPage extends StatefulWidget {
  final UserProfile foundProfile;

  const SignInPage({Key? key, required this.foundProfile}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
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
    throw Exception('Failed to logout');
  }
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Text(
                  'Your spotify is already registerd to: ${widget.foundProfile.email}'),
              Image.network(
                widget.foundProfile.profileImage,
                scale: 3,
              ),
              const Text("Is this you?"),
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
                  onPressed: () {
                    // ignore: avoid_print
                    print("login");
                    // print(_passwordController.text);
                  },
                  child: const Text("login")),
              const Text("if its not then..."),
              ElevatedButton(
                  onPressed: () {
                    logout(context);
                    // print(_passwordController.text);
                  },
                  child: const Text("logout")),
            ])));
  }
}
