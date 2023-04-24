import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {

  var c_username = TextEditingController();
  var c_password = TextEditingController();
  var c_email = TextEditingController();

  String username = '';
  String password = '';
  String email = '';

  LlenarDatos(username, password, email){
    if(username == "" || password == "" || email == ""){
      mostrar_alerta('Debes llenar todos los datos o te equivocaste con algun dato');
    }else{
      guardar_datos(username, password, email);

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) {
            return home();
          }
      ), (route) => false);
    }
    c_username.text = '';
    c_password.text = '';
    c_email.text = '';
  }

  Future<void> guardar_datos(username, password, email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('Username', username);
    await preferences.setString('Password', password);
    await preferences.setString('Email', email);
  }

  mostrar_alerta(mensaje){
    showDialog(
        context:context,
        barrierDismissible: false,
        builder: (BuildContext){
          return AlertDialog(
            title: Text('Formulario'),
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
                  Navigator.of(context).pop();
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
    password = (await preferences.getString('Password'))!;
    email = (await preferences.getString('Email'))!;

    print('username: ' + username);
    print('password: ' + password);
    print('email: ' + email);

    if(email != null){
      if(email != ''){
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
                  ElevatedButton(
                    onPressed: (){
                      FocusScope.of(context).unfocus();
                      username = c_username.text;
                      email = c_email.text;
                      password = c_password.text;

                      LlenarDatos(username, password, email);
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
