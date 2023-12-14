import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:autoclinch_customer/network/api_service.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../notifiers/loader_notifier.dart';

class MobileRegister extends StatefulWidget {
  const MobileRegister({Key? key}) : super(key: key);

  @override
  State<MobileRegister> createState() => _MobileRegisterState();
}

class _MobileRegisterState extends State<MobileRegister> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: <Widget>[
            MobileForm(pageController: _pageController),
            OtpForm(),
          ],
        ),
      ),
    );
  }
}

class MobileForm extends StatefulWidget {
  final PageController pageController;
  MobileForm({Key? key, required this.pageController}) : super(key: key);

  @override
  State<MobileForm> createState() => _MobileFormState();
}

class _MobileFormState extends State<MobileForm> {
  final TextEditingController mobileController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginLoadingNotifier _loadingNotifier = Provider.of<LoginLoadingNotifier>(context, listen: false);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter Your Phone \nNumber',
              style: theme.textTheme.headline4?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your phone number';
                } else if (value.length != 10) {
                  return ' Please enter a valid phone number';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                primary: Color.fromARGB(255, 244, 132, 32),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_loadingNotifier.isLoading) return;
                  sendMobile(_loadingNotifier);
                }
              },
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  sendMobile(LoginLoadingNotifier loadingNotifier) async {
    Map body = {'social_phone': mobileController.text};
    final prefs = await SharedPreferences.getInstance();
    setLoading(true);
    try {
      ApiService()
          .execute(
        'post-social-phone',
        isGet: false,
        params: body,
        loadingNotifier: loadingNotifier,
      )
          .then((value) {
        setLoading(false);
        if (value != null) {
          var json = jsonEncode(value);
          var data = jsonDecode(json);
          bool isTrue = data['status'];
          if (isTrue) {
            //
            prefs.setString('social_phone', mobileController.text);
            widget.pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        }
      });
    } catch (e) {
      setLoading(false);
      log(e.toString());
    }
  }
}

class OtpForm extends StatefulWidget {
  OtpForm({Key? key}) : super(key: key);

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final StreamController<ErrorAnimationType> _errorController = StreamController<ErrorAnimationType>();

  String? _otp;

  String? mobile;

  bool isLoading = false;

  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  getMobile() async {
    final prefs = await SharedPreferences.getInstance();
    mobile = prefs.getString('social_phone') ?? '';
    setState(() {});
  }

  @override
  void initState() {
    getMobile();
    super.initState();
  }

  @override
  void dispose() {
    _errorController.close();
    timer?.cancel();

    super.dispose();
  }

  int time = 30;
  bool isTimerRunning = false;
  Timer? timer;
  void startTimer() {
    if (isTimerRunning) return;
    const oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (time < 1) {
          timer.cancel();
          isTimerRunning = false;
          time = 30;
        } else {
          isTimerRunning = true;
          time = time - 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginLoadingNotifier _loadingNotifier = Provider.of<LoginLoadingNotifier>(context, listen: false);
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Verification Code',
              style: theme.textTheme.headline3?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Enter the verification code we just sent to +91$mobile',
              style: theme.textTheme.subtitle1,
            ),
            const SizedBox(height: 60),
            PinCodeTextField(
              appContext: context,
              errorAnimationController: _errorController,
              showCursor: false,
              length: 6,
              cursorColor: theme.colorScheme.secondary,
              onChanged: (value) {},
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              useExternalAutoFillGroup: true,
              onCompleted: (value) => _otp = value,
              onSubmitted: (value) => _otp = value,
              useHapticFeedback: true,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                activeColor: theme.colorScheme.primary,
                inactiveColor: theme.colorScheme.primary.withOpacity(0.2),
                selectedColor: theme.colorScheme.primary,
                inactiveFillColor: theme.colorScheme.primary.withOpacity(0.2),
                selectedFillColor: theme.colorScheme.primary,
                activeFillColor: theme.colorScheme.primary,
                fieldWidth: 50,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                primary: Color.fromARGB(255, 244, 132, 32),
              ),
              onPressed: () {
                if (_otp != null && _otp!.length == 6) {
                  FocusScope.of(context).unfocus();
                  if (isLoading) return;
                  verifyOtp(_loadingNotifier);
                } else {
                  _errorController.add(ErrorAnimationType.shake);
                }
              },
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text('Continue'),
            ),
            Spacer(),
            Container(
              height: 50,
              child: InkWell(
                onTap: () {
                  if (isTimerRunning) return;
                  resendOtp();
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Didn\'t receive the code? ',
                      style: theme.textTheme.subtitle1,
                      children: [
                        TextSpan(
                          text: isTimerRunning ? 'Resend in $time seconds' : 'Resend',
                          style: theme.textTheme.subtitle1?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  verifyOtp(LoadingNotifier loadingNotifier) {
    Map body = {'otp': _otp};
    setLoading(true);
    try {
      ApiService()
          .execute(
        'verify-social-phone',
        isGet: false,
        params: body,
        loadingNotifier: loadingNotifier,
      )
          .then((value) {
        if (value != null) {
          setLoading(false);
          var json = jsonEncode(value);
          var data = jsonDecode(json);
          bool isTrue = data['status'];
          if (isTrue == true) {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          } else if (isTrue == false) {
            _errorController.add(ErrorAnimationType.shake);
          }
        }
      });
    } catch (e) {
      setLoading(false);
      log(e.toString());
    }
  }

  resendOtp() {
    startTimer();
    Map body = {'mobile': mobile};
    ApiService().execute('resend-social-phone', isGet: false, params: body);
  }
}
