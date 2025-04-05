import 'dart:developer';

import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/login_response.dart';
import 'package:autoclinch_customer/utils/extensions.dart';
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:autoclinch_customer/widgets/user/password_field.dart';
import 'package:autoclinch_customer/widgets/user/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '/notifiers/loader_notifier.dart' show LoginLoadingNotifier;
import '/widgets/user/login_banner.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle style = TextStyle(fontSize: 14.0);

  final TextStyle labelTextstyle = TextStyle(fontSize: 14.0);

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    String email = "", password = "";
    LoginLoadingNotifier _loadingNotifier =
        Provider.of<LoginLoadingNotifier>(context, listen: false);
    _loadingNotifier.reset();
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () async {
          // Navigator.of(context).pushReplacementNamed("/home");
          if (_formKey.currentState?.validate() == true) {
            _formKey.currentState?.save();
            //debugPrint("email: $email   password: $password");
            LoginResponse? response = await ApiService().execute<LoginResponse>(
                "customer-login-new",
                params: {
                  'email': email,
                  'password': password,
                  'user_type': 'customer'
                },
                isAddCustomerToUrl: false,
                loadingNotifier: _loadingNotifier);
            //debugPrint("response: $response");
            if (response != null && response.status) {
              // if (response.data?.firstLogin == true) {
              //   await SharedPreferenceUtil().storeUserDetails(response.data);
              //   Navigator.of(context).pushReplacementNamed("/profiledetails");
              // } else {

              // if (response.data?.isApprove == true) {
              await SharedPreferenceUtil().storeUserDetails(response.data);
              Navigator.of(context).pushReplacementNamed("/home");
              // } else {
              //   ApiService().showToast(response.data?.message.toString());
              // }
              // }
            } else {
              _loadingNotifier.reset(loading: false);
            }
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );

    final cardGoogle = Card(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: InkWell(
          onTap: () async {
            try {
              await _googleSignIn.signIn();
              ////("**1**");

              //(_googleSignIn.currentUser!);
              //(_googleSignIn.currentUser!.id);
              //(_googleSignIn.currentUser!.displayName);
              //(_googleSignIn.currentUser!.email);
              //(_googleSignIn.currentUser!.photoUrl);

              final LoginResponse? response = await ApiService()
                  .execute<LoginResponse>('customer-socialmedia-login',
                      params: {
                        'name': _googleSignIn.currentUser!.displayName,
                        'email': _googleSignIn.currentUser!.email,
                        'photoUrl': _googleSignIn.currentUser!.photoUrl,
                        'id': _googleSignIn.currentUser!.id,
                        // 'customer_ids': '3',
                        'social_media': "google",
                      },
                      loadingNotifier: _loadingNotifier);
              // _loadingNotifier?.isLoading = false;
              if (response != null && response.status) {
                await SharedPreferenceUtil().storeUserDetails(response.data);
                Navigator.of(context).pushReplacementNamed("/home");
              }
            } catch (err) {
              debugPrint(err.toString());
              rethrow;
            }

            ////("Sanoosh Button click printed");
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(7, 10, 7, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/google.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Text("Signin with Google")
              ],
            ),
          ),
        ));

    final cardFacebook = Card(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: InkWell(
        onTap: () async {
          try {
            FacebookAuth.instance.login(permissions: [
              "public_profile",
              "email",
              //    'pages_show_list',
              //   'pages_messaging',
              //   'pages_manage_metadata'
            ]).then((value) {
              FacebookAuth.instance.getUserData().then((userData) async {
                ////("Full Details :" + userData.toString());

                ////("Name : " + userData["name"]);
                ////("Email : " + userData["email"]);

                String? name;
                String? email;
                String? picture;
                String? id;
                name = userData["name"];
                email = userData["email"];
                picture = userData["photoUrl"];
                id = userData["id"];

                // ssoLogin(email, name, picture, id, "facebook");

                final LoginResponse? response = await ApiService()
                    .execute<LoginResponse>('customer-socialmedia-login',
                        params: {
                          'name': name,
                          'email': email,
                          'photoUrl': picture,
                          'id': id,
                          // 'customer_ids': '3',
                          'social_media': "facebook",
                        },
                        loadingNotifier: _loadingNotifier);
                // _loadingNotifier?.isLoading = false;
                if (response != null && response.status) {
                  await SharedPreferenceUtil().storeUserDetails(response.data);
                  Navigator.of(context).pushReplacementNamed("/home");
                }
              });
            });
          } catch (err) {
            log(err.toString());
          }

          ////("Facebook Button click printed");
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(7, 10, 7, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/facebook.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Text("Sign in with Facebook")
            ],
          ),
        ),
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
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch((value ?? ""))) {
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

                  // const SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/forgotpassword"),
                  child: Text('Forgot Password?',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      )),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 5, 16, 5),
              child: loginButon,
            ),
            cardGoogle,
            cardFacebook,
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => Navigator.of(context).pushNamed("/register"),
                child: Text(
                  'You don\'t have an account?',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ).setScreenLoader<LoginLoadingNotifier>(),
    );
  }

  ssoLogin(String? email, String? name, String? id, String? photoUrl,
      String? socialMediaType) {}
}
