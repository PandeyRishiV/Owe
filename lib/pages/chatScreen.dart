import 'package:flutter/material.dart';
import 'package:owe/models/ContactInfo.dart';

class ChatScreen extends StatefulWidget {
  final ContactInfo user;
  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState(this.user);
}

class _ChatScreenState extends State<ChatScreen> {
  ContactInfo user;
  _ChatScreenState(this.user);
  @override
  Widget build(BuildContext context) {
    //Locally imported colors
    Color _primary = Theme.of(context).primaryColor;
    Color _primaryDark = Theme.of(context).primaryColorDark;
    Color _accent = Theme.of(context).accentColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(this.user.name),
        backgroundColor: _primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/home');
          },
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 10,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Type a text",
                ),
              ),
            ),
            Flexible(
                child: IconButton(onPressed: () {}, icon: Icon(Icons.send))),
          ],
        ),
      ),
    );
  }
}
