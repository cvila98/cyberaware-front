import 'package:cyberaware/models/Usuari.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'menu/menu.dart';

class Home extends StatefulWidget {
  Home(this.user);
  Usuari user;

  static const String _title = 'CyberAware';
  @override
  _HomeState createState() => _HomeState();


}

class _HomeState extends State<Home> {

  int _puntuacio = 0, _max_puntuacio = 0, _realitzades= 0, _totals = 0;

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<void>(
        future: get_metrics(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
              drawer: Menu(widget.user),
              appBar: AppBar(
                title: Text(
                  'Inici',
                  style: TextStyle(
                    color: Colors.white,
                  ),

                ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                centerTitle: true,
              ),
              body:
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(20),
                        height: 150,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Text('Puntuació:',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                            SizedBox(height:20),
                            Text(_puntuacio.toString()+" / "+_max_puntuacio.toString(),
                            style: TextStyle(fontSize: 30,),),
                          ],
                        )
                    ),
                    SizedBox(height: 20),
                    Container(
                        padding: EdgeInsets.all(20),
                        height: 150,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Text('Formacions:',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                            SizedBox(height:10),
                            Text(_realitzades.toString()+" realitzades ",
                              style: TextStyle(fontSize: 30,),),
                            Text((_totals-_realitzades).toString()+" pendents",
                                style: TextStyle(fontSize: 30,)),
                          ],
                        )
                    )
                  ],
                ),
              )
          );
        }
    );

  }

  Future<void> get_metrics() async{
    http.Response response = await http.get(new Uri.http("10.0.2.2:8000", "/api/authentication/get_puntuacio"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': "Token "+widget.user.token.toString(),
      },);
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    _puntuacio = data['puntuacio'];
    _max_puntuacio = data['max_puntuacio'];
    _realitzades = data['formacions_realitzades'];
    _totals = data['formacions'];
  }

}