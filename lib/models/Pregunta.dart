import 'Resposta.dart';

class Pregunta {
  int _id;
  String _enunciat;
  String _selectedOption;
  List<Resposta> _options;

  Pregunta({int id, String enunciat, List<Resposta> options}){
    this._id = id;
    this._enunciat = enunciat;
    this._options = options;
  }

  int get id => _id;
  String get enunciat => _enunciat;
  List<Resposta> get options => _options;

  factory Pregunta.fromJson(Map<String, dynamic> json) {

    List<Resposta> respostes = json['respostes'].map((i)=>Resposta.fromJson(i)).toList();

    return Pregunta(
      id: json['id'],
      enunciat: json['enunciat'],
      options: respostes,
    );
  }

}

class PreguntesList {
  List<Pregunta> preguntes;

  PreguntesList({this.preguntes,});

  List<Pregunta> getPreguntes(){
    List<Pregunta> results = [];

    preguntes.map((e){
      results.add(e);
    }).toList();

    return results;
  }

  factory PreguntesList.fromJson(List<dynamic> json){

    List<Pregunta> preguntes = [];
    preguntes = json.map((i)=>Pregunta.fromJson(i)).toList();

    return new PreguntesList(
      preguntes: preguntes,
    );

  }

}