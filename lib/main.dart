import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seclot/data_store/bloc/ice_bloc/ice_bloc_provider.dart';
import 'package:seclot/providers/AppStateProvider.dart';
import 'package:seclot/utils/routes_utils.dart';
import 'package:seclot/views/funding/fund_wallet.dart';
import 'package:seclot/views/history.dart';
import 'package:seclot/views/Ice.dart';
import 'package:seclot/views/payment.dart';
import 'package:seclot/views/retract_message.dart';
import 'package:seclot/views/subscription.dart';
import 'package:seclot/views/auth_screen.dart';
import 'package:seclot/views/create_edit_profile.dart';
import 'package:seclot/views/home/home.dart';
import 'package:seclot/views/auth/login_screen.dart';
import 'package:seclot/views/new_user.dart';
import 'package:seclot/views/auth/otp.dart';
import 'package:seclot/views/auth/phone_auth_screen.dart';
import 'package:seclot/views/splash.dart';
import 'package:seclot/views/view_profile.dart';
import 'package:seclot/views/wallet_screen.dart';

void main() {
  runApp( App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => AppStateProvider()),
      ],
      child: IceProvider(
        child: MaterialApp(
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
//            RoutUtils.new_user: (context) => NewUserScreen(),
            RoutUtils.fund_wallet: (context) => FundWalletScreen(),
          },
//        home: AuthScreen(),
        ),
      )
    );
  }
}



