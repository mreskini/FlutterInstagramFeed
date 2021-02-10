import 'package:flutter/material.dart';
import 'package:insta_feed/shared/functions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomeNavigationBar extends StatefulWidget {
  bool bookmarked = false;
  String bookmarkImageUrl = "";
  double bottomMargin = -50.0;
  CustomeNavigationBar(
      {this.bookmarked, this.bookmarkImageUrl, this.bottomMargin});
  @override
  _CustomeNavigationBarState createState() => _CustomeNavigationBarState();
}

class _CustomeNavigationBarState extends State<CustomeNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                curve: Curves.bounceOut,
                transform:
                    Matrix4.translationValues(-27.0, widget.bottomMargin, 0.0),
                child: widget.bookmarked
                    ? widget.bookmarkImageUrl == "NULL"
                        ? Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                            ),
                          )
                        : Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(widget.bookmarkImageUrl),
                              ),
                            ),
                          )
                    : Container(),
              ),
            ],
          ),
          BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30, top: 12, bottom: 12),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 25,
                                height: 25,
                                child: Image.asset(
                                  "./lib/assets/home.jpg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 25,
                                height: 25,
                                child: Image.asset(
                                  "./lib/assets/search.jpg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 25,
                                height: 25,
                                child: Image.asset(
                                  "./lib/assets/add.jpg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 25,
                                height: 25,
                                child: Image.asset(
                                  "./lib/assets/like.jpg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundImage:
                                      AssetImage("./lib/assets/profile3.jpg"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
