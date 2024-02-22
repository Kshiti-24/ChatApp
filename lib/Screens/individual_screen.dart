import 'package:convo/CustomUI/receiverCard.dart';
import 'package:convo/CustomUI/senderCard.dart';
import 'package:convo/Model/chatModel.dart';
import 'package:convo/Model/messageModel.dart';
import 'package:convo/main.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class IndividualScreen extends StatefulWidget {
  const IndividualScreen({required this.chatModel, required this.sourceChat});
  final ChatModel chatModel;
  final ChatModel sourceChat;

  @override
  State<IndividualScreen> createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  TextEditingController _textEditingController = TextEditingController();
  late IO.Socket socket;
  bool sendMsg = false;
  List<MessageModel> messages = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  void connect() {
    socket = IO.io(
        "uri",
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    // socket!.onConnecting((data) => log.e("connecting, ${data}"));
    socket.emit("signin", widget.sourceChat.id);
    log.e(socket.connected);
    socket.onConnect((data) {
      print("Connected , ${data}");
      socket.on("message", (msg) {
        log.i(msg);
        setMessage("destination", msg["message"]);
      });
    });
    socket.onConnectError((data) => log.e("error connecting, ${data}"));
    socket.onError((data) => log.e("Error, ${data}"));
    // log.e(socket!.connected);
  }

  void sendMessage(String message, int sourceChatId, int targetChatId) {
    setMessage("source", message);
    socket.emit("message", {
      "message": message,
      "sourceChatId": sourceChatId,
      "targetChatId": targetChatId
    });
  }

  void setMessage(String type, String message) {
    MessageModel messageModel = MessageModel(type: type, message: message);
    setState(() {
      messages.add(messageModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        "assets/background.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color(0xFF075E54),
          foregroundColor: Colors.white,
          leadingWidth: 70,
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  radius: 20,
                  child: SvgPicture.asset(
                    widget.chatModel.isGroup!
                        ? "assets/groups.svg"
                        : "assets/person.svg",
                    color: Colors.white,
                    width: 32,
                    height: 32,
                  ),
                  backgroundColor: Colors.blueGrey,
                ),
              ],
            ),
          ),
          title: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatModel.name!,
                    style:
                        TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Last seen today at 12:05",
                    style: TextStyle(fontSize: 13),
                  )
                ],
              ),
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
            IconButton(onPressed: () {}, icon: Icon(Icons.call)),
            PopupMenuButton<String>(onSelected: (value) {
              print(value);
            }, itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("View Contact"),
                  value: "View Contact",
                ),
                PopupMenuItem(
                  child: Text("Media, links and docs"),
                  value: "Media, links and docs",
                ),
                PopupMenuItem(
                  child: Text("Whatsapp web"),
                  value: "Whatsapp web",
                ),
                PopupMenuItem(
                  child: Text("Search"),
                  value: "Search",
                ),
                PopupMenuItem(
                  child: Text("Mute Notifications"),
                  value: "Mute Notifications",
                ),
                PopupMenuItem(
                  child: Text("Wallpaper"),
                  value: "Wallpaper",
                )
              ];
            })
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: WillPopScope(
            onWillPop: () {
              if (show) {
                setState(() {
                  show = false;
                });
              } else {
                Navigator.pop(context);
              }
              return Future.value(false);
            },
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 156,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        if (messages[index].type == "source") {
                          log.e(messages.length);
                          return SenderCard(
                            message: messages[index].message!,
                          );
                        } else {
                          log.e(messages.length);
                          return ReceiverCard(
                            message: messages[index].message!,
                          );
                        }
                      }),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 60,
                            child: Card(
                              margin:
                                  EdgeInsets.only(left: 2, right: 2, bottom: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              child: TextFormField(
                                controller: _textEditingController,
                                focusNode: focusNode,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 1,
                                onChanged: (value) {
                                  if (value.length > 0) {
                                    setState(() {
                                      sendMsg = true;
                                    });
                                  } else {
                                    setState(() {
                                      sendMsg = false;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message",
                                  prefixIcon: IconButton(
                                    icon: Icon(Icons.emoji_emotions),
                                    onPressed: () {
                                      setState(() {
                                        focusNode.unfocus();
                                        focusNode.canRequestFocus = false;
                                        show = !show;
                                      });
                                    },
                                  ),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (builder) =>
                                                    bottomSheet());
                                          },
                                          icon: Icon(Icons.attach_file)),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.camera_alt))
                                    ],
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0, right: 5, left: 2),
                            child: CircleAvatar(
                              radius: 25,
                              child: IconButton(
                                icon: sendMsg
                                    ? Icon(Icons.send)
                                    : Icon(Icons.mic),
                                onPressed: () {
                                  if (sendMsg) {
                                    sendMessage(
                                        _textEditingController.text,
                                        widget.sourceChat.id!,
                                        widget.chatModel.id!);
                                    _textEditingController.clear();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      show
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: emojiSelect(),
                            )
                          : Container()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  Widget bottomSheet() {
    return Container(
      height: 270,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.green, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData iconData, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              color: Colors.white,
              iconData,
              size: 29,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(
        config: Config(
          bgColor: const Color.fromARGB(255, 234, 248, 255),
          columns: 8,
          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
        ),
        onEmojiSelected: (category, emoji) {
          print(emoji);
          setState(() {
            _textEditingController.text =
                _textEditingController.text + emoji.emoji;
          });
        });
  }
}
