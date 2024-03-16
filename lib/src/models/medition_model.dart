class MeditionData {
  String? id;
  double? turbidity;
  double? flow;
  DateTime? fecha;

  MeditionData({
    this.id,
    this.turbidity,
    this.flow,
    this.fecha,
  });

  MeditionData.fromJson(Map<dynamic, dynamic> json) {
    id = json["id"] ?? '';
    turbidity = double.tryParse(json["turbidity"].toString()) ?? 0;
    flow = double.tryParse(json["flow"].toString()) ?? 0;
    fecha = DateTime.tryParse(json["fecha"]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "turbidity": turbidity.toString(),
      "flow": flow.toString(),
      "fecha": fecha.toString()
    };
  }
}
