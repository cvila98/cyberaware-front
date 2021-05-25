import 'Pregunta.dart';

class Formacio{
  int _id;
  String _name;
  String _descripcio;
  List<Pregunta> _preguntes;

  Formacio({int id, String name, String descripcio, List<Pregunta> preguntes}){
    this._id = id;
    this._name = name;
    this._descripcio = descripcio;
    this._preguntes = preguntes;
  }

  factory Formacio.fromJson(Map<String, dynamic> json) {
    PreguntesList preguntes = PreguntesList.fromJson(json['preguntes']);
    return Formacio(
      id: json['id'],
      name: json['name'],
      descripcio: json['descripcio'],
      preguntes: preguntes.getPreguntes(),
    );
  }

}

