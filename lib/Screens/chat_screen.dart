import 'package:convo/CustomUI/CustomCard.dart';
import 'package:convo/Model/chatModel.dart';
import 'package:convo/Screens/contact_screen.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({required this.chat, required this.sourceChat});
  final List<ChatModel> chat;
  final ChatModel sourceChat;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ContactScreen()));
        },
        child: Icon(Icons.chat),
      ),
      body: ListView.builder(
          itemCount: widget.chat.length,
          itemBuilder: (context, index) => CustomCard(
                chatModel: widget.chat[index],
                sourceChat: widget.sourceChat,
              )),
    );
  }
}
