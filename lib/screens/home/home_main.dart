import 'package:autoclinch_customer/custom/bottom_navy_bar.dart';
import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/common_response.dart';
import 'package:autoclinch_customer/screens/home/bookings_screen.dart';
import 'package:autoclinch_customer/screens/home/home_screen.dart';
import 'package:autoclinch_customer/screens/home/profile.dart';
import 'package:autoclinch_customer/screens/home/sos_screen.dart';
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:flutter/material.dart';

import '../../network/model/login_response.dart';

class HomeMainScreen extends StatefulWidget {
  late final String? id;

  HomeMainScreen({this.id});

  // HomeMainScreen({Key? key, this.id}) : super(key: key);

  @override
  _HomeMainScreenState createState() => _HomeMainScreenState(id);
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  LoginData? _profileData;

  @override
  void initState() {
    super.initState();

    if (_id != null) {
      _currentIndex = 1;
    } else {
      _currentIndex = 0;
    }
    getUser();
    sendToken();
  }

  getUser() async {
    await ApiService()
        .execute<LoginResponse>(
      'get-my-profile',
      isGet: true,
    )
        .then((response) {
      if (response == null) return;
      _profileData = response.data;
      if (_profileData?.socialMedia == null || _profileData!.socialMedia!.isNotEmpty) {
        if (_profileData?.socialPhone == null || _profileData!.socialPhone!.isEmpty) {
          Navigator.of(context).pushReplacementNamed('/mobile-verify');
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _HomeMainScreenState([this._id]) {
    _widgetOptions = <Widget>[
      HomeScreen(selectionNavigation),
      BookingScreen(id: _id),
      SOSScreen(),
      ProfileScreen(selectionNavigation),
      Container(color: Colors.green),
    ];
  }

  String? _id;

  int _currentIndex = 0;

  final PageController _pageController = PageController();
  late final List<Widget> _widgetOptions;

  void selectionNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          ////('onItemSelected onitem selected');
          _currentIndex = index;
          // _pageController.animateToPage(index,
          //     duration: Duration(milliseconds: 300), curve: Curves.ease);
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home_outlined),
            title: Text('Home'),
            activeColor: Theme.of(context).primaryColor,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.paste_sharp), title: Text('Booking'), activeColor: Theme.of(context).primaryColor),
          BottomNavyBarItem(icon: Icon(Icons.message), title: Text('SOS'), activeColor: Theme.of(context).primaryColor),
          BottomNavyBarItem(
              icon: Icon(Icons.person_outline), title: Text('Profile'), activeColor: Theme.of(context).primaryColor),
        ],
      ),
      // body: SizedBox.expand(
      //   child: PageView(
      //     controller: _pageController,
      //     onPageChanged: (index) {
      //       setState(() => _currentIndex = index);
      //     },
      //     children: _widgetOptions,
      //   ),
      // ),
      body: _widgetOptions[_currentIndex],
    );
  }

  sendToken() async {
    var user = await SharedPreferenceUtil().getUserDetails();
    String routeName;
    if (user?.token != null && user!.token!.trim().isNotEmpty) {
      // routeName = "/vendordetails";

      String? newtaT;

      newtaT = await SharedPreferenceUtil().getToken();

      ////(newtaT);

      CommonResponse2? response = await ApiService().execute<CommonResponse2>(
        "customerapp/device-token-register",
        params: {
          'deviceToken': newtaT,
        },
        isAddCustomerToUrl: false,
      );
      //debugPrint("response: $response");
      if (response != null && response.success) {
        ////("Token Send successfully");
      }
    }
  }
}
