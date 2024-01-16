class UserData {
  String? email;
  String? token;
  DateTime? fechaInsersion;
  DateTime? fechaToken;
  Map? compartir;

  UserData({
    this.email,
    this.token,
    this.fechaInsersion,
    this.fechaToken,
    this.compartir,
  });

  UserData.fromJson(Map<dynamic, dynamic> json) {
    email = json["email"] ?? '';
    token = json["token"] ?? '';
    fechaInsersion = DateTime.tryParse(json["fecha_insercion"].toString());
    fechaToken = DateTime.tryParse(json["fecha_token"].toString());
    compartir = json["compartir"] ?? {};
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "email": email,
      "token": token,
      "fecha_insercion": fechaInsersion.toString(),
      "fecha_token": fechaToken.toString(),
      "compartir": compartir
    };
  }
}
