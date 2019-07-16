import 'package:flutter/material.dart';
import 'ice_bloc.dart';

class IceProvider extends InheritedWidget {
  final IceBloc bloc;

  IceProvider({Key key, Widget child})
      : bloc = IceBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static IceBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(IceProvider) as IceProvider)
        .bloc;
  }
}
