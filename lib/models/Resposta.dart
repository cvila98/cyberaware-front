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

class RespostesList {
  List<Resposta> respostes;

  RespostesList({this.respostes,});

  List<Resposta> getRespostes(){
    List<Resposta> results = [];

    respostes.map((e){
      results.add(e);
    }).toList();

    return results;
  }

  factory RespostesList.fromJson(List<dynamic> json){

    List<Resposta> preguntes = [];
    preguntes = json.map((i)=>Resposta.fromJson(i)).toList();

    return new RespostesList(
      respostes: preguntes,
    );

  }

}