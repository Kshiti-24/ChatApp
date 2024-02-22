import 'package:convo/CustomUI/buttonCard.dart';
import 'package:convo/CustomUI/contactCard.dart';
import 'package:convo/CustomUI/participantCard.dart';
import 'package:convo/Model/chatModel.dart';
import 'package:flutter/material.dart';

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({super.key});

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  List<ChatModel> contacts = [
    ChatModel(name: "Kshitiz Agarwal", status: "Hey, there"),
    ChatModel(name: "Kshitiz Agarwal", status: "Hey, there"),
    ChatModel(name: "Kshitiz Agarwal", status: "Hey, there"),
    ChatModel(name: "Kshitiz Agarwal", status: "Hey, there"),
    ChatModel(name: "Kshitiz Agarwal", status: "Hey, there"),
  ];
  List<ChatModel> groups = [];
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
              "New group",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            Text("Add participants", style: TextStyle(fontSize: 13))
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      body: Stack(children: [
        ListView.builder(
            itemCount: contacts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  height: groups.length > 0 ? 90 : 10,
                );
              }
              return InkWell(
                  onTap: () {
                    if (contacts[index - 1].select == false) {
                      setState(() {
                        contacts[index - 1].select = true;
                        groups.add(contacts[index - 1]);
                      });
                    } else {
                      setState(() {
                        contacts[index - 1].select = false;
                        groups.remove(contacts[index - 1]);
                      });
                    }
                  },
                  child: ContactCard(chatModel: contacts[index - 1]));
            }),
        groups.length > 0
            ? Column(
                children: [
                  Container(
                    height: 75,
                    color: Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (contacts[index].select == true) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                contacts[index].select = false;
                                groups.remove(contacts[index]);
                              });
                            },
                            child: ParticipantCard(
                              chatModel: contacts[index],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                      itemCount: contacts.length,
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  )
                ],
              )
            : Container()
      ]),
    );
  }
}
