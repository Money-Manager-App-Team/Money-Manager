class Budget {
  double max;
  double value;

  Budget({required this.max, required this.value});

  double get percentage => max == 0 ? 0 : (value / max).clamp(0, 1);

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      max: (map['max'] ?? 0).toDouble(),
      value: (map['value'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'max': max,
      'value': value,
    };
  }
}
