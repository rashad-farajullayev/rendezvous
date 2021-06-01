import 'package:flutter/material.dart';
import 'package:rendezvous/models/User.dart';
import 'package:rendezvous/bottom-sheet/CreateAccountBottomSheet.dart';

typedef void AuthenticationCallback(User user);

class AuthenticationProvider with ChangeNotifier {
  User _currentUser;

  User get currentUser {
    return _currentUser;
  }

  User openAuthenticationBox(BuildContext context) {
    if (_currentUser == null) {
      showCreateAccountBottomSheet(context);
    }

    return _currentUser;
  }

  void login() {
    var user = new User(
        id: 1,
        userName: "rashadex",
        password: "123456",
        firstName: "Rashad",
        lastName: "Farajullayev",
        email: "rashadex@gmail.com",
        phoneNumber: "+995 50 231 00 64",
        birthDate: DateTime(1981, 3, 21, 0, 0, 0, 0, 0));

    _currentUser = user;
    notifyListeners();
  }
}
