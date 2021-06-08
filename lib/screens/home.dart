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

  int _puntuacio = 0, _max_puntuacio = 0, _realitzades= 0, _pendents = 0;
  int _puntuacio_acumulada = 0, _max_puntuacio_acumulada = 0, _acumulades = 0;
  Future<void> _have_metrics;

  @override
  void initState() {
    _puntuacio = _max_puntuacio = _realitzades = _pendents = 0;
    _puntuacio_acumulada = _max_puntuacio_acumulada = _acumulades = 0;
    _have_metrics = get_metrics();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<void>(
        future: _have_metrics,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
              drawer: Menu(widget.user),
              appBar: AppBar(
                title: Text(
                  'Indicadors usuari',
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
              ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Text('Indicadors dels últims 7 dies:',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
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
                            SizedBox(height: 10),
                            Text('puntuació obtinguda / puntuació màxima',
                              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,),
                          ],
                        )
                    ),
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
                          Text(_realitzades.toString()+" realitzades",
                            style: TextStyle(fontSize: 30,),),
                          Text(_pendents.toString()+" pendents",
                              style: TextStyle(fontSize: 30,)),
                        ],
                      )
                  ),
                  Divider(
                    thickness: 2,
                    height: 60,),
                  Text('Indicadors totals: ',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text('Aquests indicadors corresponen l\'activitat des de l\'inscripció de l\'usuari fins ara.',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,),
                  SizedBox(height: 20),
                  Container(
                      padding: EdgeInsets.all(20),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Text('Puntuació acumulada:',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          SizedBox(height:20),
                          Text(_puntuacio_acumulada.toString()+" / "+_max_puntuacio_acumulada.toString(),
                            style: TextStyle(fontSize: 30,),),
                          SizedBox(height: 10),
                          Text('puntuació obtinguda / puntuació màxima',
                            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,),
                        ],
                      )
                  ),
                  SizedBox(height: 20),
                  Container(
                      padding: EdgeInsets.all(20),
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Text('Formacions acumulades:',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          SizedBox(height:10),
                          Text(_acumulades.toString()+" realitzades",
                            style: TextStyle(fontSize: 30,),),
                        ],
                      )
                  )
                ],
              ),
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
    _puntuacio_acumulada = data['puntuacio_acumulada'];
    _max_puntuacio_acumulada = data['max_puntuacio_acumulada'];
    _realitzades = data['formacions_realitzades'];
    _pendents = data['formacions_pendents'];
    _acumulades = data['formacions_acumulades'];
  }

}