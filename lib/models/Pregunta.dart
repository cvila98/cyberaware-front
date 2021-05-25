class Pregunta {
  int _id;
  String _enunciat;
  String _selectedOption;
  List<String> _options;

  Pregunta({int id, String enunciat, List<String> options}){
    this._id = id;
    this._enunciat = enunciat;
    this._options = options;
  }

  int get id => _id;
  String get enunciat => _enunciat;
  List<String> get options => _options;

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      id: json['id'],
      enunciat: json['enunciat'],
      options: json['options'],
    );
  }

}