class UserData {
  String? uID;
  String? nombre;
  String? apellido;
  String? email;
  String? token;
  DateTime? fechaInsersion;
  DateTime? fechaToken;
  Map? compartir;

  UserData({
    this.uID,
    this.nombre,
    this.apellido,
    this.email,
    this.token,
    this.fechaInsersion,
    this.fechaToken,
    this.compartir,
  });

  UserData.fromJson(Map<dynamic, dynamic> json) {
    uID = json["uid"] ?? '';
    nombre = json["nombre"] ?? '';
    apellido = json["apellido"] ?? '';
    email = json["email"] ?? '';
    token = json["token"] ?? '';
    fechaInsersion = DateTime.tryParse(json["fecha_insercion"].toString());
    fechaToken = DateTime.tryParse(json["fecha_token"].toString());
    compartir = json["compartir"] ?? {};
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "uid": uID,
      "nombre": nombre,
      "apellido": apellido,
      "email": email,
      "token": token,
      "fecha_insercion": fechaInsersion.toString(),
      "fecha_token": fechaToken.toString(),
      "compartir": compartir
    };
  }
}
