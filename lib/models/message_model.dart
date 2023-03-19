import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageModel {
  String? fromUserID;
  String? toUserID;
  final String message;
  DateTime? date;
  bool? isFromMe;
  MessageModel({
    required this.fromUserID,
    required this.toUserID,
    required this.message,
    this.date,
    this.isFromMe,
  });

  MessageModel copyWith({
    String? fromUserID,
    String? toUserID,
    String? message,
    DateTime? date,
    bool? isFromMe,
  }) {
    return MessageModel(
      fromUserID: fromUserID ?? this.fromUserID,
      toUserID: toUserID ?? this.toUserID,
      message: message ?? this.message,
      date: date ?? this.date,
      isFromMe: isFromMe ?? this.isFromMe,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fromUserID': fromUserID,
      'toUserID': toUserID,
      'message': message,
      'date': date ?? FieldValue.serverTimestamp(),
      'isFromMe': isFromMe,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic>? map) {
    return MessageModel(
      fromUserID: map?['fromUserID'],
      toUserID: map?['toUserID'],
      message: map?['message'],
      date: map?['date'] != null ? (map?['date'] as Timestamp).toDate() : null ,
      isFromMe: map?['isFromMe'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(fromUserID: $fromUserID, toUserID: $toUserID, message: $message, date: $date, isFromMe: $isFromMe)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.fromUserID == fromUserID &&
        other.toUserID == toUserID &&
        other.message == message &&
        other.date == date &&
        other.isFromMe == isFromMe;
  }

  @override
  int get hashCode {
    return fromUserID.hashCode ^ toUserID.hashCode ^ message.hashCode ^ date.hashCode ^ isFromMe.hashCode;
  }
}
