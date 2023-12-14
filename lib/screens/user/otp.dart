import 'dart:async' show Timer;

import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/common_response.dart';
import 'package:autoclinch_customer/network/model/otp_arguments.dart';
import 'package:autoclinch_customer/notifiers/otp_notifers.dart';
import 'package:autoclinch_customer/widgets/user/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider, WatchContext, ChangeNotifierProvider;

import '/utils/extensions.dart' show ScreenLoader;
import '/widgets/user/login_banner.dart';

class OtpScreen extends StatefulWidget {
  late final OTPArg otparg;

  OtpScreen({Key? key, required this.otparg}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle style = TextStyle(fontSize: 14.0);

  final TextStyle labelTextstyle = TextStyle(fontSize: 14.0);

  @override
  Widget build(BuildContext context) {
    String otp = "";

    String email = "";
    String frompath = "";

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () async {
          if (_formKey.currentState?.validate() == true) {
            _formKey.currentState?.save();
            // tokenverify/ranjithkadumeni@gmail.com/882702

            email = widget.otparg.email;
            frompath = widget.otparg.from;

            ////("email");
            ////(email.toString());

            ////("from");
            ////(frompath.toString());

            // _loadingNotifier?.isLoading = true;
            CommonResponse? response = await ApiService().execute<CommonResponse>(
              "tokenverifycustomer/$email/$otp",
              isGet: true,
              isAddCustomerToUrl: false,
              loadingNotifier: _loadingNotifier,
            );

            // _loadingNotifier?.isLoading = false;

            // setState(() {});
            if (response != null && response.status) {
              if (frompath == "register") {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              } else {
                Navigator.of(context).pushReplacementNamed("/changepassword", arguments: email);
              }
            }
          }
        },
        child: Text("Verify", textAlign: TextAlign.center, style: style.copyWith(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: const Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LoginBanner(),
            const SizedBox(
              height: 15,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                      child: TextFieldWithPadding(
                        hintText: "Enter the OTP",
                        labelText: "OTP",
                        iconData: Icons.phone_android,
                        onSaved: (newValue) => otp = newValue ?? "",
                        validator: (value) {
                          if ((value ?? "").trim().isEmpty) {
                            return 'This field is required';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Align(
                alignment: Alignment.centerRight,
                child: ChangeNotifierProvider<CounterNotifier>.value(value: _counterNotifier, child: _OtpTimer(_resendOtp))),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 5, 16, 5),
              child: loginButon,
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 30),
          ],
        ),
      ).setScreenLoader<OtpLoadingNotifier>(),
    );
  }

  void _resendOtp() async {
    ApiService().showToast('Resending OTP');
    //_loadingNotifier?.isLoading = true;
    CommonResponse? response = await ApiService().execute<CommonResponse>(
      "resend-customer-otp",
      isAddCustomerToUrl: false,
      params: {'email': widget.otparg.email},
      loadingNotifier: _loadingNotifier,
    );
    if (response != null && response.status) {}
    _loadingNotifier?.isLoading = false;
    _counterNotifier.nextCounter(() => _startTimeout());
  }

  final CounterNotifier _counterNotifier = CounterNotifier();

  Timer? _timer;
  OtpLoadingNotifier? _loadingNotifier;
  @override
  void initState() {
    _startTimeout();
    _loadingNotifier = Provider.of<OtpLoadingNotifier>(context, listen: false);
    _loadingNotifier?.reset();
    super.initState();
  }

  void _timerCounting(timer) {
    // ////(timer.tick);
    _counterNotifier.currentSecond = timer.tick;
    if (timer.tick >= _counterNotifier.timerMaxSeconds) {
      timer.cancel();
    }
  }

  _startTimeout() {
    _timer?.cancel();
    _counterNotifier.reset();
    _timer = Timer.periodic(const Duration(seconds: 1), _timerCounting);
  }

  @override
  void dispose() {
    ////('_OtpTimer dispose');
    _timer?.cancel();
    _counterNotifier.dispose();
    super.dispose();
  }
}

class _OtpTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _provider = context.watch<CounterNotifier>();
    return _provider.isMaximumTryed
        ? SizedBox()
        : _provider.currentSecond >= _provider.timerMaxSeconds
            ? TextButton(onPressed: () => _resendOtp(), child: Text('Resend OTP'))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                child: Text('${_provider.timerMaxSeconds - _provider.currentSecond} Seconds'),
              );
  }

  final Function() _resendOtp;
  const _OtpTimer(this._resendOtp, {Key? key}) : super(key: key);
}
