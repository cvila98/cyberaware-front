import 'package:cyberaware/models/Usuari.dart';
import 'package:cyberaware/screens/menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class IndicadorsAdmin extends StatefulWidget {
  IndicadorsAdmin(this.user);
  Usuari user;

  static const String _title = 'CyberAware';
  @override
  _IndicadorsState createState() => _IndicadorsState();


}

class _IndicadorsState extends State<IndicadorsAdmin> {

  int _puntuacio_actual = 0, _max_puntuacio_actual = 0, _puntuacio_acumulada= 0, _max_puntuacio_acumulada = 0;
  int _realitzades= 0, _pendents = 0, _acumulades = 0, _num_usuaris = 0;

  Future<void> _have_metrics;

  @override
  void initState() {
    _puntuacio_actual = _max_puntuacio_actual = _puntuacio_acumulada= _max_puntuacio_acumulada = 0;
    _realitzades = _pendents = _acumulades = _num_usuaris = 0;
    _have_metrics = get_puntuacions().whenComplete(() => get_formacions());

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
                  'Indicadors administrador',
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
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        padding: EdgeInsets.all(20),
                        height: 130,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Text('Nombre d\'usuaris:',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                            SizedBox(height:20),
                            Text(_num_usuaris.toString()+" usuaris",
                              style: TextStyle(fontSize: 30,),),
                          ],
                        )
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    height: 60,),
                  Text('Indicadors dels ??ltims 7 dies:',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,),
                  SizedBox(height: 10),
                  Text('Aquests indicadors corresponen a la suma de tots els usuaris de l\'empresa, incl??s l\'administrador.',
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
                          Text('Puntuaci?? dels usuaris:',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          SizedBox(height:20),
                          Text(_puntuacio_actual.toString()+" / "+_max_puntuacio_actual.toString(),
                            style: TextStyle(fontSize: 30,),),
                          SizedBox(height: 10),
                          Text('puntuaci?? obtinguda / puntuaci?? m??xima',
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
                          Text('Formacions dels usuaris:',
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
                  Text('Aquests indicadors corresponen l\'activitat des de l\'inscripci?? de l\'empresa fins ara.',
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
                          Text('Puntuaci?? dels usuaris:',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                          SizedBox(height:20),
                          Text(_puntuacio_acumulada.toString()+" / "+_max_puntuacio_acumulada.toString(),
                            style: TextStyle(fontSize: 30,),),
                          SizedBox(height: 10),
                          Text('puntuaci?? obtinguda / puntuaci?? m??xima',
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
                          Text('Formacions dels usuaris:',
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

  Future<void> get_puntuacions() async{
    http.Response response = await http.get(new Uri.http("cyberaware.pythonanywhere.com", "/api/admin/puntuacions/"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': "Token "+widget.user.token.toString(),
      },);
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    _puntuacio_actual = data['puntuacio_actual'];
    _max_puntuacio_actual = data['max_puntuacio_actual'];
    _puntuacio_acumulada = data['puntuacio_acumulada'];
    _max_puntuacio_acumulada = data['max_puntuacio_acumulada'];
  }

  Future<void> get_formacions() async{
    http.Response response = await http.get(new Uri.http("cyberaware.pythonanywhere.com", "/api/admin/formacions"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': "Token "+widget.user.token.toString(),
      },);
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    _acumulades = data['formacions_acumulades'];
    _realitzades = data['formacions_realitzades'];
    _pendents = data['formacions_pendents'];
    _num_usuaris = data['usuaris'];
  }

}