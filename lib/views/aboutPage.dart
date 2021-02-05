import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  final String aboutUs =
      'Us being movieholics, we used to watch movies while sharing our screens , one guy would share their screen and others would watch the movie\nThe problem we had was the quality and the sync issue , that\'s a funny one as to watch in sync we would start the movie by saying 1 ,2,3 and go.\nThat\'s when we came up with this idea of developing an app that would play your favourite movie and series with sync and plus you can also chat with your friends while wathcing.Have fun !! ';

  final String binaryCoders =
      'We call ourselves as binary coders.We consist of:\nSidharth Bansal\nManav Parikh\nRishabh Mishra';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292727),
      body: Center(
        child: Card(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
