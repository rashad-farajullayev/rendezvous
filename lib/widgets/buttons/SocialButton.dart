import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialButton extends StatelessWidget {
  final String svgIconName;
  final String buttonText;
  final Color iconColor;
  final VoidCallback onPressed;

  SocialButton({
    Key key,
    @required VoidCallback this.onPressed,
    @required this.buttonText,
    @required this.svgIconName,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: this.onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(this.svgIconName,
              color: iconColor,
              width: 24,
              height: 24,
              semanticsLabel: this.buttonText),
          Expanded(
              child: Center(
                  child: Text(
            this.buttonText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
          ))),
        ],
      ),
      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      splashColor: Colors.transparent,
      highlightColor: Colors.grey.shade200,
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
            color: Theme.of(context).dividerColor,
            style: BorderStyle.solid,
            width: 1.0),
      ),
      animationDuration: Duration(seconds: 0),
    );
  }
}
