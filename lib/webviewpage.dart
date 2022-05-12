import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:webview_flutter/webview_flutter.dart';


final WebViewKey=GlobalKey<_WebViewContainerState>();

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  bool hasInternet=false;
  @override
  void initState()
  {
    super.initState();
    connectionChecker();
  }
  Future<void> connectionChecker()
  async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;

    if(isConnected)
      {
        setState(() {
          hasInternet=true;
        });
      }
    else
      {
        setState(() {
          hasInternet=false;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: (hasInternet)?WebViewContainer():
            Center(
              child: Row(
                children:  [
                  const Text("No internet connection   ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  IconButton(onPressed: (){
                    connectionChecker();
                    WebViewKey.currentState?.reload();
                  },
                      icon: const Icon(Icons.refresh_outlined))
                ],
              ),
            )
      ),
    );
  }
}
class WebViewContainer extends StatefulWidget {
  const WebViewContainer({Key? key}) : super(key: key);

  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return WebView(
        initialUrl: 'https://resumebuilderweb.com/',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
      _controller.complete(webViewController);
    },
    onProgress: (int progress) {
    print('WebView is loading (progress : $progress%)');
    },
    );
  }
  void reload()
  {
    _webViewController.reload();
  }
}

