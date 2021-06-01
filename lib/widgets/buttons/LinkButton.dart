import 'package:flutter/material.dart';

class LinkButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String linkText;
  final Color color;
  final Alignment alignment;
  final bool underline;

  LinkButton(
      {Key key,
      @required this.onPressed,
      @required this.linkText,
      this.alignment,
      this.underline,
      this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed?.call();
      },
      child: Align(
          alignment: this.alignment ?? Alignment.centerRight,
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                this.linkText,
                style: TextStyle(
                    color: this.color ?? defaultLinkColor(context),
                    fontWeight: FontWeight.w400,
                    decoration: this.underline != null && this.underline
                        ? TextDecoration.underline
                        : TextDecoration.none),
              ))),
    );
  }

  Color defaultLinkColor(BuildContext ctx) {
    if (this.onPressed == null) return Colors.grey[500];

    return MediaQuery.of(ctx).platformBrightness == Brightness.dark
        ? Colors.white54
        : Color(0xff486cd6);
  }
}
