import 'package:cyberaware/models/Usuari.dart';
import 'package:cyberaware/models/Formacio.dart';
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
                buildFormacions(),
                SizedBox(height:8),
              ],
            ),
          );

        });
  }

  Widget buildFormacions() {
    print('entro al build');
    print(_formacions);
    return Container(
      height: 600,
      child: GridView(
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 7 / 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          crossAxisCount: 1,
        ),
        children: _formacions
            .map((formacio) => FormacioWidget(formacio))
            .toList(),
      ),
    );

  }

  Future<void> get_formacions() async{
    print(widget.user.token);
    http.Response response = await http.get(new Uri.http("10.0.2.2:8000", "/api/formacions/formacions_user"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Token "+widget.user.token,
      },);
    _responseCode = response.statusCode;
    var data = jsonDecode(response.body);
    List<dynamic> formacions = data['formacions'].map((i)=>Formacio.fromJson(i)).toList();
    _formacions=formacions;
  }


}

class FormacioWidget extends StatelessWidget{
  FormacioWidget(this.formacio);
  Formacio formacio;

  @override
  Widget build(BuildContext context) {
    print('entro al build de formacio');
    return GestureDetector(
      onTap: (){
        print(formacio.name);
      },
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
              Icons.ac_unit
            ),
            const SizedBox(height: 12),
            Text(
              formacio.name,
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