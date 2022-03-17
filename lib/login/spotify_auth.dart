import 'package:flutter/material.dart';
import 'package:mixtape/home/homepage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpotifyAuth extends StatelessWidget {
  const SpotifyAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mixtape',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WebView(
          initialUrl: 'http://localhost:8000',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            webViewController.runJavascriptReturningResult('100');
          },
          navigationDelegate: (request) {
            if (request.url.contains('http://localhost:8000/aboutme')) {
              Navigator.pop(context); // Close current window
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MixTapeHome()));
              return NavigationDecision.prevent; // Prevent opening url
            } else {
              return NavigationDecision.navigate; // Default decision
            }
          },
        ));
  }
}
