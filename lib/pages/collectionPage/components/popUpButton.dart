import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PopUpButton extends StatelessWidget {
  PopUpButton(
      {@required this.onPressed, @required this.text, @required this.color});
  final GestureTapCallback onPressed;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Card(
        shadowColor: Theme.of(context).shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: MaterialButton(
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).accentColor),
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
