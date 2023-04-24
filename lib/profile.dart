import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamershub/favorites.dart';
import 'package:gamershub/login.dart';
import 'package:gamershub/usernames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aboutme.dart';
import 'home.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> with SingleTickerProviderStateMixin{

  int paginaSeleccionada = 0;
  TabController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 3, initialIndex: paginaSeleccionada, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
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

    await preferences.clear();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return home();
        }
    )
    );
  }

  Future<void> goprofile(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.clear();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              Divider(
                color: Color.fromRGBO(71, 0, 96, 1),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.white,),
                title: Text('Profile', style: TextStyle(
                  color: Colors.white,
                ),
                ),
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
              Container(
                padding: EdgeInsets.fromLTRB(0, 220, 0, 0),
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
                            child: Text('Usernames', style: TextStyle(
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
