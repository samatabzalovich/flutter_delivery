// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:flutter_delivery/core/enum/user_enums.dart';

class UserEntity extends Equatable {
  final int uid;
  final String email;
  final String userName;
  final UserType type;
  final String? token;
  const UserEntity({
    required this.uid,
    required this.email,
    required this.userName,
    required this.type,
    this.token,
  });

  @override
  List<Object?> get props => [uid, email, userName, type, token!];
}


//can I save user info in the AuthStateLoggedIn and access it anywhere 


// lib
//   -core
//   -feature
//     --rider_app
//       ---data 
//       ---domain 
//       ---presentation
//     --auth  
//       ---data
//       ---domain
//       ---presentation