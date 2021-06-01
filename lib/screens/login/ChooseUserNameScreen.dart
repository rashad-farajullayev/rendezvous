import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/providers/AuthenticationProvider.dart';
import 'package:rendezvous/widgets/buttons/PrimaryButton.dart';

import '../../constants.dart';

class ChooseUserNameScreen extends StatefulWidget {
  static const ROUTE_PATH = "/login/chose-username";

  @override
  _ChooseUserNameScreenState createState() => _ChooseUserNameScreenState();
}

class _ChooseUserNameScreenState extends State<ChooseUserNameScreen> {
  final TextEditingController _userNameController = TextEditingController();
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Creating account",
            style:
                TextStyle(color: Theme.of(context).textTheme.headline5.color),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Text(
                "Pick a username",
                style: Theme.of(context).textTheme.headline6,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Please choose a username for your profile. It will be used to mention you. Other users can recognize you by this username, too"),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: TextFormField(
                  onChanged: (value) {
                    var isValid = value.length >= 5;
                    setState(() {
                      _isValid = isValid;
                    });
                  },
                  keyboardType: TextInputType.name,
                  controller: _userNameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      new RegExp(r'[^a-z^A-Z^0-9\.\-_]+'),
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: "User name",
                    prefixIcon:
                        Icon(Icons.alternate_email, color: Colors.grey[600]),
                    suffixIcon: _userNameController.text.isEmpty
                        ? null
                        : (_isValid
                            ? Icon(Icons.done, color: Colors.green)
                            : InkWell(
                                child: Icon(Icons.cancel_outlined,
                                    color: Colors.red[600]),
                                onTap: () {
                                  _userNameController.clear();
                                  setState(() {
                                    _isValid = false;
                                  });
                                })),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: PrimaryButton(
                    label: "Create Account",
                    onPressed: _isValid
                        ? () {
                            Navigator.of(context).popUntil(ModalRoute.withName(
                                StringConstants.CREATE_ACCOUNT_ROUTE_NAME));

                            Navigator.of(context).pop();
                            Provider.of<AuthenticationProvider>(context,
                                    listen: false)
                                .login();
                          }
                        : null,
                  ))
            ],
          ),
        ));
  }
}
