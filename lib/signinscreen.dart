import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gamershub/usernames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'register.dart';
import 'login.dart';
import 'profile.dart';
import 'favorites.dart';
import 'editprofile.dart';
import 'subscribe.dart';
import 'home.dart';
import 'registros.dart';
import 'gamewindow.dart';

class signinscreen extends StatefulWidget {

  String userid;

  signinscreen(this.userid, {Key? key}) : super(key: key);


  @override
  State<signinscreen> createState() => _signinscreenState();
}

class _signinscreenState extends State<signinscreen> {

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
    print(savedid);
    print(saveduser);
    print(savedpass);
  }

  bool loading = true;

  List<Registros> reg = [];

  Future<List<Registros>> mostrar_productos() async {
    var url = Uri.parse('https://asaicollection.com/gamershub/mostrar_juegos.php');
    var response = await http.post(url).timeout(Duration(seconds: 90));

    //print(response.body);

    final datos = jsonDecode(response.body);

    List<Registros> registros = [];

    for(var datos in datos){
      registros.add(Registros.fromJson(datos));
    }

    return  registros;
  }

  mostrar_alerta(mensaje){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Gamers Hub'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(mensaje),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              },
                  child: Text('Aceptar'))
            ],
          );
        }
    );
  }

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

  Future<void> gohome(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedid = preferences.getString('id')!;
      saveduser = preferences.getString('email')!;
      savedpass = preferences.getString('password')!;
    });

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return home();
        }
    )
    );
  }

  Future<void> goprofile(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedid = preferences.getString('id')!;
      saveduser = preferences.getString('email')!;
      savedpass = preferences.getString('password')!;
    });

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return profile();
        }
    )
    );
  }

  Future<void> gofavorites(context) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedid = preferences.getString('id')!;
      saveduser = preferences.getString('email')!;
      savedpass = preferences.getString('password')!;
    });

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return favorites();
        }
    )
    );
  }

  Future<void> goeditprofile(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedid = preferences.getString('id')!;
      saveduser = preferences.getString('email')!;
      savedpass = preferences.getString('password')!;
    });

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return editprofile(savedid);
        }
    )
    );
  }

  Future<void> gosubcription(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedid = preferences.getString('id')!;
      saveduser = preferences.getString('email')!;
      savedpass = preferences.getString('password')!;
    });

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return subscription();
        }
    )
    );
  }

  Future<void> gogamewindow(context, id, gamename, image) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('gameid', id);
      await prefs.setString('gamename', gamename);
      await prefs.setString('image', image);
      print(id);
      print(gamename);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return gamescreen();
        }
    )
    );
  }

  Future<void> signout(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.clear();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return login();
        }
    )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ver_datos();
    print(savedid);
    mostrar_productos().then((value){
      setState(() {
        reg.addAll(value);
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('images/logogamershub.png', width: 40),
            Container(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text('Hello ' + saveduser + ' !'),
            )
          ],
        ),
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
              Divider(
                color: Color.fromRGBO(71, 0, 96, 1),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.white,),
                title: Text('Profile', style: TextStyle(
                  color: Colors.white,
                ),
                ),
                onTap: (){
                  goprofile(context);
                },
              ),
              Divider(
                color: Color.fromRGBO(71, 0, 96, 1),
              ),
              ListTile(
                leading: Icon(CupertinoIcons.heart_fill, color: Colors.white,),
                title: Text('Favorites', style: TextStyle(
                  color: Colors.white,
                ),
                ),
                onTap: (){
                  gofavorites(context);
                },
              ),
              Divider(
                color: Color.fromRGBO(71, 0, 96, 1),
              ),
              ListTile(
                leading: Icon(CupertinoIcons.person_2, color: Colors.white,),
                title: Text('Edit Profile', style: TextStyle(
                  color: Colors.white,
                ),
                ),
                onTap: (){
                  goeditprofile(context);
                },
              ),
              Divider(
                color: Color.fromRGBO(71, 0, 96, 1),
              ),
              ListTile(
                leading: Icon(CupertinoIcons.money_dollar, color: Colors.white,),
                title: Text('Subscribe', style: TextStyle(
                  color: Colors.white,
                ),
                ),
                onTap: (){
                  gosubcription(context);
                },
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 220, 0, 0),
                child: ListTile(
                  leading: Icon(CupertinoIcons.power, color: Colors.white,),
                  title: Text('Sign Out', style: TextStyle(
                    color: Colors.white,
                  ),
                  ),
                  onTap: (){
                    signout(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),

      body:loading == true ?

      Center(
        child: CircularProgressIndicator(),
      )

          : reg.isEmpty ?

      Center(
        child: Text('No games registered'),
      )

          : Container(
        color: Color.fromRGBO(27, 4, 64, 1),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Popular',
                style: TextStyle(
                  fontFamily: 'PTSansNarrow',
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: reg.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Expanded(
                            child: Image.asset(reg[index].image!, width: 150),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            reg[index].gamename!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'PTSansNarrow',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap: () {
                                  gogamewindow(context, reg[index].gameid, reg[index].gamename, reg[index].image);
                                },
                                child: Icon(Icons.info, color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
