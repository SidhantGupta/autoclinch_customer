import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/common_response.dart';
import 'package:autoclinch_customer/network/model/login_response.dart';
import 'package:autoclinch_customer/utils/extensions.dart';
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:autoclinch_customer/widgets/user/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '/notifiers/loader_notifier.dart' show ProfileLoadingNotifier;

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  final void Function(int) navigationHelper;
  ProfileScreen(this.navigationHelper, {Key? key}) : super(key: key);
  final List<_ProfileMenu> _profileMenus = List.of({
    _ProfileMenu(
        iconData: Icons.paste_sharp, title: 'My Bookings', routeName: null),
    _ProfileMenu(
        iconData: Icons.person_outline_outlined,
        title: 'Edit Profile',
        routeName: '/edit_profile'),

    // _ProfileMenu(
    //     iconData: Icons.notifications_outlined,
    //     title: 'Notification',
    //     routeName: '/notification'),
    // _ProfileMenu(
    //     iconData: Icons.settings_outlined,
    //     title: 'Settings',
    //     routeName: '/settings'),

    _ProfileMenu(
        iconData: Icons.help_outline,
        title: 'Vehicle List',
        routeName: '/vehiclelistscreen'),
    _ProfileMenu(
        iconData: Icons.logout, title: 'Emergency Contact', routeName: null),

    _ProfileMenu(
        iconData: Icons.help_outline,
        title: 'Help & FAQ',
        routeName: '/help_faq'),
    _ProfileMenu(
        iconData: Icons.phone_outlined,
        title: 'Contact Customer Care',
        routeName: null),
    _ProfileMenu(iconData: Icons.logout, title: 'Logout', routeName: null),
  }, growable: false);

  ProfileLoadingNotifier? _loadingNotifier;

  LoginData? _profileData;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _profileApi({bool isWantApicall = false}) async {
    if (!isWantApicall && _profileData != null) {
      return;
    }
    // _loadingNotifier?.isLoading = true;
    final LoginResponse? response = await ApiService().execute<LoginResponse>(
      'get-my-profile',
      isGet: true,
      loadingNotifier: _loadingNotifier,
    );
    _profileData = response?.data;
    // _loadingNotifier?.isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    _loadingNotifier =
        Provider.of<ProfileLoadingNotifier>(context, listen: false);
    _loadingNotifier?.reset(loading: false);
    _profileApi();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text('Account'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 120.0,
                    width: double.infinity,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
              SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      Icon(
                        CupertinoIcons.person_alt_circle,
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Consumer<ProfileLoadingNotifier>(
                          builder: (context, value, child) => Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_profileData?.name ?? 'Name',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white)),
                              const SizedBox(height: 3),
                              Text(_profileData?.email ?? 'Name@gmail.com',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      // Card(
                      //   color: Colors.white,
                      //   clipBehavior: Clip.antiAliasWithSaveLayer,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(5),
                      //     child: ClipRRect(
                      //       borderRadius: BorderRadius.circular(8.0),
                      //       child: Container(
                      //           height: 70, width: 70, color: Colors.yellow),
                      //       // child: FadeInImage.assetNetwork(
                      //       //   placeholder: placeholder,
                      //       //   image: image,
                      //       //   height: 70,
                      //       //   width: 70,
                      //       // ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ],
          ),
          Card(
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _profileMenus.length,
                  itemBuilder: (context, index) {
                    final _ProfileMenu _profileMenu = _profileMenus[index];
                    return InkWell(
                      onTap: () async {
                        if (_profileMenu.routeName != null) {
                          final success = await Navigator.pushNamed(
                              context, _profileMenu.routeName!,
                              arguments: _profileData);
                          ////('Navigator result: $success');
                          if (success is bool && success) {
                            _profileApi(isWantApicall: true);
                          }
                        } else if (_profileMenu.title == 'Logout') {
                          _logout(context);
                        } else if (_profileMenu.title == 'Emergency Contact') {
                          _showBottomSheet(context);
                        } else if (_profileMenu.title ==
                            'Contact Customer Care') {
                          var url = 'tel:+919953105456';
                          var uri = Uri.parse(url);
                          if (await launchUrl(uri)) {
                            launchUrl(uri);
                          } else {
                            throw 'Could not launch';
                          }
                        } else {
                          navigationHelper(1);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Icon(_profileMenu.iconData,
                                  color: Theme.of(context).primaryColor),
                              const SizedBox(width: 10),
                              const VerticalDivider(
                                  color: Colors.grey, thickness: 1),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text(
                                _profileMenu.title,
                                style: TextStyle(
                                  color: Color(0xFF2A2935),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              )),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(height: 0),
        ],
      ).setScreenLoader<ProfileLoadingNotifier>(),
    ).addSafeArea(context: context, color: Colors.red);
  }

  void _logout(BuildContext context) async {
    String? newtaT;

    newtaT = await SharedPreferenceUtil().getToken();

    CommonResponse2? response = await ApiService().execute<CommonResponse2>(
      "device-token-delete",
      params: {
        'deviceToken': newtaT,
      },
      // isAddCustomerToUrl: false,
    );
    //debugPrint("response: $response");
    if (response != null && response.success) {
      await SharedPreferenceUtil().storeUserDetails(null);
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    String name = "", phone = "";
    final TextEditingController _controller = TextEditingController();

    String? newtaT;

    name = await SharedPreferenceUtil().getEmergencyName();
    phone = await SharedPreferenceUtil().getEmergencyNumber();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          color: Color(0xff757575),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFieldWithPadding(
                    hintText: "Name of Emergency Contact",
                    labelText: 'Emergency Contact Name',
                    initialValue: name,
                    iconData: Icons.list_alt_outlined,
                    onSaved: (newValue) => name = newValue ?? "",
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
                    hintText: "Contact No.",
                    labelText: 'Contact No of Emergency Contact',
                    initialValue: phone,
                    iconData: Icons.phone_android,
                    onSaved: (newValue) => phone = newValue ?? "",
                    maxLength: 10,
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
                  ElevatedButton(
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == false) {
                        return;
                      }
                      _formKey.currentState?.save();

                      await SharedPreferenceUtil().storeEmergencyName(name);
                      await SharedPreferenceUtil().storeEmergencyNumber(phone);

                      Navigator.pop(context);
                    },
                  ),
                  //photos of business
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileMenu {
  final IconData iconData;
  final String title;
  final String? routeName;

  _ProfileMenu(
      {required this.iconData, required this.title, required this.routeName});
}
