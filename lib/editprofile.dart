import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamershub/favorites.dart';
import 'package:gamershub/forgotpassword.dart';
import 'package:gamershub/login.dart';
import 'package:gamershub/usernames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aboutme.dart';
import 'home.dart';
import 'profile.dart';
import 'editaboutme.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'registros.dart';

class editprofile extends StatefulWidget {

  String userid;

  editprofile(this.userid, {Key? key}) : super(key: key);

  @override
  State<editprofile> createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> with SingleTickerProviderStateMixin{

  var c_username = TextEditingController();
  var c_password = TextEditingController();
  var c_email = TextEditingController();
  var c_juegofavorito = TextEditingController();
  var c_edad = TextEditingController();

  String? username = '';
  String? password = '';
  String? email = '';
  String? juegofavorito = '';
  String? edad = '';

  String? savedid = '';

  editar_producto() async {
    var url = Uri.parse(
        'https://asaicollection.com/gamershub/editar_perfil.php');
    var response = await http.post(url, body: {
      'id' : widget.userid,
      'username': username,
      'password': password,
      'email' : email,
      'juegofavorito' : juegofavorito,
      'edad' : edad,
    }).timeout(Duration(seconds: 90));

    //print(response.body);

    if (response.body == '1') {
      Navigator.of(context).pop();
      mostrar_alerta('Se modifico el usuario correctamente');
      c_username.text = '';
      c_password.text = '';
      c_email.text = '';
      c_juegofavorito.text = '';
      c_edad.text = '';
    } else {
      mostrar_alerta(response.body);
    }
  }

  Future<void> ver_datos() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    savedid = (await preferences.getString('id'));
  }

  msn_eliminar(id){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Gamers Hub'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Realmente quieres eliminar tu perfil?'),
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

  Future eliminar_producto(id) async {
    var url = Uri.parse('https://asaicollection.com/gamershub/eliminar_usuario.php');

    var response = await http.post(url, body: {
      'id' : id
    }).timeout(const Duration(seconds: 90));

    if(response.body == '1'){
      mostrar_alerta('Tu cuenta se elimino correctamente');
      setState(() {
        reg = [];
        mostrar_productos().then((value){
          setState(() {
            reg.addAll(value);
            gohome(context);
          });
        });
      });

    }else{
      mostrar_alerta(response.body);
    }
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
      },
    );
  }

  List<Registros> reg = [];

  Future<List<Registros>> mostrar_productos() async {
    var url = Uri.parse('https://asaicollection.com/gamershub/mostrar_productos.php');
    var response = await http.post(url).timeout(Duration(seconds: 90));

    //print(response.body);

    final datos = jsonDecode(response.body);

    List<Registros> registros = [];

    for(var datos in datos){
      registros.add(Registros.fromJson(datos));
    }

    return  registros;
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
          title: Image.asset('images/logogamershub.png', width: 40),
          backgroundColor: Color.fromRGBO(62, 0, 141, 1),
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    controller: c_username,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.send,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    obscureText: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      prefixIcon: Icon(Icons.person, color: Color.fromRGBO(100, 100, 100, .4)),
                      hintText: 'Username',
                      hintStyle: TextStyle(
                          fontSize: 25,
                          fontFamily: 'PTSansNarrow',
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(100, 100, 100, .4)
                      ),
                      helperText: 'Choose a Username',
                      helperStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PTSansNarrow',
                          fontWeight: FontWeight.normal,
                          color: Colors.black
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        borderSide: BorderSide(
                          color: Colors.black,
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
                  TextField(
                    controller: c_password,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.send,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      prefixIcon: Icon(Icons.person, color: Color.fromRGBO(100, 100, 100, .4)),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          fontSize: 25,
                          fontFamily: 'PTSansNarrow',
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(100, 100, 100, .4)
                      ),
                      helperText: 'Choose a Password or write the same one',
                      helperStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PTSansNarrow',
                          fontWeight: FontWeight.normal,
                          color: Colors.black
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        borderSide: BorderSide(
                          color: Colors.black,
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
                  TextField(
                    controller: c_email,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.send,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                    obscureText: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      prefixIcon: Icon(Icons.person, color: Color.fromRGBO(100, 100, 100, .4)),
                      hintText: 'email',
                      hintStyle: TextStyle(
                          fontSize: 25,
                          fontFamily: 'PTSansNarrow',
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(100, 100, 100, .4)
                      ),
                      helperText: 'Choose an email or write the same one',
                      helperStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PTSansNarrow',
                          fontWeight: FontWeight.normal,
                          color: Colors.black
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        borderSide: BorderSide(
                          color: Colors.black,
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
                  TextField(
                    controller: c_juegofavorito,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    textInputAction: TextInputAction.send,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                    obscureText: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      prefixIcon: Icon(Icons.person, color: Color.fromRGBO(100, 100, 100, .4)),
                      hintText: 'Favorite game',
                      hintStyle: TextStyle(
                          fontSize: 25,
                          fontFamily: 'PTSansNarrow',
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(100, 100, 100, .4)
                      ),
                      helperText: 'Choose your favorite game',
                      helperStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PTSansNarrow',
                          fontWeight: FontWeight.normal,
                          color: Colors.black
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        borderSide: BorderSide(
                          color: Colors.black,
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
                  TextField(
                    controller: c_edad,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    textInputAction: TextInputAction.send,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                    obscureText: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      prefixIcon: Icon(Icons.person, color: Color.fromRGBO(100, 100, 100, .4)),
                      hintText: 'Age',
                      hintStyle: TextStyle(
                          fontSize: 25,
                          fontFamily: 'PTSansNarrow',
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(100, 100, 100, .4)
                      ),
                      helperText: 'Choose your age',
                      helperStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'PTSansNarrow',
                          fontWeight: FontWeight.normal,
                          color: Colors.black
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        borderSide: BorderSide(
                          color: Colors.black,
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
                  Row(
                    children: [
                      ElevatedButton(onPressed: (){
                        username = c_username.text;
                        password = c_password.text;
                        email = c_email.text;
                        juegofavorito = c_juegofavorito.text;
                        edad = c_edad.text;

                        if(username == '' || password == ''){
                          mostrar_alerta('Debes llenar todos los datos');
                        }else{
                          editar_producto();
                        }
                      },
                          child: Text('Edit')
                      ),
                      SizedBox(width: 100,),
                      ElevatedButton(onPressed: (){
                        msn_eliminar(widget.userid);
                      },
                      child: Text('Borrar perfil')),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
