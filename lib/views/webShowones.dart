import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebShowOne extends StatefulWidget {
  //const WebShow({ Key? key }) : super(key: key);

  @override
  _WebShowOneState createState() => _WebShowOneState();
}

class _WebShowOneState extends State<WebShowOne> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('www.youtube.com'),
        ),
        body: WebView(
          initialUrl: 'https://www.youtube.com',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
        ));
  }
}
