import 'package:flutter/material.dart';
import 'package:seclot/model/ice.dart';

class ContactListTile extends ListTile {
  static var diameter = 50.0;
  static var backgroundColor = Colors.black;

  ContactListTile(IceDTO contact)
      : super(
            title: Text(
              contact.name,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              contact.phoneNumber,
              style: TextStyle(color: Colors.grey),
            ),
            leading: Container(
              width: diameter,
              height: diameter,
              decoration: new BoxDecoration(
                // Circle shape
                shape: BoxShape.circle,
//          color: backgroundColor,
                // The border you want
                border: new Border.all(
                  width: 2.0,
                  color: Colors.grey,
                ),
                // The shadow you want
              ),
              child: Center(
                child: Text(
                  contact.name[0],
                  style: TextStyle(fontSize: 24.0, color: Colors.grey),
                ),
              ),
            ));
}
