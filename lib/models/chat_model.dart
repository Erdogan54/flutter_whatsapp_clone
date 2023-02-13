// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? fromUserID;
  String? toUserID;
  String? lastMessage;
  Timestamp? createdDate;
  Timestamp? displayedDate;
  DateTime? lastReadedTime;
  String? timeAgo;
  bool? isShow = false;
  String? toUserName;
  String? toUserProfileURL;
  ChatModel({
    this.fromUserID,
    this.toUserID,
    this.lastMessage,
    this.createdDate,
    this.displayedDate,
    this.lastReadedTime,
    this.timeAgo,
    this.isShow,
    this.toUserName,
    this.toUserProfileURL,
  });

  ChatModel copyWith({
    String? fromUserID,
    String? toUserID,
    String? lastMessage,
    Timestamp? createdDate,
    Timestamp? displayedDate,
    DateTime? lastReadedTime,
    String? timeAgo,
    bool? isShow,
    String? toUserName,
    String? toUserProfileURL,
  }) {
    return ChatModel(
      fromUserID: fromUserID ?? this.fromUserID,
      toUserID: toUserID ?? this.toUserID,
      lastMessage: lastMessage ?? this.lastMessage,
      createdDate: createdDate ?? this.createdDate,
      displayedDate: displayedDate ?? this.displayedDate,
      lastReadedTime: lastReadedTime ?? this.lastReadedTime,
      timeAgo: timeAgo ?? this.timeAgo,
      isShow: isShow ?? this.isShow,
      toUserName: toUserName ?? this.toUserName,
      toUserProfileURL: toUserProfileURL ?? this.toUserProfileURL,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fromUserID': fromUserID,
      'toUserID': toUserID,
      'lastMessage': lastMessage,
      'createdDate': createdDate,
      'displayedDate': displayedDate,
      'lastReadedTime': lastReadedTime?.millisecondsSinceEpoch,
      'timeAgo': timeAgo,
      'isShow': isShow,
      'toUserName': toUserName,
      'toUserProfileURL': toUserProfileURL,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      fromUserID: map['fromUserID'] != null ? map['fromUserID'] as String : null,
      toUserID: map['toUserID'] != null ? map['toUserID'] as String : null,
      lastMessage: map['lastMessage'] != null ? map['lastMessage'] as String : null,
      createdDate: map['createdDate'],
      displayedDate: map['displayedDate'],
      lastReadedTime:
          map['lastReadedTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastReadedTime'] as int) : null,
      timeAgo: map['timeAgo'] != null ? map['timeAgo'] as String : null,
      isShow: map['isShow'] != null ? map['isShow'] as bool : null,
      toUserName: map['toUserName'] != null ? map['toUserName'] as String : null,
      toUserProfileURL: map['toUserProfileURL'] != null ? map['toUserProfileURL'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(fromUserID: $fromUserID, toUserID: $toUserID, lastMessage: $lastMessage, createdDate: $createdDate, displayedDate: $displayedDate, lastReadedTime: $lastReadedTime, timeAgo: $timeAgo, isShow: $isShow, toUserName: $toUserName, toUserProfileURL: $toUserProfileURL)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.fromUserID == fromUserID &&
        other.toUserID == toUserID &&
        other.lastMessage == lastMessage &&
        other.createdDate == createdDate &&
        other.displayedDate == displayedDate &&
        other.lastReadedTime == lastReadedTime &&
        other.timeAgo == timeAgo &&
        other.isShow == isShow &&
        other.toUserName == toUserName &&
        other.toUserProfileURL == toUserProfileURL;
  }

  @override
  int get hashCode {
    return fromUserID.hashCode ^
        toUserID.hashCode ^
        lastMessage.hashCode ^
        createdDate.hashCode ^
        displayedDate.hashCode ^
        lastReadedTime.hashCode ^
        timeAgo.hashCode ^
        isShow.hashCode ^
        toUserName.hashCode ^
        toUserProfileURL.hashCode;
  }
}
