import 'package:convo/Model/chatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonCard extends StatefulWidget {
  const ButtonCard({required this.name, required this.iconData});
  final String name;
  final IconData iconData;

  @override
  State<ButtonCard> createState() => _ButtonCardState();
}

class _ButtonCardState extends State<ButtonCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.green,
        child: Icon(
          widget.iconData,
          color: Colors.white,
        ),
      ),
      title: Text(
        widget.name,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
