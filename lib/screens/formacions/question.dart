import 'dart:convert';
import 'dart:io';

import 'package:cyberaware/models/Formacio.dart';
import 'package:cyberaware/models/Pregunta.dart';
import 'package:cyberaware/models/Resposta.dart';
import 'package:cyberaware/models/Usuari.dart';
import 'package:cyberaware/screens/menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class QuestionWidget extends StatefulWidget{
  QuestionWidget(this.formacio, this.user);
  Formacio formacio;
  Usuari user;

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget>{

  var _responseCode;

  List<dynamic> _preguntes = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: get_preguntes(widget.formacio.id),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return PageView.builder(
            itemCount: _preguntes.length,
            itemBuilder: (context, index){
              final question = _preguntes[index];

              return buildPregunta(pregunta: question);
            },
          );
        }
    );
  }

  Widget buildPregunta({Pregunta pregunta}) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32,),
          Text(
            pregunta.enunciat,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ]

    );
  }

  Future<void> get_preguntes(int id_formacio) async{
    print('entro al get preguntes');
    http.Response response = await http.get(new Uri.http("10.0.2.2:8000", "/api/formacions/"+id_formacio.toString()+"/preguntes/"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          'Authorization': "Token "+widget.user.token.toString(),
        },);
    _responseCode = response.statusCode;
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Pregunta> preguntes = PreguntesList.fromJson(data['preguntes']).getPreguntes();

    data['preguntes'].forEach( (c) {
      List<Resposta> respostes = RespostesList.fromJson(c['respostes']).getRespostes();
      Pregunta pregunta = preguntes.firstWhere((element) => element.id == c['id']);
      pregunta.options = respostes;
    });

    _preguntes= preguntes;
  }

}