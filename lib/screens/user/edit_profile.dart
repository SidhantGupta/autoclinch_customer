import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/common_response.dart';
import 'package:autoclinch_customer/network/model/login_response.dart';
import 'package:autoclinch_customer/notifiers/loader_notifier.dart';
import 'package:autoclinch_customer/widgets/user/password_field.dart';
import 'package:autoclinch_customer/widgets/user/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utils/constants.dart' show blueTextColor;
import '/utils/extensions.dart';

class EditProfileScreen extends StatefulWidget {
  final LoginData? _userData;

  EditProfileScreen(this._userData, {Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _textStyle = TextStyle(color: blueTextColor);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _confmPasswordController =
      TextEditingController();

  String _name = '', _address = '', _mobile = '';

  String _oldPaswd = '', _newPaswd = '', _cnfmPaswd = '';

  EditProfileLoadingNotifier? _loadingNotifier;

  final FocusNode _nameFocus = FocusNode(),
      _mobileFocus = FocusNode(),
      _addressFocus = FocusNode(),
      _oldPaswdFocus = FocusNode(),
      _newPaswdFocus = FocusNode(),
      _confmPaswdFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    _loadingNotifier =
        Provider.of<EditProfileLoadingNotifier>(context, listen: false);
    final _titleStyle =
        _textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16);
    final _descStyle = _textStyle.copyWith(fontSize: 11);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text('Profile',
            style: TextStyle(color: Theme.of(context).primaryColor)),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Profile details', style: _titleStyle),
                    // Text('Change the following details and save them',
                    //     style: _descStyle),
                    TextFieldWithPadding(
                      hintText: "Full Name",
                      labelText: "Full Name",
                      initialValue: widget._userData?.name,
                      focusNode: _nameFocus,
                      onFieldSubmitted: (_) =>
                          _fieldFocusChange(context, _nameFocus, _mobileFocus),
                      iconData: Icons.person_outline,
                      onSaved: (newValue) => _name = newValue ?? "",
                      validator: (value) {
                        if ((value ?? "").trim().isEmpty) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                    ).card,
                    TextFieldWithPadding(
                      hintText: "Email",
                      labelText: "Email",
                      readOnly: true,
                      iconData: Icons.alternate_email,
                      initialValue: widget._userData?.email,
                      keyboardType: TextInputType.emailAddress,
                    ).card,
                    TextFieldWithPadding(
                      hintText: "Enter your mobile number",
                      labelText: 'Phone number',
                      prefixText: '+91 ',
                      maxLength: 10,
                      focusNode: _mobileFocus,
                      onFieldSubmitted: (_) => _fieldFocusChange(
                          context, _mobileFocus, _addressFocus),
                      iconData: Icons.phone_android,
                      initialValue: widget._userData?.mobile,
                      onSaved: (newValue) => _mobile = newValue ?? "",
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
                    ).card,
                    TextFieldWithPadding(
                      hintText: "Address",
                      labelText: "Address",
                      focusNode: _addressFocus,
                      initialValue: widget._userData?.address,
                      textInputAction: TextInputAction.done,
                      iconData: Icons.map_outlined,
                      onSaved: (newValue) => _address = newValue ?? "",
                      validator: (value) {
                        if ((value ?? "").trim().isEmpty) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                    ).card,
                    const SizedBox(height: 10),
                    Text('Change Password', style: _titleStyle),
                    // Text(
                    //   'Fill your old password and type new password and confirm it',
                    //   style: _descStyle,
                    // ),
                    const SizedBox(height: 8),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            PasswordField(
                              focusNode: _oldPaswdFocus,
                              onFieldSubmitted: (_) => _fieldFocusChange(
                                  context, _oldPaswdFocus, _newPaswdFocus),
                              controller: _oldPasswordController,
                              hintText: _passwordHint,
                              labelText: "Old Password",
                              iconData: Icons.lock_outline,
                              onSaved: (newValue) => _oldPaswd = newValue ?? "",
                              validator: (value) {
                                if (_confmPasswordController
                                        .text.isNotNullOrEmpty ||
                                    _newPasswordController
                                        .text.isNotNullOrEmpty) {
                                  if ((value ?? "").trim().isEmpty) {
                                    return 'This field is required';
                                  } else {
                                    return null;
                                  }
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Divider(),
                            TextFieldWithPadding(
                              focusNode: _newPaswdFocus,
                              onFieldSubmitted: (_) => _fieldFocusChange(
                                  context, _newPaswdFocus, _confmPaswdFocus),
                              controller: _newPasswordController,
                              hintText: _passwordHint,
                              labelText: "New Password",
                              obscureText: true,
                              iconData: Icons.lock_outline,
                              onSaved: (newValue) => _newPaswd = newValue ?? "",
                              validator: (value) {
                                if (_confmPasswordController
                                        .text.isNotNullOrEmpty ||
                                    _oldPasswordController
                                        .text.isNotNullOrEmpty) {
                                  if ((value ?? "").trim().isEmpty) {
                                    return 'This field is required';
                                  } else {
                                    return null;
                                  }
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const Divider(),
                            TextFieldWithPadding(
                              focusNode: _confmPaswdFocus,
                              controller: _confmPasswordController,
                              hintText: _passwordHint,
                              labelText: "Confirm New Password",
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              iconData: Icons.lock_outline,
                              onSaved: (newValue) =>
                                  _cnfmPaswd = newValue ?? "",
                              validator: (value) {
                                if (_newPasswordController
                                    .text.isNotNullOrEmpty) {
                                  if ((value ?? "").trim().isEmpty) {
                                    return 'This field is required';
                                  } else if ((value ?? "") !=
                                      _newPasswordController.text) {
                                    return 'Password does not match';
                                  } else {
                                    return null;
                                  }
                                } else {
                                  return null;
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            ),
          )),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5, color: Colors.grey, offset: Offset(0, 2))
                ]),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          _formKey.currentState?.save();
                          _updateProfile(context);
                        }
                      },
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    )),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                      // setState(() {});
                    },
                    child: Text(
                      'Reset',
                      style: _textStyle,
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ],
            ),
          )
        ],
      ).setScreenLoader<EditProfileLoadingNotifier>(),
    ).addSafeArea(context: context, color: Colors.white);
  }

  final _passwordHint = '...................';

  void _updateProfile(BuildContext context) async {
    FocusScope.of(context).unfocus();
    _loadingNotifier?.isLoading = true;
    Map<dynamic, dynamic> params = {
      'name': _name,
      'address': _address,
      'mobile': _mobile
    };
// current_password, new_password, confirm_password
    if (_newPaswd.isNotNullOrEmpty &&
        _oldPaswd.isNotNullOrEmpty &&
        _newPaswd == _cnfmPaswd) {
      params.addAll({
        'current_password': _oldPaswd,
        'new_password': _newPaswd,
        'confirm_password': _cnfmPaswd,
      });
    }

    CommonResponse2? response = await ApiService().execute<CommonResponse2>(
      "update-my-profile",
      params: params,
    );
    _loadingNotifier?.isLoading = false;
    if (response != null && response.success) {
      Navigator.of(context).pop(true);
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
