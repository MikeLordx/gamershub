import 'package:flutter/material.dart';

class favorites extends StatefulWidget {
  const favorites({Key? key}) : super(key: key);

  @override
  State<favorites> createState() => _favoritesState();
}

class _favoritesState extends State<favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        color: Color.fromRGBO(27, 4, 64, 1),
        child: ListView(
            children: [
      Container(
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Image.asset('images/lol.jpg', width: 140, height: 80,),
                ),
                Container(
                  child: Text('League Of Legends',
                    style: TextStyle(
                      fontFamily: 'PTSansNarrow',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Image.asset('images/fortnite.jpg', width: 140, height: 80,),
                ),
                Container(
                  child: Text('Fortnite',
                    style: TextStyle(
                      fontFamily: 'PTSansNarrow',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Image.asset('images/minecraft.jpg', width: 140, height: 80,),
                ),
                Container(
                  child: Text('Minecraft',
                    style: TextStyle(
                      fontFamily: 'PTSansNarrow',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Image.asset('images/fallguys.jpg', width: 140, height: 80,),
                ),
                Container(
                  child: Text('Fall Guys',
                    style: TextStyle(
                      fontFamily: 'PTSansNarrow',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
              Container(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Image.asset('images/clashroyale.jpg', width: 140, height: 80,),
                        ),
                        Container(
                          child: Text('Clash Royale',
                            style: TextStyle(
                              fontFamily: 'PTSansNarrow',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Image.asset('images/fifa23.jpg', width: 140, height: 80,),
                        ),
                        Container(
                          child: Text('FIFA 23',
                            style: TextStyle(
                              fontFamily: 'PTSansNarrow',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ],
    ),
      ),
    );
  }
}
