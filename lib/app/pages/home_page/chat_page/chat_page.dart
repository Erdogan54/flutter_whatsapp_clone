import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../constants/my_const.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../models/message_model.dart';
import '../../../../models/user_model.dart';
import '../../../../view_model/chat_view_model.dart';
import '../../../../view_model/user_view_model.dart';

class ChatPage extends StatefulWidget {
  final UserModel? fromUser;
  final UserModel? toUser;
  const ChatPage({super.key, this.fromUser, this.toUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _messageController;

  late ScrollController _scrollController;
  final FocusNode _focusNode = FocusNode();

  late ChatViewModel _chatViewModelWatch;
  late ChatViewModel _chatViewModelRead;
  double offset = 0.0;

  @override
  void initState() {
    print("chat page init");

    _messageController = TextEditingController();
    _chatViewModelRead = context.read<ChatViewModel>();
    _chatViewModelRead.fromUser = widget.fromUser;
    _chatViewModelRead.toUser = widget.toUser;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _chatViewModelRead.getMessagesFirstrequest();

    });

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _scrollListener();
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _chatViewModelRead.getMessages();
      offset = _scrollController.offset;
    }
  }

  @override
  Widget build(BuildContext context) {
    _chatViewModelWatch = context.watch<ChatViewModel>();
   
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back)),
          leadingWidth: 40,
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            // IconButton(onPressed: () => Navigator.canPop(context), icon: Icon(Icons.arrow_back)),
            CircleAvatar(backgroundImage: NetworkImage(widget.toUser?.photoUrl ?? MyConst.defaultProfilePhotoUrl)),

            Text("  ${widget.toUser?.userName}"),
          ]),
          actions: [
            // _setState(),
            // _buildRefreshButton(),
            IconButton(
                onPressed: () {
                  offset = offset + 100;
                  _scrollController.jumpTo(offset);
                },
                icon: Icon(Icons.next_plan))
          ],
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: _buildMessageBody(),
              ),
              Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _buildMessageSendingComponent(),
                );
              })
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildMessageBody() {
    print("_buildMessageList widget run - chat page");
    Widget messageList(ChatViewModel value) {
      return RefreshIndicator(
        onRefresh: () => _chatViewModelRead.onRefresh(),
        child: ListView.builder(
          reverse: true,
          controller: _scrollController,
          itemCount: value.allMessages!.length,
          itemBuilder: (context, index) {
            return _buildChatBalloon(value.allMessages![index]);
          },
        ),
      );
    }

    return Consumer<ChatViewModel>(
      builder: (context, value, child) {
        return Stack(
          children: [
            if (value.state == ChatViewState.Loaded && (value.allMessages?.isEmpty ?? true))
              _buildEmptyMessageList()
            else
              messageList(value),
            if (value.state == ChatViewState.Busy)
              if ((value.allMessages?.isNotEmpty ?? true))
                const Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator(),
                )
              else
                const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }

  Widget _buildEmptyMessageList() {
    final height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () => _chatViewModelRead.onRefresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: SizedBox(
            height: height - (height / 5),
            //width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.message,
                  color: Theme.of(context).primaryColor,
                  size: 100,
                ),
                const Text(
                  "Henüz bir mesaj yok",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageSendingComponent() {
    final buildTextField = TextField(
      controller: _messageController,
      cursorColor: Theme.of(context).primaryColor,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      focusNode: _focusNode,
      // autofocus: true,
      cursorHeight: 28,
      textAlign: TextAlign.left,
      textAlignVertical: TextAlignVertical.center,

      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: "Mesaj",
          hoverColor: Theme.of(context).primaryColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(style: BorderStyle.none, width: 0.0),
          )),
    );

    final buildSendButton = FloatingActionButton(
        onPressed: _sendMessageButton,
        child: Transform.rotate(
          angle: -1.6,
          child: Icon(
            Icons.send,
            color: Colors.white,
            size: 70.sp,
          ),
        ));

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: buildTextField,
          ),
        ),
        buildSendButton
      ],
    );
  }

  void _sendMessageButton() async {
    if (_messageController.text.trim().isEmpty) return;
    final sendingMessage = MessageModel(
      fromUserID: _chatViewModelRead.fromUser?.userId ?? "null",
      toUserID: _chatViewModelRead.toUser?.userId ?? "null",
      message: _messageController.text,
      isFromMe: true,
      //date: toMAp metodunda mevcut
    );
    _chatViewModelRead.sendMessage(sendingMessage);

    // _viewModelRead.getLastMessage(willBeSavedMessage.fromUserID, willBeSavedMessage.toUserID);

    _messageController.clear();
    if (_scrollController.hasClients) {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent) {
        _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
      }
    }
  }

  Widget _buildChatBalloon(MessageModel? message) {
    Color camingMessageColor = Colors.white;
    Color goingMessageColor = Theme.of(context).primaryColor;

    if (message == null) return const SizedBox.shrink();

    final timeValue = _timeDisplay(message.date ?? DateTime.now().toLocal());

    // print("${message.isFromMe}");

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(message.message, textAlign: TextAlign.end, style: TextStyle(fontSize: 15)),
                    Text(
                      timeValue,
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );

    final toMessageBalloon = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // CircleAvatar(
            //   backgroundColor: Colors.green,
            //   backgroundImage: NetworkImage(_chatViewModelRead.toUser?.photoUrl ?? MyConst.defaultProfilePhotoUrl),
            // ),
            Flexible(
              child: Container(
                  constraints: BoxConstraints(maxWidth: context.width * 0.65),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: camingMessageColor,
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      Text(message.message),
                      Text(timeValue),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );

    if (message.fromUserID == _chatViewModelRead.fromUser?.userId) {
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

  String _timeDisplay(Object? date) {
    if (date == null) return "";
    if (date is DateTime) {
      return DateFormat.Hm().format(date);
    }
    date as Timestamp;
    return DateFormat.Hm().format(date.toDate());
  }

  Widget _buildRefreshButton() {
    return _chatViewModelWatch.state != ChatViewState.Busy
        ? IconButton(onPressed: () => _chatViewModelRead.onRefresh(), icon: const Icon(Icons.refresh))
        : Center(
            child: Container(
            margin: const EdgeInsets.only(right: 10),
            height: context.height / 30,
            width: context.height / 30,
            child: const CircularProgressIndicator(
              color: Colors.white,
            ),
          ));
  }

  Widget _setState() {
    return IconButton(onPressed: () => setState(() {}), icon: Icon(Icons.download));
  }
}
