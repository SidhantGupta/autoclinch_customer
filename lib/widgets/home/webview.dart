import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DashBoard extends StatefulWidget {
  String? url;
  DashBoard({required this.url, Key? key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

String? link;

class _DashBoardState extends State<DashBoard> {
  void initState() {
    controllerr_dashboard = WebViewController();
    controllerr_dashboard.clearCache();
    setState(() {
      link = widget.url;
      print(link);
    });
    // ..loadRequest(Uri.parse('https://www.upskillcampus.com/'));
    //dynamic super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* floatingActionButton: ExpandableFab(children: [
        ActionButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              ////  if(document.data().value[]){
              controllerr_dashboard.goBack();
            }),
        ActionButton(
          icon: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
          onPressed: () {
            controllerr_dashboard.goForward();
          },
        ),
        ActionButton(
          icon: const Icon(
            Icons.replay,
            color: Colors.white,
          ),
          onPressed: () {
            controllerr_dashboard.loadRequest(
                Uri.parse('https://learn.upskillcampus.com/s/mycourses'));
          },
        ),
      ], distance: 120),
      // appBar: AppBar(title: const Text('Flutter Simple Example')),*/
      body: SafeArea(
          child: WillPopScope(
              onWillPop: () async {
                if (await controllerr_dashboard.canGoBack()) {
                  controllerr_dashboard.goBack();
                  return false;
                } else {
                  return true;
                }
              },
              child: InAppWebView(
                initialUrlRequest:
                    URLRequest(url: WebUri(widget.url.toString())),
              )
              /* WebViewWidget(
                controller: controllerr_dashboard,
              )*/

              )),
    );
  }
}

WebViewController controllerr_dashboard = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (link) {
        Uri.parse(link.toString());
      },
      onPageFinished: (String url) {},
      onWebResourceError: (error) {
        // _onLoadHtmlStringExample();
      },
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://learn.upskillcampus.com/s/mycourses'));
