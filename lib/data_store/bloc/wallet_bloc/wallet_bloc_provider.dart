import 'package:flutter/material.dart';
import 'wallet_bloc.dart';

class WalletProvider extends InheritedWidget {
  final WalletBloc bloc;

  WalletProvider({Key key, Widget child})
      : bloc = WalletBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static WalletBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(WalletProvider)
            as WalletProvider)
        .bloc;
  }
}
