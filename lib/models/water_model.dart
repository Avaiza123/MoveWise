
class WaterEntry {
  final int amount;
  final DateTime timestamp;

  WaterEntry({required this.amount, required this.timestamp});

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "timestamp": timestamp.toIso8601String(),
  };

  factory WaterEntry.fromJson(Map<String, dynamic> json) => WaterEntry(
    amount: json["amount"],
    timestamp: DateTime.parse(json["timestamp"]),
  );
}