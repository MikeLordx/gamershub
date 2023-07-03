import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registros.dart';
import 'package:http/http.dart' as http;
import 'profile.dart';

class usernames extends StatefulWidget {
  const usernames({Key? key}) : super(key: key);

  @override
  State<usernames> createState() => _usernamesState();
}

class _usernamesState extends State<usernames> {

  String savedid = '';
  String saveduser = '';
  String savedpass = '';
  String savedemail = '';
  String urlimagen='';

  File? imagen=null;
  final picker=ImagePicker();
  Dio dio= new Dio();

  selimagen(op) async{
    var pickedFile;
    if(op==1){
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    }else{
      pickedFile= await picker.pickImage(source: ImageSource.gallery);
    }
    setState(() {

      if(pickedFile!=null){
        //imagen=File(pickedFile.path);
        cortar(File(pickedFile.path));
      }else{
        print('no se selecciono nada');
      }

    });
  }
  cortar(picked) async{
    CroppedFile? cortado= await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: CropAspectRatio(ratioX: (1.0), ratioY: 1.0)
    );
    if(cortado!=null) {
      setState(() {
        imagen = File(cortado.path);
        subirimagen();
      });
    }

  }
  Future<void> subirimagen()async{

    var url = Uri.parse('https://peliwebapp.com/aplicaciones/subir_imagen.php');
    var response = await http.post(url, body: {
      'id': savedid
    }
    ).timeout(Duration(seconds: 90));

    try{
      String filename=imagen!.path.split('/').last;
      FormData formData= new FormData.fromMap({
        'id':savedid,
        'file': await MultipartFile.fromFile(
            imagen!.path, filename: filename
        )
      });

      await dio.post('https://asaicollection.com/gamershub/subir_imagen.php',
          data: formData).then((value){

        if(value.toString()==1){
          print('Se subio la imagen correctamente');
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => profile()),
            );
          });
        }
        else{
          print(value.toString());
        }
      }
      );



    }catch(e){
      print(e.toString());
    }
  }
  seleccionar(){

    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      selimagen(1);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 1, color: Colors.grey)
                          )
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Tomar una foto', style: TextStyle(
                                fontSize: 16
                            ),),
                          ),
                          Icon(Icons.camera_alt, color: Colors.blue,)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Salir', style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                          ),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );

  }

  bool loading = true;

  List<Registros> reg = [];

  Future<List<Registros>> mostrar_productos() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedid = preferences.getString('id')!;
    });
    var url = Uri.parse('https://asaicollection.com/gamershub/mostrar_productos.php');
    var response = await http.post(url, body: {
      'userid' : savedid,
    }).timeout(Duration(seconds: 90)).timeout(Duration(seconds: 90));

    print(response.body);



    final datos = jsonDecode(response.body);

    List<Registros> registros = [];

    for(var datos in datos){
      registros.add(Registros.fromJson(datos));
    }


    return  registros;
  }

  Future<void> ver_datos() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      saveduser = preferences.getString('email')!;
      savedpass = preferences.getString('password')!;
    });

    print(saveduser);
    print(savedpass);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ver_datos();
    mostrar_productos().then((value){
      setState(() {
        reg.addAll(value);
        loading = false;
      });
    });
  }

  String profileImage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(27, 4, 64, 1),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(saveduser),
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
              crossAxisCount: 1,
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: ElevatedButton(onPressed: (){
                          seleccionar();
                        },
                          child: Column(
                            children: [
                              Image.network('https://asaicollection.com/gamershub/imagenes/'+reg[index].imagen!, width: 100,),
                              Text('Editar foto de perfil', style: TextStyle(
                                fontSize: 7,
                              ),)
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Expanded(
                        child: Text('Username: ' + reg[index].user!, style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white
                        ),),
                      ),
                      Expanded(
                        child: Text('Email: ' + reg[index].email!, style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                        ),
                      ),
                      Expanded(
                        child: Text('Juego Favorito: ' + reg[index].juegofavorito!, style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white
                        ),),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),

    );
  }
}
