import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/services/firestore_methods.dart';

class UserProvider with ChangeNotifier{
  UserModel? _user;
  final FireStoreMethods _storeMethods = FireStoreMethods();

  UserModel? get getUser => _user;

  Future<void> refreshUser() async{
    var user = await _storeMethods.getUserDetails();
    _user = user;
    notifyListeners();

  }
}

