import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gamershub/editarcomentario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'registros.dart';
import 'editar.dart';

class gamescreen extends StatefulWidget {
  const gamescreen({Key? key}) : super(key: key);

  @override
  State<gamescreen> createState() => _gamescreenState();
}

class _gamescreenState extends State<gamescreen> {

  bool loading = true;

  List<Registros> reg = [];

  var c_comment = new TextEditingController();


  String? commentid;
  String? comment;
  String savedgameid = '';
  String savedgamename = '';
  String savedid = '';
  String savedimage = '';
  String savedname = '';

  subir_producto() async {
    var url = Uri.parse(
        'https://asaicollection.com/gamershub/guardar_comentario.php');
    var response = await http.post(url, body: {
      'gameid': savedgameid,
      'userid': savedid,
      'username' : savedname,
      'comment': comment,
    }).timeout(Duration(seconds: 90));

    //print(response.body);

    if (response.body == '1') {
      mostrar_alerta('Se guardo el comentario correctamente');
      c_comment.text == '';
    } else {
      mostrar_alerta(response.body);
    }
  }

  Future eliminar_producto(id) async {

    var url = Uri.parse('https://asaicollection.com/gamershub/eliminar_comentario.php');

    var response = await http.post(url, body: {
      'id' : commentid,
    }).timeout(const Duration(seconds: 90));

    print(response.body);

    if(response.body == '1'){
      mostrar_alerta('El comentario se elimino correctamente');
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

  msn_eliminar(id, nombre){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Gamers Hub'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('¿Realmente quieres eliminar tu comentario?'),
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return gamescreen();
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

  Future<void> ver_datos() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedgameid = preferences.getString('gameid')!;
      savedgamename = preferences.getString('gamename')!;
      savedimage = preferences.getString('image')!;
      savedid = preferences.getString('id')!;
      savedname = preferences.getString('email')!;
    });
    print(savedgameid);
    print(savedgamename);
    print(savedimage);
    print(savedname);
  }

  Future<List<Registros>> mostrar_productos() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedid = preferences.getString('id')!;
    });
    print(savedid);

    var url = Uri.parse('https://asaicollection.com/gamershub/mostrar_comentarios.php');
    var response = await http.post(url, body: {
      'userid' : savedid,
      'username' : savedname,
      'gameid' : savedgameid,
    }).timeout(Duration(seconds: 90));

    print(response.body);

    final datos = jsonDecode(response.body);

    List<Registros> registros = [];

    for(var datos in datos){
      registros.add(Registros.fromJson(datos));
    }

    return  registros;
  }

  editar_producto(commentid) async {
    var url = Uri.parse(
        'https://asaicollection.com/gamershub/editar_comentario.php');
    var response = await http.post(url, body: {
      'commentid' : commentid,
      'comment': comment,
    }).timeout(Duration(seconds: 90));

    //print(response.body);

    if (response.body == '1') {
      Navigator.of(context).pop();
      mostrar_alerta('Se modifico el comentario correctamente');
      c_comment.text == '';
    } else {
      mostrar_alerta(response.body);
    }
  }

  Future<void>mandar_comentario() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('commentid', commentid!);
    await preferences.setString('comment', comment!);
  }

  Future<void> goeditcomment(context) async {
    mandar_comentario();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return EditarComentario();
        }
    )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mandar_comentario();
    ver_datos();
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
        title: 
            Image.asset('images/logogamershub.png', width: 40),
        backgroundColor: Color.fromRGBO(62, 0, 141, 1),
      ),
      body:loading == true ?

      Center(
        child: CircularProgressIndicator(),
      )

          : reg.isEmpty ?

      ListView(
        children: [
          Container(
            color: Color.fromRGBO(27, 4, 64, 1),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                  child: Text(savedgamename, style: TextStyle(
                    fontFamily: 'PTSansNarrow',
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Image.asset(savedimage, width: 200,),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Comentarios',
                    style: TextStyle(
                      fontFamily: 'PTSansNarrow',
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  controller: c_comment,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.send,
                  autocorrect: true,
                  textCapitalization: TextCapitalization.words,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    helperText: 'Comment',
                    helperStyle: TextStyle(
                      color: Colors.white
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.pink,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: (){
                      comment = c_comment.text;

                      if(comment == ''){
                        mostrar_alerta('Debes llenar todos los datos');
                      }
                      else{
                        subir_producto();
                      }
                    },
                    child: Text('Save comment'),
                ),
                Container(
                  color: Color.fromRGBO(27, 4, 64, 1),
                  child: Center(
                    child: Text('No comments registered', style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )

          : SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            final FocusScopeNode focus = FocusScope.of(context);
            if (!focus.hasPrimaryFocus && focus.hasFocus) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: Container(
            color: Color.fromRGBO(27, 4, 64, 1),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(
                    savedgamename,
                    style: TextStyle(
                      fontFamily: 'PTSansNarrow',
                      color: Colors.white,
                      fontSize: 24,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Image.asset(
                    savedimage,
                    width: 200,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Comentarios',
                    style: TextStyle(
                      fontFamily: 'PTSansNarrow',
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  controller: c_comment,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.send,
                  autocorrect: true,
                  textCapitalization: TextCapitalization.words,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    helperText: 'Comment',
                    helperStyle: TextStyle(color: Colors.white),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      borderSide: BorderSide(
                        color: Colors.pink,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    comment = c_comment.text;

                    if (comment == '') {
                      mostrar_alerta('Debes llenar todos los datos');
                    } else {
                      subir_producto();
                    }
                  },
                  child: Text('Save comment'),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: reg.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white, // Color del borde blanco
                          width: 2.0, // Grosor del borde
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 100),
                            child: Expanded(
                              child: Text(
                                reg[index].username!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'PTSansNarrow',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              reg[index].comment!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'PTSansNarrow',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          if(savedid == reg[index].userid!)
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                commentid = reg[index].commentid;
                                comment = reg[index].comment;
                                goeditcomment(context);
                              },
                              child: Icon(Icons.edit, color: Colors.green),
                            ),
                          ),
                          if(savedid == reg[index].userid!)
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                commentid = reg[index].commentid;
                                msn_eliminar(commentid, reg[index].comment);
                              },
                              child: Icon(Icons.delete, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      )





    );
  }
}
