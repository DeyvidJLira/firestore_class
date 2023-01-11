class Transaction {
  String? uid;
  DateTime? date = DateTime.now();
  String description = "";
  double value = 0.0;

  Transaction({this.uid, this.date, this.description = "", this.value = 0.0});

  Transaction copyWith(
      {String? newUid,
      DateTime? newDate,
      String? newDescription,
      double? newValue}) {
    return Transaction(
      uid: newUid ?? uid,
      date: newDate ?? date,
      description: newDescription ?? description,
      value: newValue ?? value,
    );
  }

  Transaction.fromFirestore(Map<String, dynamic> map) {
    date = map["date"].toDate();
    description = map["description"] ?? "";
    value = map["value"] ?? 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "description": description,
      "value": value,
    };
  }

  bool get isValid => date != null && description.isNotEmpty;
}
