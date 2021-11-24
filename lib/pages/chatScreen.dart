import 'dart:developer';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:owe/models/Chat.dart';
import 'package:owe/models/ContactInfo.dart';
import 'package:owe/service/database_service.dart';

class ChatScreen extends StatefulWidget {
  final ContactInfo user;
  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState(this.user);
}

class _ChatScreenState extends State<ChatScreen> {
  Color _primary = Colors.white;
  Color _primaryDark = Colors.white;
  Color _accent = Colors.white;

  @override
  initState() {
    super.initState();
    DatabaseService().getConversation(_uid, this.user.uid).then((chats) {
      setState(() {
        _previousChatList = chats;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //Locally imported colors
    _primary = Theme.of(context).primaryColor;
    _primaryDark = Theme.of(context).primaryColorDark;
    _accent = Theme.of(context).accentColor;
  }

  //GLOBALS
  ContactInfo user;
  _ChatScreenState(this.user);
  List<Chat> _previousChatList = [];
  List<Chat> _currentChatList = [];
  DateTime _currentTime = new DateTime.now();
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  final _sendController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //Main UI
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: _getTitle(),
        backgroundColor: _primary,
        leading: _getAppbarBack(),
      ),
      body: Column(
        children: [
          _getListViewBody(_previousChatList, true),
          _getListViewBody(_currentChatList, false),
        ],
      ),
      bottomSheet: _getBottomWidgets(),
    );
  }

  Widget _getTitle() {
    return Row(
      children: [
        Icon(
          Icons.person,
          semanticLabel: "Contact Profile",
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.user.name,
              style: TextStyle(fontSize: 18),
              semanticsLabel: "Contact profile",
            ),
            Text(
              this.user.phone,
              style: TextStyle(fontSize: 12),
              semanticsLabel: "Contact profile",
            )
          ],
        )
      ],
    );
  }

  Widget _getAppbarBack() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        semanticLabel: "back",
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _getListViewBody(List<Chat> _chats, bool reverse) {
    double bottomPadding = 100;
    if (_chats.length <= 0) return SizedBox();
    if (reverse) {
      bottomPadding = 10;
    }
    return ListView.builder(
        controller: _scrollController,
        reverse: reverse,
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(0, 30, 0, bottomPadding),
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          return _getListTile(_chats, index);
        });
  }

  Widget _getListTile(List<Chat> _chats, int index) {
    Widget _date = SizedBox();
    //TODO LOOK into date text

    // if (_currentTime == _chats.elementAt(index).timeStamp) {
    //   _currentTime = _chats.elementAt(index).timeStamp;
    //   _date = Center(
    //     child: DateChip(
    //       date: _chats.elementAt(index).timeStamp,
    //       color: Colors.cyan,
    //     ),
    //   );
    // }
    return Column(children: [
      BubbleNormal(
        bubbleRadius: 10,
        text: _chats.elementAt(index).text,
        color: Theme.of(context).primaryColor,
        isSender: _chats.elementAt(index).sender,
      ),
    ]);
  }

  Widget _getBottomWidgets() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 8,
            child: TextField(
              controller: _sendController,
              cursorColor: Theme.of(context).primaryColorDark,
              textInputAction: TextInputAction.send,
              onEditingComplete: () {},
              onSubmitted: (text) {
                if (_sendController.text.isNotEmpty) {
                  _sendText(_sendController.text);
                }
              },
              decoration: InputDecoration(
                hintText: "Type a text",
              ),
            ),
          ),
          Flexible(
              child: IconButton(
                  onPressed: () {
                    if (_sendController.text.isNotEmpty) {
                      _sendText(_sendController.text);
                    }
                  },
                  icon: Icon(
                    Icons.send,
                    size: 30,
                    semanticLabel: "Send text",
                  ))),
          Flexible(
              child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add_circle_outline_rounded,
              size: 30,
              semanticLabel: "Add new pay record",
            ),
          ))
        ],
      ),
    );
  }

  void _sendText(String text) async {
    bool result = await DatabaseService()
        .sendText(text, _uid, user.uid, DateTime.now().toString());
    if (result) {
      setState(() {
        _setTextOnBody(text, DateTime.now().toString(), true);
        _sendController.clear();
        double end = _scrollController.position.maxScrollExtent + 20;
        _scrollController.animateTo(end,
            duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
      });
    }
  }

  void _setTextOnBody(String text, String timeStamp, bool sender) {
    Chat newChat = new Chat(text, DateTime.parse(timeStamp), sender);
    setState(() {
      _currentChatList.add(newChat);
    });
  }
}
