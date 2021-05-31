import 'Pregunta.dart';

class Formacio{
  int _id;
  String _name;
  String _descripcio;
  List<Pregunta> _preguntes;

  Formacio({int id, String name, String descripcio}){
    this._id = id;
    this._name = name;
    this._descripcio = descripcio;
    this._preguntes = [];
  }

  int get id => _id;
  String get name => _name;
  String get descripcio => _descripcio;
  List<Pregunta> get preguntes => _preguntes;

  set preguntes(List<Pregunta> preguntes) => _preguntes = preguntes;

  factory Formacio.fromJson(Map<String, dynamic> json) {
    return Formacio(
      id: json['id'],
      name: json['nom'],
      descripcio: json['descripcio']
    );
  }

}

