import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/appDrawer.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  final String aboutUs =
      '''Us being movieholics, we used to watch movies while sharing our screens , one guy would share their screen and others would watch the movie\nThe problem we had was the quality and the sync issue , that\'s a funny one as to watch in sync we would start the movie by saying 1 ,2,3 and go.\nThat\'s when we came up with this idea of developing an app that would play your favourite movie and series with sync and plus you can also chat with your friends while wathcing.Have fun !! '
      ''';

  final String binaryCoders =
      'We call ourselves as binary coders.\nWe consist of:\n\nSidharth Bansal\n\nManav Parikh\n\nRishabh Mishra';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: CustomThemeData.customBlack),
      drawer: MainDrawer(),
      backgroundColor: CustomThemeData.customBlack,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Container(
            padding: const EdgeInsets.only(left: 20.0, top: 30, right: 20.0),
            child: Text(
              aboutUs,
              style: TextStyle(color: Colors.white, letterSpacing: 1.5),
              // maxLines: 2,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20.0, top: 30),
            child: Text(
              binaryCoders,
              style: TextStyle(color: Colors.white, letterSpacing: 1.5),
              // maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
