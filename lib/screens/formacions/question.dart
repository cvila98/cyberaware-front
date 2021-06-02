import 'dart:convert';
import 'dart:io';

import 'package:scroll_to_index/scroll_to_index.dart';

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
  List<int> _correctAnwer = [];
  Resposta _selectedResposta;
  List<Resposta> array_respostes;
  int _selectedPregunta;
  Future<void> _have_preguntes;
  bool _hasRespond = false;

  List<dynamic> _preguntes = [];

  PageController _controller;
  int _pageIndex;


  @override
  void initState() {
    _pageIndex = 0;
    _controller = PageController(initialPage: 0, keepPage: false);
    _isCorrect = false;
    _selectedResposta = new Resposta(id: 20000, text: 'resposta prova');
    _have_preguntes = get_preguntes(widget.formacio.id).whenComplete((){
      _correctAnwer = new List.filled(_preguntes.length, 0);
      array_respostes = new List.filled(_preguntes.length, _selectedResposta);
      print(array_respostes);
    });
    _selectedPregunta = 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _have_preguntes,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.formacio.name,
              ),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(80),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child:
                    Container(
                      height: 50,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (contex, index){
                            return ElevatedButton(
                              onPressed: (){
                                onTapPage(index);
                                setState(() {
                                  _selectedPregunta = index;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: _selectedPregunta == index ? Colors.orange.shade300 : Colors.white,
                                shape: CircleBorder(),
                              ),
                              child:
                                Text(
                                    (index+1).toString(),
                                  style: TextStyle(color: Colors.black, fontSize: 22),
                                )
                            );
                          },
                          separatorBuilder: (context, index)=> Container(width: 16,),
                          itemCount: _preguntes.length)
                    )
                ),
              ),
            ),

            body: PageView.builder(
              onPageChanged: (page){
                setState(() {
                  _selectedPregunta = page.toInt();
                });
              },
              controller: _controller,
              itemCount: _preguntes.length,
              itemBuilder: (context, index){
                final question = _preguntes[index];

                return buildPregunta(pregunta: question, index_pregunta: index);
              },
            ),
          );
        }
    );
  }

  Widget buildPregunta({Pregunta pregunta, int index_pregunta}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15 ),
              Text(
                pregunta.enunciat,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              Text(
                'Escull una sola opció.',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: buildOptions(pregunta: pregunta, index_pregunta: index_pregunta),
              ),
              (_correctAnwer[index_pregunta]!=0) ? Container(
                height: 90,
                alignment: Alignment.center,
                child: SizedBox(
                  height: 40,
                  width: 200,
                  child: ElevatedButton(
                      child: Icon(Icons.arrow_forward)
                  ),
                )
              ) : Container()
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

  Widget buildOptions({Pregunta pregunta, int index_pregunta}) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 10);
        },
        itemCount: pregunta.options.length,
        itemBuilder: (context, index){
          return TextButton(
              onPressed: () {
                if (_correctAnwer[index_pregunta]==0){
                  check_resposta(pregunta.options[index].id, pregunta.id).whenComplete(() {
                    get_correcta(pregunta.id, index_pregunta).whenComplete((){
                      setState(() {
                        _selectedResposta = pregunta.options[index];
                        array_respostes[index_pregunta] = _selectedResposta;
                      });
                    });
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (_correctAnwer[index_pregunta]==pregunta.options[index].id) ? Colors.green : getColorOption(pregunta.options[index], index_pregunta),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: (_correctAnwer[index_pregunta] == pregunta.options[index].id) ?
                Column(
                  children: [
                    buildAnswer(pregunta.options[index]),
                    buildSolution(pregunta.options[index], pregunta.options[index])
                  ],
                ):
                Column(
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
          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        )
      ),
    );
  }

  Color getColorOption(Resposta resposta, int index_pregunta){
    bool isSelected = (_selectedResposta.text == resposta.text);
    bool isPressed = (array_respostes[index_pregunta].id == resposta.id);
    if(isSelected || isPressed){
      if(_correctAnwer[index_pregunta] == resposta.id){
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

  Future<void> get_correcta(int id_pregunta, int index) async{
    http.Response response = await http.get(new Uri.http("10.0.2.2:8000", "/api/formacions/pregunta/"+id_pregunta.toString()+"/get_correcta"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Authorization': "Token "+widget.user.token.toString(),
      },);
    _responseCode = response.statusCode;
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    _correctAnwer[index] = data['resposta_correcta'];

  }


  void onTapPage(int index) {
    _controller.jumpToPage(index);

  }

}

