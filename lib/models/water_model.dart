class WaterEntry {
  final String type; // water, juice, tea, etc.
  final int amount; // in ml
  final DateTime timestamp;

  WaterEntry({
    required this.type,
    required this.amount,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "amount": amount,
    "timestamp": timestamp.toIso8601String(),
  };

  factory WaterEntry.fromJson(Map<String, dynamic> json) => WaterEntry(
    type: json["type"],
    amount: json["amount"],
    timestamp: DateTime.parse(json["timestamp"]),
  );
}
