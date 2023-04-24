import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamershub/editaboutme.dart';
import 'package:gamershub/profile.dart';
import 'package:gamershub/subscribe.dart';
import 'home.dart';
import 'register.dart';
import 'login.dart';
import 'forgotpassword.dart';

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
      home: register(),
      theme: ThemeData(primarySwatch: Colors.pink),
    );
  }
}
