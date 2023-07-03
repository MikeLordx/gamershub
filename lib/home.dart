import 'package:flutter/material.dart';
import 'package:gamershub/signinscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'register.dart';
import 'login.dart';
import 'profile.dart';
import 'favorites.dart';
import 'editprofile.dart';
import 'subscribe.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

Future<void> eliminar_datos(context) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.clear();

  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context){
        return login();
      }
  )
  );
}

String savedid = '';
String saveduser = '';
String savedpass = '';

Future<void> ver_datos() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    savedid = preferences.getString('id')!;
    saveduser = preferences.getString('email')!;
    savedpass = preferences.getString('password')!;
  });
  if(savedid != null){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return signinscreen(savedid);
        }
    )
    );
  }
}

Future<void> gohome(context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();


  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return home();
      }
  )
  );
}

Future<void> goprofile(context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();


  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return profile();
      }
  )
  );
}

Future<void> gofavorites(context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.clear();

  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return favorites();
      }
  )
  );
}

Future<void> goeditprofile(context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.clear();

  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return editprofile('id');
      }
  )
  );
}

Future<void> gosubcription(context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.clear();

  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return subscription();
      }
  )
  );
}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    ver_datos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('images/logogamershub.png', width: 40),
        backgroundColor: Color.fromRGBO(62, 0, 141, 1),
      ),
      endDrawer: Drawer(
        width: 200,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(43, 0, 36, 1)
          ),
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.home, color: Colors.white,),
                title: Text('Home', style: TextStyle(
                  color: Colors.white,
                  ),
                ),
                onTap: (){
                  gohome(context);
                },
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 400, 0, 0),
                child: ListTile(
                  leading: Icon(CupertinoIcons.power, color: Colors.white,),
                  title: Text('Sign In', style: TextStyle(
                    color: Colors.white,
                    ),
                  ),
                  onTap: (){
                    eliminar_datos(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(27, 4, 64, 1),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Popular',
                  style: TextStyle(
                    fontFamily: 'PTSansNarrow',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
            Container(
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Image.asset('images/freefire.jpg', width: 140, height: 80,),
                      ),
                      Container(
                        child: Text('Free Fire',
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
                        child: Image.asset('images/pokemonunite.jpg', width: 140, height: 80,),
                      ),
                      Container(
                        child: Text('Pokemon Unite',
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
                        child: Image.asset('images/pubg.jpg', width: 140, height: 80,),
                      ),
                      Container(
                        child: Text('PUBG',
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
                        child: Image.asset('images/valorant.jpg', width: 140, height: 80,),
                      ),
                      Container(
                        child: Text('Valorant',
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
