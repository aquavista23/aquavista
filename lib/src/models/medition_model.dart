class MeditionData {
  String? id;
  String? dato1;
  String? dato2;
  DateTime? fecha;

  MeditionData({
    this.id,
    this.dato1,
    this.dato2,
    this.fecha,
  });

  MeditionData.fromJson(Map<dynamic, dynamic> json) {
    id = json["id"] ?? '';
    dato1 = json["dato1"] ?? '';
    dato2 = json["dato2"] ?? '';
    fecha = json["fecha"];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "dato1": dato1,
      "dato2": dato2,
      "fecha": fecha.toString()
    };
  }
}
