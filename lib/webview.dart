import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MinhaWebView extends StatefulWidget {
  @override
  _MinhaWebViewState createState() => _MinhaWebViewState();
}

class _MinhaWebViewState extends State<MinhaWebView> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final TextEditingController _editingController = TextEditingController();
  bool isCarregando = false;
  WebViewController webviewController;

  @override
  void initState() {
    _editingController.text = "https://www.google.com";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _telaCarregando = isCarregando ? CircularProgressIndicator() : null;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: <Widget>[
            Column(
              children: [
                Container(
                  color: Colors.grey[300],
                  padding: EdgeInsets.all(10).copyWith(bottom: 0),
                  child: Row(
                    children: [
                      Expanded(child: TextField(controller: _editingController)),
                      SizedBox(width: 20),
                      RaisedButton(
                        child: Text("Navegar", style: TextStyle(color: Colors.white)),
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            webviewController.loadUrl(_editingController.text);
                          });
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                      padding: EdgeInsets.all(10),
                      child: WebView(
                        initialUrl: _editingController.text,
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (WebViewController wvc) async {
                          webviewController = wvc;
                          _controller.complete(wvc);
                          setState(() {});
                        },
                        onPageStarted: (String s) async {
                          isCarregando = true;
                          setState(() {});
                        },
                        onPageFinished: (String ulr) {
                          isCarregando = false;
                          setState(() {});
                        },
                        navigationDelegate: (NavigationRequest request) async {
                          //return NavigationDecision.prevent;
                          return NavigationDecision.navigate;
                        },
                        debuggingEnabled: kDebugMode,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: _telaCarregando,
            ),
          ],
        ),
      ),
    );
  }
}
