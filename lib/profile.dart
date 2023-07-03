import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamershub/favorites.dart';
import 'package:gamershub/login.dart';
import 'package:gamershub/usernames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aboutme.dart';
import 'home.dart';
import 'editprofile.dart';
import 'subscribe.dart';
import 'registros.dart';
import 'package:http/http.dart' as http;

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> with SingleTickerProviderStateMixin{

  int paginaSeleccionada = 0;
  late TabController controller;
  bool loading = true;

  List<Registros> reg = [];

  String? savedid;

  String saveduser = '';
  String savedpass = '';

  Future<List<Registros>> mostrar_productos() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedid = preferences.getString('id')!;
    });
    print(savedid);

    var url = Uri.parse('https://asaicollection.com/gamershub/mostrar_juegosfav.php');
    var response = await http.post(url, body: {
      'userid' : savedid,
    }).timeout(Duration(seconds: 90));

    print(response.body);

    final datos = jsonDecode(response.body);

    List<Registros> registros = [];

    for(var datos in datos){
      registros.add(Registros.fromJson(datos));
    }

    return  registros;
  }

  Future<void> eliminar_datos(context) async{
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context){
          return login();
        }
    )
    );
  }

  Future<void> gohome(context) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return home();
        }
    )
    );
  }

  Future<void> goprofile(context) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return profile();
        }
    )
    );
  }

  Future<void> gofavorites(context) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return favorites();
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
    controller = TabController(length: 3, vsync: this);
    controller.animateTo(1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('images/logogamershub.png', width: 40),
          ],
        ),
        backgroundColor: Color.fromRGBO(62, 0, 141, 1),
      ),
        body:
        Container(
          color: Color.fromRGBO(27, 4, 64, 1),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child:
            Column(
              children: [
                Expanded(
                  child: TabBarView(
                      controller: controller,
                      children: [
                        aboutme(),
                        favorites(),
                        usernames(),
                      ]
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Color.fromRGBO(62, 0, 141, 1),),
                      )
                  ),
                  child: Material(
                    color: Colors.white,
                    child: TabBar(
                      controller: controller,
                      indicator: BoxDecoration(
                        color: Color.fromRGBO(62, 0, 141, 1),
                      ),
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(
                          child: Container(
                            child: Text('About Me', style: TextStyle(
                              fontFamily: 'PTSansNarrow',
                              fontSize: 17,
                            ),),
                          ),
                        ),
                        Tab(
                          child: Container(
                            child: Text('Favorites', style: TextStyle(
                              fontFamily: 'PTSansNarrow',
                              fontSize: 17,
                            ),),
                          ),
                        ),
                        Tab(
                          child: Container(
                            child: Text('Profile', style: TextStyle(
                              fontFamily: 'PTSansNarrow',
                              fontSize: 17,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
