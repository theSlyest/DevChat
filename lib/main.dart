import 'package:flutter/material.dart';
import 'package:seclot/utils/routes_utils.dart';
import 'package:seclot/views/funding/fund_wallet.dart';
import 'package:seclot/views/history.dart';
import 'package:seclot/views/Ice.dart';
import 'package:seclot/views/payment.dart';
import 'package:seclot/views/retract_message.dart';
import 'package:seclot/views/subscription.dart';
import 'package:seclot/views/auth_screen.dart';
import 'package:seclot/views/create_profile.dart';
import 'package:seclot/views/home.dart';
import 'package:seclot/views/auth/login_screen.dart';
import 'package:seclot/views/new_user.dart';
import 'package:seclot/views/auth/otp.dart';
import 'package:seclot/views/auth/phone_auth_screen.dart';
import 'package:seclot/views/splash.dart';
import 'package:seclot/views/view_profile.dart';
import 'package:seclot/views/wallet_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: RoutUtils.splash,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.black,
      accentColor: Colors.grey,
    ),

    routes: {
      // When we navigate to the "/" route, build the FirstScreen Widget
      RoutUtils.splash: (context) => SplashScreen(),
      RoutUtils.login: (context) => LoginScreen(),
      RoutUtils.auth: (context) => AuthScreen(),
      RoutUtils.home: (context) => HomeScreen(),
      RoutUtils.create_profile: (context) => CreateProfileScreen(),
      RoutUtils.view_profile: (context) => ViewProfile(),
      RoutUtils.ices: (context) => IceScreen(),
      RoutUtils.wallet: (context) => WalletScreen(),
      RoutUtils.payment: (context) => PaymentScreen(),
      RoutUtils.subscription: (context) => SubscriptionScreen(),
      RoutUtils.retract_message: (context) => RetractScreen(),
      RoutUtils.history: (context) => HistoryScreen(),
      RoutUtils.new_user: (context) => NewUserScreen(),
      RoutUtils.fund_wallet: (context) => FundWalletScreen(),
    },

//        home: AuthScreen(),
  ));
}
