import 'package:convo/CustomUI/buttonCard.dart';
import 'package:convo/Model/chatModel.dart';
import 'package:convo/Screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ChatModel? sourceChat;
  List<ChatModel> chat = [
    ChatModel(
        name: "Dev",
        icon: "person.svg",
        isGroup: false,
        time: "18:04",
        currentMessage: "Hi hello",
        id: 1),
    ChatModel(
        name: "Kshitiz",
        icon: "person.svg",
        isGroup: false,
        time: "17:45",
        currentMessage: "Hey hello",
        id: 2),
    // ChatModel(
    //     name: "Dev",
    //     icon: "groups.svg",
    //     isGroup: true,
    //     time: "16:04",
    //     currentMessage: "Hi...................."),
    ChatModel(
        name: "hello",
        icon: "person.svg",
        isGroup: false,
        time: "18:04",
        currentMessage: "hello.......hellloooo",
        id: 3),
    ChatModel(
        name: "hello",
        icon: "person.svg",
        isGroup: false,
        time: "18:04",
        currentMessage: "hello.......hellloooo",
        id: 4),
    ChatModel(
        name: "hello",
        icon: "person.svg",
        isGroup: false,
        time: "18:04",
        currentMessage: "hello.......hellloooo",
        id: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: chat.length,
          itemBuilder: (context, index) => InkWell(
              onTap: () {
                sourceChat = chat.removeAt(index);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(chat: chat,sourceChat: sourceChat!,)));
              },
              child:
                  ButtonCard(name: chat[index].name!, iconData: Icons.person))),
    );
  }
}
