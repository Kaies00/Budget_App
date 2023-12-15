import 'package:flutter/material.dart';

import '../../values.dart';

class ForthPage extends StatefulWidget {
  final bool drawerIsOpen;
  final double xOffset;
  final double yOffset;
  final double scale;

  const ForthPage(
      {Key? key,
      required this.drawerIsOpen,
      required this.xOffset,
      required this.yOffset,
      required this.scale})
      : super(key: key);

  @override
  State<ForthPage> createState() => _ForthPageState();
}

class _ForthPageState extends State<ForthPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 500,
      ),
      transform: Matrix4.translationValues(
          widget.xOffset - 60, widget.yOffset + 100, 0)
        ..scale(widget.scale - 0.3),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.drawerIsOpen ? 40 : 0),
          color: eColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(-10, 5),
              color: Color.fromRGBO(176, 190, 197, 1),
              blurRadius: 5,
              spreadRadius: 5,
            ),
            BoxShadow(
              offset: Offset(-5, 0),
              color: Color.fromRGBO(176, 190, 197, 1),
              blurRadius: 5,
              spreadRadius: 5,
            ),
          ],
        ),
      ),
    );
  }
}
