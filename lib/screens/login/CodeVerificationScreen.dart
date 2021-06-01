import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rendezvous/constants.dart';
import 'package:rendezvous/providers/AuthenticationProvider.dart';
import 'package:rendezvous/screens/login/ChooseUserNameScreen.dart';
import 'package:rendezvous/widgets/CountdownTimer.dart';
import 'package:rendezvous/widgets/VerificationCodeInput.dart';
import 'package:rendezvous/widgets/buttons/LinkButton.dart';
import 'package:rendezvous/widgets/buttons/PrimaryButton.dart';

enum CodeVerificationMode { SMS, EMAIL }

class CodeVerificationArgs {
  final CodeVerificationMode mode;
  final String destinationAddress;
  final String password;
  final AuthenticationAction authenticationAction;

  CodeVerificationArgs(
      {@required this.mode,
      @required this.destinationAddress,
      this.password,
      @required this.authenticationAction});
}

class CodeVerificationScreen extends StatefulWidget {
  static const ROUTE_PATH = "/login/code-verification";

  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  CodeVerificationArgs arguments;
  String _verificationCode = "";
  bool _canSendCodeAgain = false;
  CountdownTimerWidget _timer;

  @override
  Widget build(BuildContext context) {
    this.arguments = ModalRoute.of(context).settings.arguments;

    if (_timer == null) {
      _timer = CountdownTimerWidget(onFinish: () {
        setState(() {
          _canSendCodeAgain = true;
        });
      });

      Future.delayed(Duration(milliseconds: 10))
          .then((value) => _timer.start(120000));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Verification code",
            style:
                TextStyle(color: Theme.of(context).textTheme.headline5.color)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: _timer,
          ),
          Text(
            (arguments.mode == CodeVerificationMode.SMS
                ? "We sent you an SMS code"
                : "We sent you an Email code"),
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 32),
            child: Text(
              getDestinationAddress(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1.color,
                  fontWeight: FontWeight.w300,
                  fontSize: 16),
            ),
          ),
          VerificationCodeInput(
            length: 4,
            onCompleted: (value) {
              print("on completed:" + value);
            },
            onChanged: (value) {
              setState(() {
                _verificationCode = value;
              });
            },
            textStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyText1.color,
                fontSize: 25),
            itemDecoration: BoxDecoration(
              border: Border.all(
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Colors.grey[300]
                        : Colors.grey[400],
              ),
              // color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: LinkButton(
              linkText: "Send verification code again",
              underline: true,
              alignment: Alignment.center,
              onPressed: (!_canSendCodeAgain
                  ? null
                  : () {
                      setState(() {
                        _canSendCodeAgain = false;
                        _timer.stop();
                        _timer.start(120000);
                      });
                      print("Send verification code aghain pressed");
                    }),
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                label: "Verify",
                onPressed: (_verificationCode.length != 4
                    ? null
                    : () {
                        if (arguments.authenticationAction ==
                            AuthenticationAction.CREATE_ACCOUNT) {
                          Navigator.of(context).pushReplacementNamed(
                              ChooseUserNameScreen.ROUTE_PATH);
                        } else {
                          Navigator.of(context).popUntil(ModalRoute.withName(
                              StringConstants.CREATE_ACCOUNT_ROUTE_NAME));

                          Navigator.of(context).pop();
                          Provider.of<AuthenticationProvider>(context,
                                  listen: false)
                              .login();
                        }
                      }),
              ))
        ]),
      ),
    );
  }

  String getDestinationAddress() {
    switch (arguments.mode) {
      case CodeVerificationMode.SMS:
        return "to number: ${arguments.destinationAddress}";
      case CodeVerificationMode.EMAIL:
        return "to address: ${arguments.destinationAddress}";
      default:
        return "";
    }
  }
}
