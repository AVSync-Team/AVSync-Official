import 'package:flutter/material.dart';

class MusicPage extends StatefulWidget {
  MusicPage({Key key}) : super(key: key);

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        width: size.width,
        height: size.height,
        child: Text('Rishabh'));
  }
}
