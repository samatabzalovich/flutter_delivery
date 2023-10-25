import 'dart:convert';

import 'package:flutter_delivery/core/enum/user_enums.dart';
import 'package:flutter_delivery/features/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity{
  const UserModel({
    required int uid,
    required String email,
    required String userName,
    required UserType type,
    required String? token,
  }): super(email: email, uid: uid, userName: userName, token: token, type: type);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'userName': userName,
      'type': type.name,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String? token) {
    return UserModel(
      uid: map['id'] as int,
      email: map['email'] as String,
      userName: map['userName'] as String,
      type: UserType.none.getValueFromString(map['type']),
      token: token  ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>, null);

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
        uid: entity.uid,
        email: entity.email,
        userName: entity.userName,
        type: entity.type,
        token: entity.token);
  }
  UserModel copyWith({
    int? uid,
    String? email,
    String? userName,
    UserType? type,
    String? token,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      type: type ?? this.type,
      token: token ?? this.token,
    );
  }
}
