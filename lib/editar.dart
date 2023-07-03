import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gamershub/favorites.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Editar extends StatefulWidget {

  String id;

  Editar(this.id, {Key? key}) : super(key: key);

  @override
  State<Editar> createState() => _EditarState();
}
class _EditarState extends State<Editar> {

  var c_gamename = new TextEditingController();
  var c_gamertag = new TextEditingController();
  var c_rank = new TextEditingController();

  String? gamename = '';
  String? gamertag = '';
  String? rank = '';

  String? savedid;

  editar_producto() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedid = preferences.getString('id');
    });
    print(savedid);

    var url = Uri.parse(
        'https://asaicollection.com/gamershub/editar_juego.php');
    var response = await http.post(url, body: {
      'user' : savedid,
      'gameid' : widget.id,
      'gamename': gamename,
      'gamertag': gamertag,
      'rank': rank,
    }).timeout(Duration(seconds: 90));

    //print(response.body);
    if (response.body == '1') {
      Navigator.of(context).pop();
      mostrar_alerta('Se modifico el producto correctamente');
      c_gamename.text == '';
      c_gamertag.text == '';
      c_rank.text == '';
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context){
            return favorites();
          }
        )
      );
    } else {
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

  Future mostrar_datos() async{
    var url = Uri.parse('https://asaicollection.com/gamershub/ver_juego.php');
    var response = await http.post(url, body: {
        'gameid' : widget.id
    }).timeout(Duration(seconds: 90));

    var datos = jsonDecode(response.body);

    c_gamename.text = datos['gamename'];
    c_gamertag.text = datos['gamertag'];
    c_rank.text = datos['rank'];
  }

  void _show() async{
    SmartDialog.config.loading = SmartConfigLoading(
      leastLoadingTime: const Duration(milliseconds: 500),
    );
    setState(() {
      SmartDialog.showLoading();
    });
    editar_producto().then((value){
      setState(() {
        SmartDialog.dismiss();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mostrar_datos();
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
          title: Text('Edit Game'),
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
                      enabled: false,
                      controller: c_gamename,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Game',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        helperText: 'Name of the Game',
                        helperStyle: TextStyle(
                          color: Colors.grey,
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
                    TextField(
                      controller: c_gamertag,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Gamertag',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        helperText: 'Put your Gamertag',
                        helperStyle: TextStyle(
                          color: Colors.grey,
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
                    TextField(
                      controller: c_rank,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Rank',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        helperText: 'What is your rank?',
                        helperStyle: TextStyle(
                          color: Colors.grey,
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
                      gamename = c_gamename.text;
                      gamertag = c_gamertag.text;
                      rank = c_rank.text;

                      if(gamename == ''){
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
