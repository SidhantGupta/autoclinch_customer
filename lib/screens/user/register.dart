import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/otp_arguments.dart';
import 'package:autoclinch_customer/network/model/register_response.dart';
import 'package:autoclinch_customer/utils/extensions.dart';
import 'package:autoclinch_customer/widgets/user/password_field.dart';
import 'package:autoclinch_customer/widgets/user/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/widgets/user/login_banner.dart';
import '../../notifiers/loader_notifier.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle style = TextStyle(fontSize: 14.0);

  final TextStyle labelTextstyle = TextStyle(fontSize: 14.0);

  late OTPArg otparg;

  RegisterLoadingNotifier? _registerLoadingNotifier;

  @override
  void initState() {
    _registerLoadingNotifier = Provider.of<RegisterLoadingNotifier>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String email = "", name = "", phoneNo = "", password = "", confirmPassword = "";

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
            // /ranjithkadumeni@gmail.com/9656928494/12345678

            Map<dynamic, dynamic> regIp = {
              'name': "$name",
              'email': "$email",
              'mobile': "$phoneNo",
              'password': "$password",
              'c_password': "$confirmPassword",
              'user_type': 'customer'
            };

            // ,password:$password,c_password:$confirmPassword"

            RegisterResponse? response = await ApiService().execute<RegisterResponse>(
              "customer-register",
              params: regIp,
              isAddCustomerToUrl: false,
              loadingNotifier: _registerLoadingNotifier,
            );
            if (response != null && response.status) {
              ////("Response success and status");
              ////(response.status.toString());

              otparg = new OTPArg(email: email, from: "register");

              Navigator.of(context).pushNamed("/otp", arguments: otparg);
            }
          }
        },
        child: Text("Register", textAlign: TextAlign.center, style: style.copyWith(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
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
              child: Card(
                margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    TextFieldWithPadding(
                      hintText: "Enter your name",
                      labelText: 'Name',
                      iconData: Icons.phone_android,
                      onSaved: (newValue) => name = newValue ?? "",
                      validator: (value) {
                        if ((value ?? "").trim().isEmpty) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                    ),
                    const Divider(),
                    TextFieldWithPadding(
                      hintText: "Enter your email id",
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
                    const Divider(),
                    TextFieldWithPadding(
                      hintText: "Enter your mobile number",
                      labelText: 'Phone Number',
                      prefixText: '+91 ',
                      maxLength: 10,
                      iconData: Icons.phone_android,
                      onSaved: (newValue) => phoneNo = newValue ?? "",
                      validator: (value) {
                        if ((value ?? "").trim().isEmpty) {
                          return 'This field is required';
                        } else if ((value ?? "").trim().length != 10) {
                          return 'Please enter valid phone number';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const Divider(),
                    PasswordField(
                      hintText: "Password",
                      labelText: "Password",
                      iconData: Icons.lock_outline,
                      onSaved: (newValue) => password = newValue ?? "",
                      validator: (value) {
                        if ((value ?? "").trim().isEmpty) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const Divider(),
                    TextFieldWithPadding(
                      hintText: "Confirm Password",
                      labelText: "Confirm Password",
                      iconData: Icons.lock_outline,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSaved: (newValue) => confirmPassword = newValue ?? "",
                      validator: (value) {
                        if ((value ?? "").trim().isEmpty) {
                          return 'This field is required';
                          // } else if ((value ?? "") != password) {
                          //   return 'Password does not match';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 5, 16, 5),
              child: loginButon,
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'You already have an account?',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ).setScreenLoader<RegisterLoadingNotifier>(),
    );
  }
}
