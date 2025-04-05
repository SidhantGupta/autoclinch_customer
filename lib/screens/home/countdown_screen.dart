import 'dart:async' show Timer;

import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/payments_vehicle_response.dart';
import 'package:autoclinch_customer/network/model/vendor_details_response.dart';
import 'package:autoclinch_customer/screens/home/payment_screen.dart';
import 'package:autoclinch_customer/screens/home/track_vendor.dart';
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:map_place_picker/map_place_picker.dart';

class CountDownScreen extends StatefulWidget {
  final TimerIntentData? intentData;

  CountDownScreen({this.intentData, Key? key}) : super(key: key);

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  late Future<PaymentVehicleResponse?> _paymentVehicleResponse;

  @override
  void initState() {
    _paymentVehicleResponse = _getLatLongAndApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return CountDown();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Waiting for vendor approval',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: FutureBuilder<PaymentVehicleResponse?>(
            future: _paymentVehicleResponse,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    // ////("Data is Has error null");
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data?.data != null) {
                    // ////("Data is not null");

                    return SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            // Image.asset(
                            //   "assets/images/sandclock.png",
                            //   height: 180,
                            // ),
                            LottieBuilder.asset(
                              'assets/icons/car.json',
                              animate: true,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _Counter(
                                  timerMaxSeconds:
                                      int.parse(snapshot.data!.data!.timeout) *
                                          60,
                                  timerCompleted: (isInterval) =>
                                      _chcekOrderStatus(context, isInterval),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Please wait for the approval from Vendor Side",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return Text('Result: ${snapshot.data}');
              }
            },
          )),
    );
  }

  Future<PaymentVehicleResponse?> _getLatLongAndApi() async {
    MapAddress? _mapAddress = await SharedPreferenceUtil().getMapAddress();
    ////(intentData?.vehicle_det.toString());
    ///

    return ApiService().execute<PaymentVehicleResponse>('pre-user-request-api',
        params: {
          'vendor_id': widget.intentData?.vendor.id,
          'lat': _mapAddress?.latitude.toString(),
          'lng': _mapAddress?.longitude.toString(),
          'service_problem': widget.intentData?.remarks,
          'service_type': widget.intentData?.serviceType,
          'vehicle_det': widget.intentData?.vehicle_det
        }..addAll(widget.intentData?.services
                .asMap()
                .map((key, value) => MapEntry("services[$key]", value)) ??
            {"services[0]": null}),
        isThrowExc: true);
  }

  void _chcekOrderStatus(BuildContext context, bool isInterval) async {
    final PaymentVehicleResponse? response =
        await ApiService().execute<PaymentVehicleResponse>(
      'check-vendor-api',
      params: {
        'vendor_id': widget.intentData!.vendor.id,
        'is_last': isInterval ? '0' : '1',
      },
    );

    if (response?.data != null && response?.data?.isAccepted == true) {
      final input = PaymentIntentData(
        vendor: widget.intentData!.vendor,
        services: widget.intentData?.services ?? [],
        paymentVehicleData: response!.data!,
      );

      var bookingId = response.data!.bookingId;

      // Navigator.of(context).pushNamed("/home", arguments: "0");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SuccessWidget(bookingId: bookingId),
        ),
      );
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeMainScreen(id: "0")), (route) => false);

      // Navigator.of(context).pushReplacementNamed("/home", arguments: "0");

      // Navigator.of(context).popAndPushNamed("/paymentscreen", arguments: input);
    } else if (response?.data != null && response?.data?.isAccepted == false) {
      showRejectionDialog(context);
    } else {
      if (!isInterval) {
        ApiService().showToast('Vendor is not responding');
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      }
    }
  }

  Future<dynamic> showRejectionDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text("Vendor has rejected your request"),
          actions: <Widget>[
            TextButton(
              child: Text("Go to Home"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/home', (route) => false);
              },
            )
          ],
        );
      },
    );
  }
}

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({Key? key, required this.bookingId}) : super(key: key);

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              LottieBuilder.asset(
                'assets/icons/successful.json',
                repeat: false,
              ),
              Text('Vendor has accepted your request',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text('Please wait for the vendor to reach you',
                  style: TextStyle(fontSize: 15, color: Colors.grey)),
              SizedBox(height: 5),
              Text('You will be notified when the vendor is arrived',
                  style: TextStyle(fontSize: 15, color: Colors.grey)),
              SizedBox(height: 10),
              Text('Thank you for using our service !'),
              SizedBox(height: 10),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home',
                        (route) => false,
                        arguments: "0",
                      ),
                      child: Text('My Bookings'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/trackvendor',
                            arguments: TrackingIntent(
                              bookingId: bookingId,
                            ));
                      },
                      child: Text('Track Vendor'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // primary: Theme.of(context).primaryColor,
                  minimumSize: Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil('/home', (route) => false),
                child: Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerIntentData {
  final Vendor vendor;
  final String? remarks;
  final String? vehicle_det;
  final String serviceType;
  final List<String> services;

  TimerIntentData({
    required this.vendor,
    required this.services,
    required this.serviceType,
    this.remarks,
    this.vehicle_det,
  });
}

class _Counter extends StatefulWidget {
  const _Counter(
      {required this.timerMaxSeconds, required this.timerCompleted, Key? key})
      : super(key: key);

  final int timerMaxSeconds;
  final Function(bool) timerCompleted;

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  @override
  void initState() {
    _startTimeout();
    super.initState();
  }

  Timer? _timer;
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _startTimeout() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _timerCounting);
  }

  void _timerCounting(timer) {
    setState(() {
      ////(timer.tick);
      currentSeconds = timer.tick;
      if (timer.tick >= widget.timerMaxSeconds) {
        widget.timerCompleted(false);
        timer.cancel();
      } else if (timer.tick % 15 == 0) {
        widget.timerCompleted(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      timerText,
      style: TextStyle(fontSize: 50),
    );
  }

  int currentSeconds = 0;

  String get timerText =>
      '${((widget.timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((widget.timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
}
