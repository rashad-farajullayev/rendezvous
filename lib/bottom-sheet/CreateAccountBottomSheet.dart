import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rendezvous/bottom-sheet/AvatarModalBottomSheet.dart';
import 'package:rendezvous/widgets/buttons/LinkButton.dart';
import 'package:rendezvous/widgets/buttons/SocialButton.dart';
import 'package:rendezvous/widgets/utils/Separator.dart';
import 'package:rendezvous/constants.dart';

void showCreateAccountBottomSheet(BuildContext context) {
  /*showCupertinoModalBottomSheet*/
  showAvatarModalBottomSheet(
      routeName: StringConstants.CREATE_ACCOUNT_ROUTE_NAME,
      context: context,
      isDismissible: true,
      expand: false,
      barrierColor: Colors.black.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(36.0),
      ),
      avatarWidget: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Center(
            //   child: SvgPicture.asset(AssetConstants.HAND_POINTER_ICON,
            //       color: Colors.grey[50],
            //       width: 45,
            //       height: 63,
            //       semanticsLabel: "hand pointer"),
            // ),
            // Center(
            //   child: Padding(
            //     padding: const EdgeInsets.only(
            //         top: 16.0, bottom: 26, left: 55, right: 55),
            //     child: Text(
            //       "Click on empty area if you want to explore Rendezvous",
            //       style: TextStyle(
            //         fontSize: 18,
            //         fontFamily: "Roboto",
            //         fontWeight: FontWeight.w200,
            //         color: Colors.grey[50],
            //         decoration: TextDecoration.none,
            //       ),
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      builder: (ctx) {
        return CreateAccountBottomSheet();
      });
}

class CreateAccountBottomSheet extends StatelessWidget {
  const CreateAccountBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      // Navigator.of(context).pop();
                      Navigator.pushNamed(context, "/login",
                          arguments: AuthenticationAction.CREATE_ACCOUNT);
                    },
                    child: Text("CREATE AN ACCOUNT"),
                    color: Color(0xff486CD6),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text("Already have an account?"),
                      LinkButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/login",
                                arguments: AuthenticationAction.LOGIN);
                          },
                          linkText: "Sign in"),
                    ]),
                  ),
                  // Separator(
                  //   text: StringConstants.OR_SEPARATOR,
                  //   height: 70,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       vertical: 6.0, horizontal: 0),
                  //   child: SocialButton(
                  //     svgIconName: AssetConstants.FACEBOOK_ICON,
                  //     buttonText: "Continue with Facebook",
                  //     iconColor: Color.fromARGB(255, 24, 119, 242),
                  //     onPressed: () {
                  //       print("Login with facebook");
                  //       Navigator.of(context).pop();
                  //     },
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       vertical: 6.0, horizontal: 0),
                  //   child: SocialButton(
                  //     svgIconName: AssetConstants.GOOGLE_ICON,
                  //     buttonText: "Continue with Google",
                  //     onPressed: () {
                  //       print("Login with Google");
                  //       Navigator.of(context).pop();
                  //     },
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       vertical: 6.0, horizontal: 0),
                  //   child: SocialButton(
                  //     svgIconName: AssetConstants.APPLE_ICON,
                  //     buttonText: "Continue with Apple",
                  //     onPressed: () {
                  //       print("Login with Apple");
                  //       Navigator.of(context).pop();
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}
