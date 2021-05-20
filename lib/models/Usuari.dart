class Usuari {
  String _username;
  String _email;
  String _name;
  String _token;
  bool _if_admin;
  String _empresa;


  Usuari({String username, String email, String name, String token, bool admin, String name_empresa})
  {
    this._username = username;
    this._email = email;
    this._name = name;
    this._token = token;
    this._if_admin = admin;
    this._empresa = name_empresa;
  }

  String get username => _username;
  String get email => _email;
  String get name => _name;
  bool get is_admin=> _if_admin;
  String get empresa => _empresa;

  set username(String username) => _username = username;
  set email(String email) => _email = email;
  set name(String name) => _name = name;
  set token(String token) => _token = token;

  factory Usuari.fromJson(Map<String, dynamic> json) {
    return Usuari(
        username: json['username'],
        email: json['email'],
        name: json['name'],
        admin: json['is_admin'],
        name_empresa: json['empresa'],
    );
  }
}