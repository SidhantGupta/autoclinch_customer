import 'package:autoclinch_customer/network/model/login_response.dart';
import 'package:autoclinch_customer/network/model/vehicle_arguments.dart';
import 'package:autoclinch_customer/screens/hel_faq.dart';
import 'package:autoclinch_customer/screens/home/addreview_screen.dart';
import 'package:autoclinch_customer/screens/home/addvehicle_screen.dart';
import 'package:autoclinch_customer/screens/home/allreviews_screen.dart';
import 'package:autoclinch_customer/screens/home/home_main.dart';
import 'package:autoclinch_customer/screens/home/mobile_number_register.dart';
import 'package:autoclinch_customer/screens/home/payment_screen.dart';
import 'package:autoclinch_customer/screens/home/payment_screen_outstanding.dart';
import 'package:autoclinch_customer/screens/home/sos_screen.dart';
import 'package:autoclinch_customer/screens/home/track_vendor.dart';
import 'package:autoclinch_customer/screens/home/vendordetails_screen.dart';
import 'package:autoclinch_customer/screens/home/vendors_list_screen.dart';
import 'package:autoclinch_customer/screens/user/edit_profile.dart';
import 'package:autoclinch_customer/screens/user/forgotpassword.dart';
import 'package:autoclinch_customer/screens/user/otp.dart';
import 'package:flutter/material.dart';

import 'network/model/booking_args.dart';
import 'network/model/otp_arguments.dart';
import 'screens/home/countdown_screen.dart';
import 'screens/home/vehiclelist_screen.dart';
import 'screens/user/changepasssword.dart';
import 'screens/user/login.dart';
import 'screens/user/register.dart';

class Routes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeMainScreen(id: settings.arguments as String?));
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/otp':
        return MaterialPageRoute(builder: (_) => OtpScreen(otparg: settings.arguments as OTPArg));

      case '/mobile-verify':
        return MaterialPageRoute(builder: (_) => MobileRegister());

      case '/forgotpassword':
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());

      case '/vendordetails':
        return MaterialPageRoute(builder: (_) => VendorDetailsScreen(settings.arguments as String));

      case '/paymentscreen':
        return MaterialPageRoute(builder: (_) => PaymentScreen(settings.arguments as PaymentIntentData?));

      case '/payment_outstanding_screen':
        return MaterialPageRoute(
            builder: (_) => PaymentScreenForOutstanding(settings.arguments as PaymentOutstandingIntentData));

      case '/vehiclelistscreen':
        return MaterialPageRoute(builder: (_) => VehicleListScreen());

      case '/addvehiclescreen':
        return MaterialPageRoute(builder: (_) => AddVehicleScreen(vehiclearg: settings.arguments as VehicleArg?));

      case '/allreviewscreen':
        return MaterialPageRoute(builder: (_) => AllReviewsScreen(id: settings.arguments as String));

      case '/changepassword':
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen(email: settings.arguments));

      case '/edit_profile':
        return MaterialPageRoute(builder: (_) => EditProfileScreen(settings.arguments as LoginData?));

      case '/help_faq':
        return MaterialPageRoute(builder: (_) => HelpAndFaqScreen());

      case '/countdown':
        return MaterialPageRoute(
            builder: (_) => CountDownScreen(
                  intentData: settings.arguments as TimerIntentData?,
                ));

      case '/trackvendor':
        return MaterialPageRoute(builder: (_) => VendorTrackingScreen(settings.arguments as TrackingIntent));

      case '/add_review':
        return MaterialPageRoute(builder: (_) => AddReviewScreen(booking_arg: settings.arguments as BookingArg?));
      case '/vendors':
        return MaterialPageRoute(builder: (_) => VendorListScreen());
      case '/sos':
        return MaterialPageRoute(builder: (_) => SOSScreen(isFromTab: false));
      // case '/rating':
      //   MaterialPageRoute(builder: (_) => RatingScreen());
    }
    return null;
  }
}
