class Conversa {
  String _idConversa;
  String _nome;
  String _mensagem;
  String _cominhoImagem;

  Conversa(
    this._idConversa,
    this._nome,
    this._mensagem,
    this._cominhoImagem,
  );

  String get idConversa => _idConversa;

  set idConversa(String value) {
    _idConversa = value;
  }

  String get nome => _nome;

  String get cominhoImagem => _cominhoImagem;

  set cominhoImagem(String value) {
    _cominhoImagem = value;
  }

  String get mensagem => _mensagem;

  set mensagem(String value) {
    _mensagem = value;
  }

  set nome(String value) {
    _nome = value;
  }
}
