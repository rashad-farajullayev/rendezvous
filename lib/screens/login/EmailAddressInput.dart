import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rendezvous/constants.dart';
import 'package:rendezvous/screens/login/CodeVerificationScreen.dart';
import 'package:rendezvous/widgets/buttons/PrimaryButton.dart';

class EmailAddressInput extends StatefulWidget {
  final AuthenticationAction authenticationAction;

  EmailAddressInput(this.authenticationAction);

  @override
  _EmailAddressInputState createState() => _EmailAddressInputState();
}

class _EmailAddressInputState extends State<EmailAddressInput> {
  TextEditingController _emailAddressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
  }

  void emailAddressChanged(String newAddress) async {
    bool isEmailValid = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(newAddress);
    if (!isEmailValid &&
        widget.authenticationAction == AuthenticationAction.LOGIN) {
      isEmailValid = RegExp(r'^[a-zA-Z0-9\.\-_]+$').hasMatch(newAddress);
    }

    setState(() {
      _isEmailValid = isEmailValid;
    });
  }

  void passwordChanged(String newPassword) {
    var isPasswordValid = (newPassword != null && newPassword.length > 3);

    setState(() {
      _isPasswordValid = isPasswordValid;
    });
  }

  String emailHint() {
    return widget.authenticationAction == AuthenticationAction.CREATE_ACCOUNT
        ? "Email"
        : "Email or username";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailAddressController,
            maxLength: 300,
            maxLengthEnforced: true,
            decoration: this._isEmailValid
                ? InputDecoration(
                    hintText: emailHint(),
                    suffixIcon: Icon(Icons.done, color: Colors.green))
                : (_emailAddressController.text.isEmpty
                    ? InputDecoration(hintText: emailHint())
                    : InputDecoration(
                        hintText: emailHint(),
                        suffixIcon: InkWell(
                          child: Icon(Icons.cancel_outlined,
                              color: Colors.grey[600]),
                          onTap: () {
                            _emailAddressController.clear();
                            setState(() {});
                          },
                        ),
                      )),
            onChanged: (value) {
              emailAddressChanged(value);
            },
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 60),
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            controller: _passwordController,
            maxLength: 250,
            maxLengthEnforced: true,
            obscureText: !_showPassword,
            validator: (value) {
              return (value == null || value.length <= 3
                  ? "At least 4 characters"
                  : null);
            },
            decoration: InputDecoration(
              hintText: widget.authenticationAction ==
                      AuthenticationAction.CREATE_ACCOUNT
                  ? "Set Password"
                  : "Your password",
              suffixIcon: InkWell(
                child: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).textTheme.bodyText1.color),
                onTap: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),
            ),
            onChanged: (value) {
              passwordChanged(value);
            },
          ),
        ),
        PrimaryButton(
          onPressed: (!_isEmailValid || !_isPasswordValid)
              ? null
              : () {
                  Navigator.of(context).pushNamed(
                      CodeVerificationScreen.ROUTE_PATH,
                      arguments: CodeVerificationArgs(
                          mode: CodeVerificationMode.EMAIL,
                          authenticationAction: widget.authenticationAction,
                          destinationAddress: _emailAddressController.text,
                          password: _passwordController.text));
                },
        ),
      ],
    );
  }
}
