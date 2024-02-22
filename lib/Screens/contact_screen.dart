import 'package:convo/CustomUI/buttonCard.dart';
import 'package:convo/CustomUI/contactCard.dart';
import 'package:convo/Model/chatModel.dart';
import 'package:convo/Screens/new_group_screen.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<ChatModel> contacts = [
    ChatModel(name: "Kshitiz Agarwal", status: "Hey, there"),
    ChatModel(name: "Kshitiz Agarwal", status: "Hey, there"),
    ChatModel(name: "Kshitiz Agarwal", status: "Hey, there"),
    ChatModel(name: "Kshitiz Agarwal", status: "Hey, there"),
    ChatModel(name: "Kshitiz Agarwal", status: "Hey, there"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF075E54),
        foregroundColor: Colors.white,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Contact",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            Text("256 Contacts", style: TextStyle(fontSize: 13))
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          PopupMenuButton<String>(onSelected: (value) {
            print(value);
          }, itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text("Invite a friend"),
                value: "Invite a friend",
              ),
              PopupMenuItem(
                child: Text("Contacts"),
                value: "Contacts",
              ),
              PopupMenuItem(
                child: Text("Refresh"),
                value: "Refresh",
              ),
              PopupMenuItem(
                child: Text("Help"),
                value: "Help",
              )
            ];
          })
        ],
      ),
      body: ListView.builder(
          itemCount: contacts.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewGroupScreen()));
                },
                child: ButtonCard(
                  iconData: Icons.group,
                  name: "New group",
                ),
              );
            } else if (index == 1) {
              return ButtonCard(
                iconData: Icons.person_add,
                name: "New contact",
              );
            }
            return ContactCard(chatModel: contacts[index - 2]);
          }),
    );
  }
}
