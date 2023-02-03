import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_whatsapp_clone/constants/my_const.dart';
import 'package:flutter_whatsapp_clone/extensions/context_extension.dart';
import 'package:flutter_whatsapp_clone/models/message_model.dart';
import 'package:flutter_whatsapp_clone/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';

class ChatPage extends StatefulWidget {
  final UserModel? fromUser;
  final UserModel? toUser;
  const ChatPage({super.key, required this.fromUser, required this.toUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _messageController;
  late final UserViewModel _viewModelRead;
  late UserViewModel _viewModelWatch;
  late ScrollController _scrollController;

  @override
  void initState() {
    _messageController = TextEditingController();
    _viewModelRead = context.read<UserViewModel>();
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _viewModelWatch = context.watch<UserViewModel>();
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: _buildMessageListStream(),
          ),
          Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: _buildTextField(),
                    ),
                  ),
                  _buildSendButton()
                ],
              ),
            );
          })
        ],
      )),
    );
  }

  StreamBuilder<List<MessageModel>> _buildMessageListStream() {
    return StreamBuilder<List<MessageModel>>(
      stream: _viewModelWatch.getMessages(widget.fromUser?.userId, widget.toUser?.userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          debugPrint("chat page has not data");
          return const Center(
            child: Text("Hadi bir merhaba de!"),
          );
        }
        debugPrint("chat page has data");
        // _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
        return ListView.builder(
          reverse: true,
          controller: _scrollController,
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            return _chatBalloon(snapshot.data?[index]);
          },
        );
      },
    );
  }

  TextField _buildTextField() {
    return TextField(
      controller: _messageController,
      cursorColor: Colors.blueGrey,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "Mesajınızı yazınız",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(style: BorderStyle.none, width: 0.0),
          )),
    );
  }

  FloatingActionButton _buildSendButton() {
    return FloatingActionButton(
      onPressed: _sendMessage,
      child: _buildButtonIcon(),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    final willBeSavedMessage = MessageModel(
      fromUserID: widget.fromUser?.userId ?? "null fromUserID",
      toUserID: widget.toUser?.userId ?? "null toUserID",
      message: _messageController.text,
      isFromMe: true,
      //date: (FieldValue.serverTimestamp() as Timestamp).toDate()
    );
    _viewModelRead.sendMessage(willBeSavedMessage);

    // _viewModelRead.getLastMessage(willBeSavedMessage.fromUserID, willBeSavedMessage.toUserID);

    _messageController.clear();
    _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
  }

  Transform _buildButtonIcon() {
    return Transform.rotate(
      angle: -1.6,
      child: Icon(
        Icons.send,
        color: Colors.white,
        size: 70.sp,
      ),
    );
  }

  Widget _chatBalloon(MessageModel? message) {
    Color camingMessageColor = Colors.blue;
    Color goingMessageColor = Theme.of(context).primaryColor;
    if (message == null) return const SizedBox.shrink();

    final fromMessageBalloon = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: context.width * 0.65),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: goingMessageColor),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(4),
                child: Text(
                  message.message,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Text("18:24")
          ],
        )
      ],
    );

    final toMessageBalloon = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.toUser?.photoUrl ?? ""),
            ),
            Flexible(
              child: Container(
                  constraints: BoxConstraints(maxWidth: context.width * 0.65),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: camingMessageColor,
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(4),
                  child: Text(message.message)),
            ),
            const Text("14:30")
          ],
        ),
      ],
    );

    if (message.isFromMe) {
      //mesaj benden gönderilmiş ise
      return Padding(
        padding: const EdgeInsets.all(8),
        child: fromMessageBalloon,
      );
    } else {
      //mesaj karşı taraftan gelmiş ise
      return Padding(
        padding: const EdgeInsets.all(8),
        child: toMessageBalloon,
      );
    }
  }
}
