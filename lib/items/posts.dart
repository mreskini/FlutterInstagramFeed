import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flare_flutter/asset_provider.dart';
import 'package:flare_flutter/cache.dart';
import 'package:flare_flutter/cache_asset.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/flare_cache_asset.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flare_flutter/flare_render_box.dart';
import 'package:flare_flutter/flare_testing.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flare_flutter/provider/memory_flare.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:insta_feed/items/dialog.dart';
import 'package:insta_feed/items/post.dart';
import 'package:insta_feed/shared/functions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:meet_network_image/meet_network_image.dart';
import 'package:transparent_image/transparent_image.dart';

class Posts extends StatefulWidget {
  Function updateEndPostIndex;
  Function updateStartPostIndex;
  List<Post> posts = [];
  Function toggleBookmark;
  Function updateBottomMargin;
  int endPostIndex = 10;
  int startPostIndex = 0;
  Function getFeed;
  Posts({
    this.toggleBookmark,
    this.updateBottomMargin,
    this.posts,
    this.updateEndPostIndex,
    this.updateStartPostIndex,
    this.endPostIndex,
    this.startPostIndex,
    this.getFeed,
  });
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> with SingleTickerProviderStateMixin {
  List<Color> colors = [
    Colors.yellow,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
  ];
  var random = new Random();
  final FlareControls flareControls = FlareControls();
  double overlayLikeSize = 0;
  double _updateOverlayLikeSize(size) {
    overlayLikeSize = size;
  }

  double _snackBarHeight = 0;
  double _updateSnackBarHeight(height) {
    setState(() {
      _snackBarHeight = height;
    });
  }

  bool showHeart = false;
  bool showSnackBar = false;
  final ScrollController _scrollController = ScrollController();
  _doubleTapped(index) {
    setState(() {
      if (widget.posts[index].hasLikedPost == false) {
        widget.posts[index].likesAmount += 1;
      }
      widget.posts[index].hasLikedPost = true;
      showHeart = true;
      _updateOverlayLikeSize(90.0);
      if (showHeart) {
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            showHeart = false;
            _updateOverlayLikeSize(0.0);
          });
        });
      }
    });
  }

  _bookmarked(index) {
    setState(() {
      widget.posts[index].hasBookmarkedPost = true;
      showSnackBar = true;
      widget.toggleBookmark(widget.posts[index].postImageUrl);
      _updateSnackBarHeight(50.0);
      Timer(const Duration(milliseconds: 500), () {
        widget.updateBottomMargin(5.0);
      });
      if (showSnackBar) {
        Timer(const Duration(milliseconds: 1000), () {
          setState(() {
            widget.updateBottomMargin(-50.0);
            widget.toggleBookmark("");
            Timer(const Duration(milliseconds: 500), () {
              setState(() {
                showSnackBar = false;
                Timer(const Duration(milliseconds: 500), () {
                  _updateSnackBarHeight(0.0);
                });
              });
            });
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0)
          print('at the start');
        else {
          print("The end of the List View...");
          setState(() {
            widget.getFeed(widget.startPostIndex, widget.endPostIndex);
            widget.updateStartPostIndex(widget.endPostIndex);
            widget.updateEndPostIndex(widget.endPostIndex + 10);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: widget.posts.length + 1,
          itemBuilder: (context, index) {
            if (index >= widget.posts.length)
              return Container(
                padding: EdgeInsets.only(
                  top: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SpinKitCircle(
                      color: Colors.grey[300],
                      size: 60.0,
                    ),
                  ],
                ),
              );
            else
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                reverse: true,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        child: Card(
                          margin: EdgeInsets.only(bottom: 1),
                          elevation: .7,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 11, bottom: 0, top: 0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundImage: NetworkImage(widget
                                            .posts[index].profileImageUrl),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.posts[index].username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: FlatButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialog();
                                          });
                                    },
                                    padding: EdgeInsets.all(0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Icon(Icons.more_vert),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            widget.posts[index].hasLikedPost = true;
                          });
                        },
                        child: SizedBox(
                          height: widget.posts[index].aspectRatio == 0
                              ? 385
                              : 385 * widget.posts[index].aspectRatio,
                          child: GestureDetector(
                            onDoubleTap: () {
                              flareControls.play("like");
                              _doubleTapped(index);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                widget.posts[index].postImageUrl == "NULL"
                                    ? Container(
                                        child: Center(
                                            child: Text(
                                          "Check",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        )),
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: Colors.blue,
                                      )
                                    : Stack(
                                        children: [
                                          Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          Center(
                                            child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              image: widget
                                                  .posts[index].postImageUrl,
                                            ),
                                          ),
                                        ],
                                      ),
                                showHeart
                                    ? Container(
                                        width: double.infinity,
                                        height: 250,
                                        child: Center(
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: FlareActor(
                                              './lib/assets/instagram_like.flr',
                                              controller: flareControls,
                                              animation: 'like',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 250,
                                        child: Center(
                                          child: SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: FlareActor(
                                              './lib/assets/instagram_like.flr',
                                              controller: flareControls,
                                              animation: 'idle',
                                            ),
                                          ),
                                        ),
                                      ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    AnimatedContainer(
                                      color:
                                          Functions().getColorFromHex("FAFAFA"),
                                      width: double.infinity,
                                      height: _snackBarHeight,
                                      padding: EdgeInsets.all(10),
                                      duration: Duration(milliseconds: 400),
                                      child: Row(
                                        children: <Widget>[
                                          widget.posts[index].postImageUrl ==
                                                  "NULL"
                                              ? Container(
                                                  width: 35,
                                                  height: 35,
                                                  child: Center(),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Colors.blue),
                                                )
                                              : Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        widget.posts[index]
                                                            .postImageUrl,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(
                                            width: 14,
                                          ),
                                          Text(
                                            "Saved",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  "Save to Collection",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Functions()
                                                          .getColorFromHex(
                                                              "1892E2"),
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          margin: EdgeInsets.only(
                              right: 12, left: 12, top: 10, bottom: 14),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (widget.posts[index].hasLikedPost ==
                                            true) {
                                          widget.posts[index].likesAmount -= 1;
                                        }
                                        if (widget.posts[index].hasLikedPost ==
                                            false) {
                                          widget.posts[index].likesAmount += 1;
                                        }
                                        widget.posts[index].hasLikedPost =
                                            !widget.posts[index].hasLikedPost;
                                      });
                                    },
                                    child: Container(
                                      width: 27,
                                      height: 27,
                                      child: widget.posts[index].hasLikedPost
                                          ? Container(
                                              child: Image.asset(
                                                "./lib/assets/redLike2.jpg",
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                          : Container(
                                              child: Image.asset(
                                                "./lib/assets/like.jpg",
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                    ),
                                  ),
                                ]),
                                flex: 1,
                              ),
                              Expanded(
                                child: Row(children: <Widget>[
                                  Container(
                                    width: 25,
                                    height: 25,
                                    child: Image.asset(
                                      "./lib/assets/comment.jpg",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ]),
                                flex: 1,
                              ),
                              Expanded(
                                child: Row(children: <Widget>[
                                  Container(
                                    width: 25,
                                    height: 25,
                                    child: Image.asset(
                                      "./lib/assets/send.jpg",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ]),
                                flex: 1,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.posts[index].hasBookmarkedPost =
                                          !widget
                                              .posts[index].hasBookmarkedPost;

                                      if (widget
                                          .posts[index].hasBookmarkedPost) {
                                        this._bookmarked(index);
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        width: 25,
                                        height: 25,
                                        child: widget
                                                .posts[index].hasBookmarkedPost
                                            ? Container(
                                                child: Image.asset(
                                                  "./lib/assets/blackBookmark.jpg",
                                                  fit: BoxFit.contain,
                                                ),
                                              )
                                            : Container(
                                                child: Image.asset(
                                                  "./lib/assets/bookmark.jpg",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                flex: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 14,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.posts[index].likesAmount.toString() +
                                    " likes",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 14,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.posts[index].username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child:
                                        Text(widget.posts[index].captionText),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      SizedBox(
                        child: Container(
                          margin: EdgeInsets.only(left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "View all " +
                                    widget.posts[index].commentsAmount
                                        .toString() +
                                    " comments",
                                style: TextStyle(
                                  color: Functions().getColorFromHex("999999"),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 16,
                            right: 14,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 12,
                                backgroundImage:
                                    AssetImage("./lib/assets/profile3.jpg"),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Form(
                                  child: TextFormField(
                                    onChanged: (value) {},
                                    initialValue: "",
                                    decoration: InputDecoration(
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      hintText: "Add a comment...",
                                      hintStyle: TextStyle(
                                        fontSize: 13,
                                        color: Functions()
                                            .getColorFromHex("999999"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        width: 15,
                                        margin: EdgeInsets.all(5),
                                        height: 15,
                                        child: Image.asset(
                                          "./lib/assets/fire.jpg",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Container(
                                        width: 15,
                                        height: 15,
                                        margin: EdgeInsets.all(5),
                                        child: Image.asset(
                                          "./lib/assets/redLike.jpg",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Container(
                                        width: 15,
                                        height: 15,
                                        margin: EdgeInsets.all(5),
                                        child: Image.asset(
                                          "./lib/assets/more.jpg",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 17,
                            right: 14,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.posts[index].postTime,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Functions().getColorFromHex("999999"),
                                ),
                              ),
                              Container(
                                width: 3,
                                height: 3,
                                margin: EdgeInsets.all(5),
                                child: CircleAvatar(
                                  backgroundColor:
                                      Functions().getColorFromHex("999999"),
                                ),
                              ),
                              Text(
                                "See Translation",
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              );
          },
        ),
      ],
    );
  }
}
