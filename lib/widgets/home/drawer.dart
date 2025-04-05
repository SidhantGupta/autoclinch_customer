import 'package:autoclinch_customer/network/model/login_response.dart';
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:flutter/material.dart';

class DrawerMenus extends StatelessWidget {
  final LoginData? user;
  final ValueChanged<String>? drawerSelected;
  DrawerMenus({Key? key, this.user, this.drawerSelected}) : super(key: key);

  // final List<DrawerModel> _drawerMenus = List.empty();

  final List<DrawerModel> _drawerMenus = List.of({
    DrawerModel(
        iconData: Icons.account_circle_outlined,
        title: 'Profile',
        route: '/profile',
        isTab: true),
    DrawerModel(iconData: Icons.history, title: 'History', route: '/history'),
    DrawerModel(
        iconData: Icons.contact_support_outlined,
        title: 'Contact Us',
        route: '/contact-us'),
    DrawerModel(
        iconData: Icons.policy_outlined,
        title: 'Terms and Conditions',
        route: '/terms'),
    DrawerModel(
        iconData: Icons.privacy_tip, title: 'Privacy Policy', route: '/policy'),
    DrawerModel(
        iconData: Icons.settings_outlined,
        title: 'Settings',
        route: '/settings'),
  }, growable: false);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
          child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Color(0xFFE2E1E7),
            padding: EdgeInsets.fromLTRB(10, 50, 10, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                Text(user?.name ?? 'Login account or create new one for free'),
                const SizedBox(height: 10),
                user == null
                    ? Row(
                        children: [
                          ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/login');
                              },
                              style: _buttonStyle(context),
                              icon: Icon(Icons.exit_to_app_rounded),
                              label: Text('Login')),
                          const SizedBox(width: 7),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/login');
                            },
                            style: _buttonStyle(context,
                                bgColor: Color(0xFFD1D1DB),
                                txtColor: Color(0xFF271844)),
                            icon: Icon(Icons.person_add_outlined),
                            label: Text(
                              'Register',
                            ),
                          )
                        ],
                      )
                    : ElevatedButton.icon(
                        onPressed: () async {
                          await SharedPreferenceUtil().storeUserDetails(null);
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        style: _buttonStyle(context),
                        icon: Icon(Icons.logout_sharp),
                        label: Text('Logout'))
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _drawerMenus.length,
              // shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final DrawerModel drawer = _drawerMenus[index];
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    if (drawer.isTab && drawerSelected != null) {
                      drawerSelected!(drawer.route);
                    } else {
                      Navigator.of(context).pushNamed(drawer.route);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(drawer.iconData),
                        const SizedBox(width: 5),
                        Text(drawer.title)
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
          ),
        ],
      )),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context, {Color? bgColor, txtColor}) {
    Color _bgColor = bgColor ?? Theme.of(context).primaryColor;
    Color _txtColor = txtColor ?? Colors.white;
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        //  side: BorderSide(color: _bgColor)
      ),
    );
  }
}

class DrawerModel {
  final IconData iconData;
  final String title, route;
  final bool isTab;

  DrawerModel(
      {required this.iconData,
      required this.title,
      required this.route,
      this.isTab = false});
}
