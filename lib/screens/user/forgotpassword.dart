import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/forgot_pwd_response.dart';
import 'package:autoclinch_customer/network/model/otp_arguments.dart';
import 'package:autoclinch_customer/utils/extensions.dart';
import 'package:autoclinch_customer/widgets/user/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/notifiers/loader_notifier.dart' show LoginLoadingNotifier;
import '/widgets/user/login_banner.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
 static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle style = TextStyle(fontSize: 14.0);

  final TextStyle labelTextstyle = TextStyle(fontSize: 14.0);

  late OTPArg otparg;

  @override
  Widget build(BuildContext context) {
    String email = "";
    LoginLoadingNotifier _loadingNotifier = Provider.of<LoginLoadingNotifier>(context, listen: false);
    _loadingNotifier.reset();
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
            //debugPrint("email: $email");
            ForgotPasswordResponse? response = await ApiService().execute<ForgotPasswordResponse>("password/forgot-password-customer",
                params: {'email': "$email"}, loadingNotifier: _loadingNotifier, isAddCustomerToUrl: false);
            //debugPrint("response: $response");
            if (response != null && response.status) {
              otparg = new OTPArg(email: email, from: "forgotpassword");

              Navigator.of(context).pushNamed("/otp", arguments: otparg);
            }
          }
        },
        child: Text("Next", textAlign: TextAlign.center, style: style.copyWith(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
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
                        hintText: "Email id",
                        labelText: "Email Address",
                        iconData: Icons.alternate_email,
                        onSaved: (newValue) => email = newValue ?? "",
                        validator: (value) {
                          if ((value ?? "").trim().isEmpty) {
                            return 'This field is required';
                          } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch((value ?? ""))) {
                            return 'Invalid email';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),

                  // const Divider(),

                  // const SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 5, 16, 5),
              child: loginButon,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ).setScreenLoader<LoginLoadingNotifier>(),
    );
  }
}
