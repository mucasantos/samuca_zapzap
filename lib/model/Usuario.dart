class Usuario {
  String _nome;
  String _email;
  String _senha;
  String _urlImage;

  String get urlImage => _urlImage;

  set urlImage(String value) {
    _urlImage = value;
  }

  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
      "urlImage": this.urlImage
    };

    return map;
  }

  Usuario.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    email = json['email'];
    urlImage = json['urlImage'];
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}
