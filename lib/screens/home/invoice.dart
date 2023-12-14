import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InvoiceScreen extends StatefulWidget {
  final String url, header;

  //final String url;
  const InvoiceScreen({
    Key? key,
    required this.url,
    required this.header,
  }) : super(key: key);

  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    //  if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.url);
    ////(widget.url);
    return Scaffold(
        appBar: widget.header == 'yes'
            ? AppBar(
                title: Text('Invoice'),
                centerTitle: true,
              )
            : null,
        body:
            Container() /*WebView(
        initialUrl: widget.url,
        onWebResourceError: (error) {},
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {},
        javascriptChannels: <JavascriptChannel>{
          _toasterJavascriptChannel(context),
        },
      ),*/
        );
  }

/*  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)));
        });
  }*/
}
