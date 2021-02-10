import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 10,
      child: Container(
        padding: EdgeInsets.only(right: 0, left: 15, top: 15, bottom: 15),
        height: 280,
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "Report...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Turn on Post Notifications",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Copy Link",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Share to...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Unfollow",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Mute",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
