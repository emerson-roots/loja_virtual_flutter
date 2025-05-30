class Cupom {
  final int percent;

  Cupom({required this.percent});

  factory Cupom.empty() => Cupom(percent: 0);

  factory Cupom.fromJson(Map<String, dynamic> json) {
    return Cupom(
      percent: json['percent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'percent': percent,
    };
  }
}
