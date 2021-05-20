import 'dart:convert';

class Empresa  {
  String _nom;

  Empresa({String name}){
    this._nom = name;
  }

  String get nom => _nom;

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      name: json['nom'],
    );
  }

}

class EmpresaList {
  List<Empresa> empreses;

  EmpresaList({this.empreses,});

  List<String> getNoms(){
    List<String> results = [];

    empreses.map((e){
      results.add(e.nom);
    }).toList();

    return results;
  }

  factory EmpresaList.fromJson(List<dynamic> json){

    List<Empresa> empreses = [];
    empreses = json.map((i)=>Empresa.fromJson(i)).toList();

    return new EmpresaList(
      empreses: empreses,
    );

  }

}