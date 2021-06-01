import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  PrimaryButton({@required this.onPressed, this.label});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;

    return FlatButton(
      onPressed: onPressed,
      child: Text(this.label ?? "NEXT"),
      color: Theme.of(context).primaryColor,
      disabledColor:
          (brightness == Brightness.light ? Colors.grey[200] : Colors.black26),
      textColor: Colors.white,
      disabledTextColor: Colors.grey[500],
      padding: EdgeInsets.all(15),
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
