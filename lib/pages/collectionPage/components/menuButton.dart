import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CollectionPageMenuButton extends StatelessWidget {
  CollectionPageMenuButton({@required this.onPressed, @required this.icon});
  final GestureTapCallback onPressed;
  final Icon icon;

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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: icon,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
