import 'dart:convert';

import 'package:cyberaware/models/Formacio.dart';
import 'package:cyberaware/models/Pregunta.dart';
import 'package:cyberaware/models/Usuari.dart';
import 'package:flutter/cupertino.dart';

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
  @override
  void initState() {
    get_preguntes(widget.formacio.id);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        itemCount: widget.formacio.preguntes.length,
        itemBuilder: (context, index){
          final pregunta = widget.formacio.preguntes[index];

          return buildPregunta(pregunta: pregunta);
        },
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
    http.Response response = await http.get(new Uri.http("10.0.2.2:8000", "/api/formacions/"+id_formacio.toString()+"/preguntes/"),
        headers: <String, String>{
          'Authorization': widget.user.token,
        },);
    _responseCode = response.statusCode;
    var data = jsonDecode(response.body);
    List<Pregunta> preguntes = PreguntesList.fromJson(data['preguntes']).getPreguntes();
    print(preguntes);
  }

}