class ChatModel {
  String? name;
  String? icon;
  bool? isGroup = false;
  String? time;
  String? currentMessage;
  String? status;
  bool? select = false;
  int? id;
  ChatModel(
      {this.name,
      this.icon,
      this.isGroup = false,
      this.time,
      this.status,
      this.currentMessage,
      this.select = false,
      this.id});
}
