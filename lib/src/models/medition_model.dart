class MeditionData {
  String? id;
  double? dato1;
  double? dato2;
  DateTime? fecha;

  MeditionData({
    this.id,
    this.dato1,
    this.dato2,
    this.fecha,
  });

  MeditionData.fromJson(Map<dynamic, dynamic> json) {
    id = json["id"] ?? '';
    dato1 = double.tryParse(json["dato1"].toString()) ?? 0;
    dato2 = double.tryParse(json["dato2"].toString()) ?? 0;
    fecha = DateTime.tryParse(json["fecha"]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "dato1": dato1.toString(),
      "dato2": dato2.toString(),
      "fecha": fecha.toString()
    };
  }
}
