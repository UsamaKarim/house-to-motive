
import 'package:flutter/material.dart';

class UserInfo {
  String id = '';
  String name ='' ;

  UserInfo({
    required this.id,
    required this.name,
  });

  bool get isEmpty => id.isEmpty;

  UserInfo.empty();
}

UserInfo currentUser = UserInfo.empty();
const String cacheUserIDKey = 'cache_user_id_key';

TextStyle textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 13.0,
    decoration: TextDecoration.none);
