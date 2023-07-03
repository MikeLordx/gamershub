import 'dart:convert';
import 'package:gamershub/favorites.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamershub/register.dart';
import 'package:http/http.dart' as http;
import 'addgames.dart';
import 'registros.dart';
import 'editar.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Addgames extends StatefulWidget {
  const Addgames({Key? key}) : super(key: key);

  @override
  State<Addgames> createState() => _AddgamesState();
}

class _AddgamesState extends State<Addgames> {

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

  String? img;
  String? gamename;
  String? gamertag;
  String? rank;

  subir_producto(image, game) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedid = preferences.getString('id');
    });

    var url = Uri.parse('https://asaicollection.com/gamershub/añadir_favorito.php');
    var response = await http.post(url, body: {
      'user' : savedid,
      'img' : image,
      'gamename': game,
    }).timeout(Duration(seconds: 90));

    //print(response.body);

    if (response.body == '1') {
      setState(() {
        mostrar_alertasuccess('El juego fue guardado correctamente');
      });
    } else {
      mostrar_alerta("Ese juego ya existe en tus favoritos");
    }
  }

  void _show() async {
    setState(() {
      SmartDialog.showLoading();
    });

    await Future.delayed(Duration(seconds: 2)); // Esperar 2 segundos

    setState(() {
      SmartDialog.dismiss();
    });
  }


  String? savedid;

  Future<void> ver_datos() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedid = preferences.getString('id')!;
      print(savedid);
    });
  }

  mostrar_alertasuccess(mensaje){
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return favorites();
                    }
                )
                );
              },
                  child: Text('Aceptar'))
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            children: [
              Text('Select a game   '),
            ],
          ),
          backgroundColor: Color.fromRGBO(27, 4, 64, 1),
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
                  decoration: BoxDecoration(
                    color: Colors.white, // Puedes cambiar el color de fondo según tus necesidades
                    borderRadius: BorderRadius.circular(10), // Define los bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8), // Color de la sombra
                        spreadRadius: 2, // Ancho de la sombra
                        blurRadius: 5, // Difuminado de la sombra
                        offset: Offset(0, 3), // Desplazamiento de la sombra en el eje x, y
                      ),
                    ],
                  ),
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Expanded(
                              child: Image.asset(reg[index].image!, width: 150)
                          ),
                        ),
                        Expanded(
                          child: Text(reg[index].gamename!, style: const TextStyle(
                            fontSize: 12,
                          ),),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: InkWell(
                                  onTap: (){
                                    _show();
                                    subir_producto(reg[index].image, reg[index].gamename);
                                  },
                                  child: Icon(Icons.add, color: Colors.green,)),
                            ),
                          ],
                        ),

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
