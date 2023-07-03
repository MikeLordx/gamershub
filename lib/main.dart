import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamershub/editaboutme.dart';
import 'package:gamershub/editprofile.dart';
import 'package:gamershub/profile.dart';
import 'package:gamershub/subscribe.dart';
import 'home.dart';
import 'register.dart';
import 'login.dart';
import 'forgotpassword.dart';
import 'signinscreen.dart';
import 'favorites.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void main(){
  runApp(principal());
}

class principal extends StatelessWidget {
  const principal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Primera App',
      debugShowCheckedModeBanner: false,
      home: home(),
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      theme: ThemeData(primarySwatch: Colors.pink),
    );
  }
}
