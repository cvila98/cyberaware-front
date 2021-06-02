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
  bool _isCorrect = false;
  Resposta _selectedResposta;
  Future<void> _have_preguntes;

  List<dynamic> _preguntes = [];

  PageController _controller;
  int _pageIndex;

  @override
  void initState() {
    _pageIndex = 0;
    _controller = PageController(initialPage: 0, keepPage: false);
    _isCorrect = false;
    _selectedResposta = new Resposta(id: 20000, text: 'resposta prova');
    _have_preguntes = get_preguntes(widget.formacio.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _have_preguntes,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
            body: PageView.builder(
              controller: _controller,
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
      padding: EdgeInsets.all(20),
      child: Container(
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

      )
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
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 10);
        },
        itemCount: pregunta.options.length,
        itemBuilder: (context, index){
          return TextButton(
              onPressed: () {
                check_resposta(pregunta.options[index].id, pregunta.id).whenComplete(() {
                  setState(() {
                    _selectedResposta = pregunta.options[index];
                  });
                });
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: getColorOption(pregunta.options[index]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    buildAnswer(pregunta.options[index]),
                    buildSolution(_selectedResposta, pregunta.options[index])
                  ],
                ),
              ),
          );
        }
    );
  }


  Widget buildAnswer(Resposta option){
    return Container(

      child: Container(child:
        Text(
          option.text,
          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        )
      ),
    );
  }

  Color getColorOption(Resposta resposta){
    bool isSelected = (_selectedResposta.text == resposta.text);

    if(isSelected){
      if(_isCorrect){
        return Colors.green;
      }else{
        return Colors.red;
      }

    }else{
      return Colors.grey.shade200;
    }
  }

  Widget buildSolution(Resposta solution, Resposta answer) {
    if (solution == answer) {
      return Column(
        children: [
          SizedBox(height: 10,),
          Text(
            _hint,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black),
          ),
        ],
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

  void onTapPage(int index) {
    _controller.jumpToPage(index);

  }

}