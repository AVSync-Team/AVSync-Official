import 'package:flutter/material.dart';

class AnyVideoFromBrowserPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
    );
  }
}
