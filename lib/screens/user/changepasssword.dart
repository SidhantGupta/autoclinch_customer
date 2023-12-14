import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/forgot_pwd_response.dart';
import 'package:autoclinch_customer/utils/extensions.dart';
import 'package:autoclinch_customer/widgets/user/password_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/notifiers/loader_notifier.dart' show LoginLoadingNotifier;
import '/widgets/user/login_banner.dart';

class ChangePasswordScreen extends StatelessWidget {
  final email;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextStyle style = TextStyle(fontSize: 14.0);
  final TextStyle labelTextstyle = TextStyle(fontSize: 14.0);

  ChangePasswordScreen({Key? key, @required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String password = "", cPassword = "";
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
            //debugPrint("email: $email   password: $password");
            ForgotPasswordResponse? response = await ApiService().execute<ForgotPasswordResponse>("password/new-password-customer",
                params: {'email': "$email", 'password': "$password", 'c_password': "$cPassword"}, loadingNotifier: _loadingNotifier);
            //debugPrint("response: $response");
            if (response != null && response.status) {
              Navigator.of(context).pushReplacementNamed("/login");
            }
          }
        },
        child: Text("Submit", textAlign: TextAlign.center, style: style.copyWith(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
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
                      child: PasswordField(
                        hintText: "Password",
                        labelText: "Password",
                        iconData: Icons.lock_outline,
                        textInputAction: TextInputAction.done,
                        onSaved: (newValue) => password = newValue ?? "",
                        validator: (value) {
                          if ((value ?? "").trim().isEmpty) {
                            return 'This field is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),

                  // const Divider(),

                  Card(
                    margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                      child: PasswordField(
                        hintText: "Confirm Password",
                        labelText: "Confirm Password",
                        iconData: Icons.lock_outline,
                        textInputAction: TextInputAction.done,
                        onSaved: (newValue) => cPassword = newValue ?? "",
                        validator: (value) {
                          if ((value ?? "").trim().isEmpty) {
                            return 'This field is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),

                  // const SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
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
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ).setScreenLoader<LoginLoadingNotifier>(),
    );
  }
}
