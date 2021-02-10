import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:insta_feed/items/header.dart';
import 'package:insta_feed/items/navigationBar.dart';
import 'package:insta_feed/items/post.dart';
import 'package:insta_feed/items/posts.dart';
import 'package:insta_feed/shared/functions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  bool bookmarked = false;
  String bookmarkImageUrl = "";
  double _bottomMargin = -50;
  int endPostIndex = 10;
  int startPostIndex = 0;

  List<Post> posts = [];
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _updateStartPostIndex(number) {
    setState(() {
      widget.startPostIndex = number;
    });
  }

  void _updateEndPostIndex(number) {
    setState(() {
      widget.endPostIndex = number;
    });
  }

  void getFeed(start, end) async {
    print("fetching data from api...");
    String url = "";
    Response respone = await post(
      url,
      headers: {
        "API-KEY": "",
      },
      body: jsonEncode(<String, dynamic>{
        "userToken": "",
        "startIndex": start,
        "limit": end
      }),
    );
    Map fetchedData = jsonDecode(respone.body);
    for (int i = 0; i < fetchedData['posts'].length - 1; i++) {
      if (fetchedData['posts'][i]["imageUrl"] != null) {
        widget.posts.add(
          Post(
            username: fetchedData['posts'][i]["username"],
            profileImageUrl: fetchedData['posts'][i]["profileImageUrl"],
            postImageUrl: fetchedData['posts'][i]["imageUrl"],
            likesAmount: fetchedData['posts'][i]["likeCount"],
            captionText: fetchedData['posts'][i]["caption"],
            commentsAmount: fetchedData['posts'][i]["commentCount"],
            postTime: fetchedData['posts'][i]["date"],
            hasLikedPost: fetchedData['posts'][i]["hasLikedPost"],
            aspectRatio: fetchedData['posts'][i]["aspectRatio"] * 1.0,
          ),
        );
      } else {
        widget.posts.add(
          Post(
            username: fetchedData['posts'][i]["username"],
            profileImageUrl: fetchedData['posts'][i]["profileImageUrl"],
            postImageUrl: "NULL",
            likesAmount: fetchedData['posts'][i]["likeCount"],
            captionText: fetchedData['posts'][i]["caption"],
            commentsAmount: fetchedData['posts'][i]["commentCount"],
            postTime: fetchedData['posts'][i]["date"],
            hasLikedPost: fetchedData['posts'][i]["hasLikedPost"],
            aspectRatio: fetchedData['posts'][i]["aspectRatio"] * 1.0,
          ),
        );
      }
    }
    setState(() {});
    print("data has been fetched");
  }

  @override
  void initState() {
    super.initState();
    getFeed(0, 10);
  }

  void toggleBookmark(url) {
    setState(() {
      widget.bookmarked = !widget.bookmarked;
      widget.bookmarkImageUrl = url;
    });
  }

  double _updateBottomMargin(number) {
    setState(() {
      widget._bottomMargin = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Header(),
              flex: 1,
            ),
            Expanded(
              child: Posts(
                posts: widget.posts,
                toggleBookmark: this.toggleBookmark,
                updateBottomMargin: this._updateBottomMargin,
                updateEndPostIndex: _updateEndPostIndex,
                updateStartPostIndex: _updateStartPostIndex,
                endPostIndex: widget.endPostIndex + 10,
                startPostIndex: widget.endPostIndex,
                getFeed: this.getFeed,
              ),
              flex: 13,
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 52,
          child: CustomeNavigationBar(
            bookmarked: widget.bookmarked,
            bookmarkImageUrl: widget.bookmarkImageUrl,
            bottomMargin: widget._bottomMargin,
          ),
        ),
      ),
    );
  }
}
