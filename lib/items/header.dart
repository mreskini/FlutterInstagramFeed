import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_feed/shared/functions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 1),
      child: Container(
        color: Functions().getColorFromHex("FAFAFA"),
        child: Container(
          margin: EdgeInsets.only(
            right: 15,
            left: 11,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 25,
                      height: 25,
                      child: Image.asset(
                        "./lib/assets/logo.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 7),
                      height: 25,
                      child: Image.asset(
                        "./lib/assets/instagram.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 25,
                      height: 25,
                      child: Image.asset(
                        "./lib/assets/send2.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
