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
  String _hint = "";
  bool _isCorrect;
  Resposta _selectedResposta;

  List<dynamic> _preguntes = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: get_preguntes(widget.formacio.id),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
            body: PageView.builder(
              itemCount: _preguntes.length,
              itemBuilder: (context, index){
                final question = _preguntes[index];

                return buildPregunta(pregunta: question);
              },
            ),
          );
        }
    );
  }

  Widget buildPregunta({Pregunta pregunta}) {
    return Container(
      color: Colors.white,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32,),
            Text(
              pregunta.enunciat,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8,),
            Text(
              'Escull una sola opció.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
            ),
            Expanded(
              child: buildOptions(pregunta: pregunta),
            )
          ]

      ),

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

  Widget buildOptions({Pregunta pregunta}) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: pregunta.options.map((resposta) => buildOption(context, resposta, pregunta))
          .toList(),
    );
  }

  Widget buildOption(BuildContext context, Resposta option, Pregunta question) {
    final color = getColorForOption(option, question);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedResposta = option;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            buildAnswer(option),
            buildSolution(_selectedResposta, option),
          ],
        ),
      ),
    );
  }

  Color getColorForOption(Resposta option, Pregunta question) {
    bool isSelected = (option == _selectedResposta);
    print(option.text);
    print(_selectedResposta.text);

    if (!isSelected) {
      return Colors.grey.shade200;
    } else {
      check_resposta(option.id, question.id).whenComplete((){
        if (_isCorrect == true){
          return Colors.green;
        }
        else{
          return Colors.red;
        }
      });
    }

  }

  Widget buildAnswer(Resposta option){
    return Container(
      height: 50,
      child: Row(children: [
        Text(
          option.id.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(width: 12),
        Text(
          option.text,
          style: TextStyle(fontSize: 20),
        )
      ]),
    );
  }

  Widget buildSolution(Resposta solution, Resposta answer) {
    if (solution == answer) {
      return Text(
        _hint,
        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
      );
    } else {
      return Container();
    }
  }

  Future<void> check_resposta(int id_resposta, int id_pregunta) async {
    print('entro al check_resposta');
    http.Response response = await http.post(new Uri.http("10.0.2.2:8000",
        "/api/formacions/preguntes/" + id_pregunta.toString() + "/"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': "Token " + widget.user.token.toString(),
      },
      body: jsonEncode(<String, int>{
        'resposta': id_resposta,
      }),
    );
    _responseCode = response.statusCode;
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    _hint = data['hint'];
    _isCorrect = data['is_correct'];
  }

}