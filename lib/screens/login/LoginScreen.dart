import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rendezvous/constants.dart';
import 'package:rendezvous/screens/login/EmailAddressInput.dart';
import 'package:rendezvous/screens/login/PhoneNumberInput.dart';

class LoginScreen extends StatefulWidget {
  static const String ROUTE_PATH = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthenticationAction _currentAction = AuthenticationAction.CREATE_ACCOUNT;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _currentAction = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            _currentAction == AuthenticationAction.CREATE_ACCOUNT
                ? "Create account"
                : "Sign in",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Theme.of(context).textTheme.bodyText1.color,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(
                  child: Text(
                    "Phone number",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Tab(
                  child: Text(
                    "Email address",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
            body: TabBarView(
              children: [
                SingleChildScrollView(child: PhoneNumberInput(_currentAction)),
                SingleChildScrollView(child: EmailAddressInput(_currentAction)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
