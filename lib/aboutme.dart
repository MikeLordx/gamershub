import 'package:flutter/material.dart';

class aboutme extends StatefulWidget {
  const aboutme({Key? key}) : super(key: key);

  @override
  State<aboutme> createState() => _aboutmeState();
}

class _aboutmeState extends State<aboutme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(27, 4, 64, 1),
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: Image.asset('images/fifa23.jpg', width: 80, height: 80,),
            ),
            Text('     MikeLordx'),
          ],
        ),
        backgroundColor: Color.fromRGBO(27, 4, 64, 1),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text('Part time Twitch streamer from Mexico I like to play videogames since I was like no more '
                'than 5 or 6 years old, I remember starting with Crash Bandicoot on the PSOne all the way to nowadays playing '
                'Red Dead Redemption', style: TextStyle(
              fontFamily: 'PTSansNarrow',
              fontSize: 15,
              color: Colors.white,
            ),),
          ),
        ],
      ),
    );
  }
}
