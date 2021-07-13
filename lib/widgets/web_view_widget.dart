import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatefulWidget {
  const WebViewWidget({Key key, this.initialUrl, this.roomLogicController}) : super(key: key);

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();

  final String initialUrl;
  final RoomLogicController roomLogicController;
}

class _WebViewWidgetState extends State<WebViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return WebView(
        initialUrl: widget.initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onProgress: (int progress) {
          return Center(child: CircularProgressIndicator());
        },
        
      );
    });
  }
}
