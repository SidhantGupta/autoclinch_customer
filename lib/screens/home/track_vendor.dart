import 'dart:io' show Platform;

import 'package:autoclinch_customer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'home_main.dart';

class VendorTrackingScreen extends StatefulWidget {
  final TrackingIntent intentData;
  const VendorTrackingScreen(this.intentData, {Key? key}) : super(key: key);

  @override
  _VendorTrackingScreenState createState() => _VendorTrackingScreenState();
}

class _VendorTrackingScreenState extends State<VendorTrackingScreen> {
  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Track Vendor',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeMainScreen(id: "0")),
                  (route) => false);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body:
            Container() /*WebView(
        initialUrl: '${BASE_URL}trackVendor/${widget.intentData.bookingId}',
        javascriptMode: JavascriptMode.unrestricted,
      ),*/
        );
  }
}

class TrackingIntent {
  final String bookingId;

  TrackingIntent({required this.bookingId});
}
