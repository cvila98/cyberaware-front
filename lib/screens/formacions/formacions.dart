import 'package:cyberaware/models/Usuari.dart';
import 'package:cyberaware/models/Formacio.dart';
import 'package:cyberaware/screens/formacions/question.dart';
import 'package:cyberaware/screens/menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Formacions extends StatefulWidget {
  Formacions(this.user);
  Usuari user;

  static const String _title = 'CyberAware';
  @override
  _FormacionsState createState() => _FormacionsState();


}

class _FormacionsState extends State<Formacions> {

  var _responseCode;
  List<dynamic> _formacions = [];
  List<dynamic> _realitzades = [];


  @override
  void initState() {
    // TODO: implement initState
    get_formacions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: get_formacions(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
              title: Text(
                'Formacions',
                style: TextStyle(
                  color: Colors.white,
                ),

              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              centerTitle: true,
            ),
            body: ListView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                SizedBox(height: 8),
                Container(
                  child: Text('Formacions pendents de realitzar:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                ),
                SizedBox(height:10),
                buildFormacions(),
                SizedBox(height:8),
                Container(
                  child: Text('Formacions realitzades aquesta setmana:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 10,),
                buildRealitzades(),
              ],
            ),
          );

        });
  }

  Widget buildFormacions() {
    return Container(
      height: 300,
      child: GridView(
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 4 / 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          crossAxisCount: 2,
        ),
        children: _formacions
            .map((formacio) => FormacioWidget(formacio, widget.user))
            .toList(),
      ),
    );

  }

  Widget buildRealitzades() {
    return Container(
      height: 600,
      child: GridView(
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 4 / 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          crossAxisCount: 2,
        ),
        children: _realitzades
            .map((formacio) => RealitzadaWidget(formacio, widget.user))
            .toList(),
      ),
    );

  }

  Future<void> get_formacions() async{
    http.Response response = await http.get(new Uri.http("10.0.2.2:8000", "/api/formacions/formacions_user"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': "Token "+widget.user.token,
      },);
    _responseCode = response.statusCode;
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<dynamic> formacions = data['formacions'].map((i)=>Formacio.fromJson(i)).toList();
    List<dynamic> realitzades = data['realitzades'].map((i)=>Formacio.fromJson(i)).toList();
    _formacions=formacions;
    _realitzades = realitzades;
  }


}

class FormacioWidget extends StatelessWidget{
  FormacioWidget(this.formacio, this.user);
  Formacio formacio;
  Usuari user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => QuestionWidget(formacio, user),
      )),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.today,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              formacio.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }

}

class RealitzadaWidget extends StatelessWidget{
  RealitzadaWidget(this.formacio, this.user);
  Formacio formacio;
  Usuari user;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.check_circle,
                color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              formacio.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
          ],
        ),
    );
  }

}