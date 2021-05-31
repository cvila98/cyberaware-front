class Resposta {
  int _id;
  String _text;


  Resposta({int id, String text}) {
    this._id = id;
    this._text = text;
  }

  int get id => _id;
  String get text => _text;

  factory Resposta.fromJson(Map<String, dynamic> json) {

    return Resposta(
      id: json['id'],
      text: json['resposta'],
    );
  }
}