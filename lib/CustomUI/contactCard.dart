import 'package:convo/Model/chatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({required this.chatModel});
  final ChatModel chatModel;

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 53,
        width: 50,
        child: Stack(children: [
          CircleAvatar(
            radius: 23,
            child: SvgPicture.asset(
              "assets/person.svg",
              color: Colors.white,
              height: 30,
              width: 30,
            ),
            backgroundColor: Colors.blueGrey[200],
          ),
          widget.chatModel.select!
              ? Positioned(
                  bottom: 4,
                  right: 5,
                  child: CircleAvatar(
                    radius: 11,
                    child: Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.teal,
                  ),
                )
              : Container(),
        ]),
      ),
      title: Text(
        widget.chatModel.name!,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        widget.chatModel.status!,
        style: TextStyle(fontSize: 13),
      ),
    );
  }
}
