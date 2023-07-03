import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamershub/login.dart';
import 'package:gamershub/signinscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:http/http.dart' as http;

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {

  var c_username = TextEditingController();
  var c_password = TextEditingController();
  var c_email = TextEditingController();
  var c_juegofavorito = TextEditingController();
  var c_edad = TextEditingController();

  String username = '';
  String password = '';
  String email = '';
  String juegofavorito = '';
  String edad = '';


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

  Future<void> guardar_datos(user, pass, userid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('id', userid);
    await preferences.setString('email', username);
    await preferences.setString('password', password);

    savedid = (await preferences.getString('id'))!;
  }

  subir_usuario() async {
    var url = Uri.parse(
        'https://asaicollection.com/gamershub/guardar_usuario.php');
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
      'email': email,
      'juegofavorito' : juegofavorito,
      'edad' : edad,
    }).timeout(Duration(seconds: 90));

    if (response.body == '1') {
      mostrar_alerta('Usuario registrado con exito');
      c_username.text == '';
      c_password.text == '';
      c_email.text == '';
      c_juegofavorito.text == '';
      c_edad.text = '';
    } else {
      mostrar_alerta(response.body);
    }
  }

  Future ingresar(user, pass) async {
    try{

      var url = Uri.parse('https://asaicollection.com/gamershub/ver_producto.php');
      var response = await http.post(url,
          body: {
            'username' : user,
            'password' : pass
          }
      ).timeout(const Duration(seconds: 90));

      var respuesta = response.body;
      var partes = respuesta.split('|'); // Separar la comprobación y el ID
      var comprobacion = partes[0];
      var userid = partes[1];

      if(comprobacion == '1')
      {
        guardar_datos(username, password, userid);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context){
              return signinscreen(userid);
            }
        ), (route) => false);
        print(userid);
      }
      else{
        mostrar_alerta(response.body);
      }

    }on TimeoutException catch(e){
      print('Conection took longer than expected');
    }on Error catch(e){
      mostrar_alerta('User or password incorrect');
    }
  }

  mostrar_alerta(mensaje){
    showDialog(
        context:context,
        barrierDismissible: false,
        builder: (BuildContext){
          return AlertDialog(
            title: Text('Gamers Hub'),
            content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(mensaje)
                  ],
                )
            ),
            actions: [
              TextButton(
                onPressed: (){
                  ingresar(username, password);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return signinscreen(savedid);
                      }
                  )
                  );
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        }
    );
  }

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

        final FocusScopeNode focus = FocusScope.of(context);
        if(!focus.hasPrimaryFocus && focus.hasFocus){
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Color.fromRGBO(62, 0, 141, .4),
          body: ListView(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/logogamershub.png', width: 50,)
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sign Up', style: TextStyle(
                          fontFamily: 'PTSansNarrow',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child:
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
                        color: Colors.grey,
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
                          color: Colors.white
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
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child:
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
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        //icon: Icon(Icons.safety_check),
                        prefixIcon: Icon(Icons.safety_check, color: Color.fromRGBO(100, 100, 100, .4),),
                        //prefix: Image.asset('images/image1.png', width: 10,),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            fontSize: 25,
                            fontFamily: 'PTSansNarrow',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(100, 100, 100, .4)
                        ),
                        helperText: 'Choose a Password',
                        helperStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'PTSansNarrow',
                            fontWeight: FontWeight.normal,
                            color: Colors.white
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
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextField(
                      controller: c_email,
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
                        //icon: Icon(Icons.safety_check),
                        prefixIcon: Icon(Icons.email, color: Color.fromRGBO(100, 100, 100, .4),),
                        //prefix: Image.asset('images/image1.png', width: 10,),
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            fontSize: 25,
                            fontFamily: 'PTSansNarrow',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(100, 100, 100, .4)
                        ),
                        helperText: 'Provide an email',
                        helperStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'PTSansNarrow',
                            fontWeight: FontWeight.normal,
                            color: Colors.white
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
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextField(
                      controller: c_juegofavorito,
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
                        //icon: Icon(Icons.safety_check),
                        prefixIcon: Icon(Icons.keyboard_control, color: Color.fromRGBO(100, 100, 100, .4),),
                        //prefix: Image.asset('images/image1.png', width: 10,),
                        hintText: 'Favorite game',
                        hintStyle: TextStyle(
                            fontSize: 25,
                            fontFamily: 'PTSansNarrow',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(100, 100, 100, .4)
                        ),
                        helperText: 'Provide your favorite game',
                        helperStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'PTSansNarrow',
                            fontWeight: FontWeight.normal,
                            color: Colors.white
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
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextField(
                      controller: c_edad,
                      autofocus: false,
                      keyboardType: TextInputType.number,
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
                        //icon: Icon(Icons.safety_check),
                        prefixIcon: Icon(Icons.keyboard_control, color: Color.fromRGBO(100, 100, 100, .4),),
                        //prefix: Image.asset('images/image1.png', width: 10,),
                        hintText: 'Age',
                        hintStyle: TextStyle(
                            fontSize: 25,
                            fontFamily: 'PTSansNarrow',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(100, 100, 100, .4)
                        ),
                        helperText: 'Provide your age',
                        helperStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'PTSansNarrow',
                            fontWeight: FontWeight.normal,
                            color: Colors.white
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
                  ),
                  ElevatedButton(
                    onPressed: (){
                      FocusScope.of(context).unfocus();
                      username = c_username.text;
                      email = c_email.text;
                      password = c_password.text;
                      juegofavorito = c_juegofavorito.text;
                      edad = c_edad.text;

                      if(username == '' || email == '' || password == ''){
                        mostrar_alerta('Debes llenar todos los datos');
                      }else{
                        subir_usuario();
                        guardar_datos(username, password, savedid);
                      }
                    },
                    child: Text('Sign up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
