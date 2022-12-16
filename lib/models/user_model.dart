import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String userId;
  String? email;
  String? userName;
  String? photoUrl;
  DateTime? createdAt;
  DateTime? updateAt;
  int? seviye;
  UserModel({
    required this.userId,
    required this.email,
    this.userName,
    this.photoUrl,
    this.createdAt,
    this.updateAt,
    this.seviye,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'email': email,
      'userName': userName,
      'photoUrl': photoUrl,
      'createdAt': createdAt?.millisecondsSinceEpoch ?? FieldValue.serverTimestamp(),
      'updateAt': updateAt?.millisecondsSinceEpoch ?? FieldValue.serverTimestamp(),
      'seviye': seviye,
    };
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, email: $email, userName: $userName, photoUrl: $photoUrl, createdAt: $createdAt, updateAt: $updateAt, seviye: $seviye)';
  }

  UserModel copyWith({
    String? userId,
    String? email,
    String? userName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updateAt,
    int? seviye,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updateAt: updateAt ?? this.updateAt,
      seviye: seviye ?? this.seviye,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      email: map['email'],
      userName: map['userName'],
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
      updateAt: map['updateAt'] != null ? (map['updateAt'] as Timestamp).toDate() : null,
      seviye: map['seviye'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.email == email &&
        other.userName == userName &&
        other.photoUrl == photoUrl &&
        other.createdAt == createdAt &&
        other.updateAt == updateAt &&
        other.seviye == seviye;
  }

  @override
  int get hashCode {
    return userId.hashCode ^ email.hashCode ^ userName.hashCode ^ photoUrl.hashCode ^ createdAt.hashCode ^ updateAt.hashCode ^ seviye.hashCode;
  }
}
