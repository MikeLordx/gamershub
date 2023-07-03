import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'gamewindow.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class EditarComentario extends StatefulWidget {
  const EditarComentario({Key? key}) : super(key: key);

  @override
  State<EditarComentario> createState() => _EditarComentarioState();
}

class _EditarComentarioState extends State<EditarComentario> {

  String savedcommentid = '';
  String savedcomment = '';

  var c_comment = new TextEditingController();
  String? comment;

  Future<void> ver_datos() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedcommentid = preferences.getString("commentid")!;
      savedcomment = preferences.getString("comment")!;
    });
  }

  Future mostrar_datos() async{
    var url = Uri.parse('https://asaicollection.com/gamershub/ver_comentario.php');
    var response = await http.post(url, body: {
      'commentid' : savedcommentid
    }).timeout(Duration(seconds: 90));

    var datos = jsonDecode(response.body);

    c_comment.text = datos['comment'];
  }

  editar_producto() async {
    var url = Uri.parse(
        'https://asaicollection.com/gamershub/editar_comentario.php');
    var response = await http.post(url, body: {
      'commentid' : savedcommentid,
      'comment': comment,
    }).timeout(Duration(seconds: 90));

    //print(response.body);

    if (response.body == '1') {
      Navigator.of(context).pop();
      setState(() {
        mostrar_alerta('El comentario fue cambiado correctamente');
      });
      c_comment.text == '';
    } else {
      mostrar_alerta(response.body);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ver_datos();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

        final FocusScopeNode focus = FocusScope.of(context);
        if(!focus.hasPrimaryFocus && focus.hasFocus){
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit comment'),
          backgroundColor: Color.fromRGBO(27, 4, 64, 1),
        ),
        body: Container(
          color: Color.fromRGBO(27, 4, 64, 1),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: c_comment,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        helperText: 'Comment',
                        helperStyle: TextStyle(
                          color: Colors.white,
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
                    SizedBox(height: 10,),
                    ElevatedButton(onPressed: (){
                      comment = c_comment.text;
                      if(comment == ''){
                        mostrar_alerta('Debes de llenar todos los datos');
                      }else{
                        editar_producto();
                      }
                    },
                        child: Text('Edit')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
