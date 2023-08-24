class TodoLabel {
  final int id;
  final String title;
  final String colorHex;
  final DateTime createdAt;
  DateTime updatedAt;

  TodoLabel({
    required this.id,
    required this.title,
    required this.colorHex,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TodoLabel.fromJson(Map<String, dynamic> json) => TodoLabel(
        id: json["id"],
        title: json["title"],
        colorHex: json["color_hex"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "colorHex": colorHex,
      };
}
