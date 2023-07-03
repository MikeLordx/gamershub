import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamershub/register.dart';
import 'package:http/http.dart' as http;
import 'addgames.dart';
import 'registros.dart';
import 'editar.dart';

class favorites extends StatefulWidget {
  const favorites({Key? key}) : super(key: key);

  @override
  State<favorites> createState() => _favoritesState();
}

class _favoritesState extends State<favorites> {

  bool loading = true;

  List<Registros> reg = [];

  String? savedid;

  String saveduser = '';
  String savedpass = '';

  Future<void> ver_datos() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      saveduser = preferences.getString('email')!;
      savedpass = preferences.getString('password')!;
    });
    print(saveduser);
    print(savedpass);
  }

  Future<List<Registros>> mostrar_productos() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedid = preferences.getString('id');
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

  msn_eliminar(id, nombre){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Gamers Hub'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('¿Realmente quieres eliminar ' + nombre + '?'),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
                eliminar_producto(id);
              },
                child: Text('Aceptar'),
              ),
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              },
                  child: Text('Cancelar'))
            ],
          );
        }
    );
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

  Future eliminar_producto(id) async {
    var url = Uri.parse('https://asaicollection.com/gamershub/eliminar_juego.php');

    var response = await http.post(url, body: {
      'id' : id
    }).timeout(const Duration(seconds: 90));

    if(response.body == '1'){
      mostrar_alerta('El juego se elimino correctamente');
      setState(() {
        loading = true;
        reg = [];
        mostrar_productos().then((value){
          setState(() {
            reg.addAll(value);
            loading = false;
          });
        });
      });
    }else{
      mostrar_alerta(response.body);
    }
  }

  Future<void> goAddGames(context) async {
    ver_datos();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return Addgames();
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
    return GestureDetector(
        onTap: () {
          final FocusScopeNode focus = FocusScope.of(context);
          if (!focus.hasPrimaryFocus && focus.hasFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: Image.asset('images/fifa23.jpg', width: 50, height: 50,),
              ),
              Text(saveduser),
              ElevatedButton(
                  onPressed: (){
                    goAddGames(context);
                  },
                  child: Icon(CupertinoIcons.add))
            ],
          ),
          backgroundColor: Color.fromRGBO(27, 4, 64, 1),
          automaticallyImplyLeading: false,
        ),
        body: loading == true ?

        Center(
          child: CircularProgressIndicator(),
        )

            : reg.isEmpty ?

        Center(
          child: Text('No games registered'),
        )

            : Container(
              color: Color.fromRGBO(27, 4, 64, 1),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
              itemCount: reg.length,
              itemBuilder: (BuildContext context, int index){
                return Container(
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Expanded(
                              child: Image.asset(reg[index].image!, width: 90)
                          ),
                        ),
                        Expanded(
                          child: Text(reg[index].gamename!, style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white
                          ),),
                        ),
                        Expanded(
                          child: Text('Gamertag: ' + reg[index].gamertag!, style: const TextStyle(
                            fontSize: 12,
                              color: Colors.white,
                          ),
                          ),
                        ),
                        Expanded(
                          child: Text('Rank: ' + reg[index].rank!, style: const TextStyle(
                            fontSize: 12,
                              color: Colors.white
                          ),),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                  ver_datos();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context){
                                        return Editar(reg[index].gameid!);
                                      }
                                  )
                                  ).then((value){
                                    setState(() {
                                      loading = true;
                                      reg = [];
                                      mostrar_productos().then((value){
                                        setState(() {
                                          reg.addAll(value);
                                          loading = false;
                                        });
                                      });
                                    });
                                  });
                                },
                                child: Icon(Icons.edit, color: Colors.purple,)),
                            SizedBox(width: 30,),
                            InkWell(
                                onTap: (){
                                  msn_eliminar(reg[index].gameid, reg[index].gamename);
                                },
                                child: Icon(Icons.delete, color: Colors.red,)),
                          ],
                        ),
                        Text('Edit to add more info', style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),),
                      ],
                    ),
                  ),
                );
              }),
            ),

      ),
    );
  }
}
