import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final EdgeInsetsGeometry textPadding;
  final Divider divider;
  final double height;

  Separator(
      {Key key,
      this.text,
      this.textStyle,
      this.textPadding,
      this.divider,
      this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: this.height,
      child: this.text == null
          ? Expanded(
              child: this.divider ??
                  Divider(thickness: 1, color: Colors.grey[300]))
          : Row(
              children: [
                Expanded(
                    child: this.divider ??
                        Divider(thickness: 1, color: Colors.grey[300])),
                Padding(
                    padding: this.text == null
                        ? null
                        : this.textPadding ??
                            EdgeInsets.only(left: 30, right: 30),
                    child: Text(this.text,
                        style: this.textStyle ??
                            TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color))),
                Expanded(
                    child: this.divider ??
                        Divider(thickness: 1, color: Colors.grey[300]))
              ],
            ),
    );
  }
}
