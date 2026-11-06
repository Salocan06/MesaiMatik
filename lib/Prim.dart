import 'dart:convert';

class MonthPrim {
  String mode; // 'tl' veya 'pct'
  double value;

  MonthPrim({this.mode = 'tl', this.value = 0});

  Map<String, dynamic> toJson() => {'mode': mode, 'value': value};

  factory MonthPrim.fromJson(Map<String, dynamic> j) => MonthPrim(
        mode: j['mode'] ?? 'tl',
        value: (j['value'] ?? 0).toDouble(),
      );

  double amountTl(double base) => mode == 'pct' ? base * value / 100 : value;
}

String primKey(int year, int month) =>
    '$year-${month.toString().padLeft(2, '0')}';

Map<String, MonthPrim> decodePrims(String? jsonStr) {
  final map = <String, MonthPrim>{};
  if (jsonStr == null) return map;
  final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
  decoded.forEach((k, v) {
    map[k] = MonthPrim.fromJson(v as Map<String, dynamic>);
  });
  return map;
}

String encodePrims(Map<String, MonthPrim> prims) {
  final map = <String, dynamic>{};
  prims.forEach((k, v) {
    map[k] = v.toJson();
  });
  return jsonEncode(map);
}
