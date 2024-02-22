import 'package:convo/Model/chatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ParticipantCard extends StatelessWidget {
  const ParticipantCard({required this.chatModel});
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(children: [
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
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 11,
                child: Icon(
                  Icons.clear,
                  size: 13,
                  color: Colors.white,
                ),
                backgroundColor: Colors.grey,
              ),
            )
          ]),
          SizedBox(
            height: 2,
          ),
          Text(
            chatModel.name!,
            style: TextStyle(fontSize: 13),
          )
        ],
      ),
    );
  }
}
