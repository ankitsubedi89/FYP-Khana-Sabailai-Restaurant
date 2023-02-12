import 'package:flutter/material.dart';

class CircularBtn extends StatelessWidget {
  const CircularBtn({Key? key, required this.onTap, required this.icon})
      : super(key: key);
  final Function onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Icon(icon)));
  }
}
