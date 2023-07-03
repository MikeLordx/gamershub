import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class pass extends StatefulWidget {
  const pass({Key? key}) : super(key: key);

  @override
  State<pass> createState() => _passState();
}

class _passState extends State<pass> {

  var c_username = TextEditingController();

  String username = '';

  LlenarDatos(username){
    if(username == ""){
      mostrar_alerta('Debes llenar todos los datos o te equivocaste con algun dato');
    }else{
      guardar_datos(username);

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) {
            return home();
          }
      ), (route) => false);
    }
    c_username.text = '';
  }

  Future<void> guardar_datos(username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('Username', username);
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return home();
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

  Future<void> ver_datos() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = (await preferences.getString('Username'))!;

    print('username: ' + username);

    if(username != null){
      if(username != ''){
        Navigator.of(context).push(MaterialPageRoute(
            builder:(BuildContext context) {
              return new home();
            }
        )
        );
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context){
          return home();
        }), (route) => false);
      }
    }
  }

  Future<void> forgot_password(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.clear();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return home();
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
                    padding: EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Forgot Password', style: TextStyle(
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
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
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
                        helperText: 'Username',
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
                      mostrar_alerta('Se ha enviado un mensaje al correo registrado con tu usuaio');
                    },
                    child: Text('Send'),
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
