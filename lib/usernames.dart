import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class usernames extends StatefulWidget {
  const usernames({Key? key}) : super(key: key);

  @override
  State<usernames> createState() => _usernamesState();
}

class _usernamesState extends State<usernames> {
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
      body: Container(
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Text('Instagram: miguelalejandrosp9', style: TextStyle(
                    fontFamily: 'PTSansNarrow',
                    fontSize: 20,
                    color: Colors.white
                  ),)
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Text('Twiter: MiguelASPx', style: TextStyle(
                      fontFamily: 'PTSansNarrow',
                      fontSize: 20,
                      color: Colors.white
                  ),)
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Text('Valorant: HotLocalMike#3277', style: TextStyle(
                      fontFamily: 'PTSansNarrow',
                      fontSize: 20,
                      color: Colors.white
                  ),)
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Text('League Of Legends: MikeLordx', style: TextStyle(
                      fontFamily: 'PTSansNarrow',
                      fontSize: 20,
                      color: Colors.white
                  ),)
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Text('Rainbow Six: HotLocalMike', style: TextStyle(
                      fontFamily: 'PTSansNarrow',
                      fontSize: 20,
                      color: Colors.white
                  ),)
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
