class Announcement {
  final int id;
  final int priorityNum;
  final String title;
  final String content;
  final String type;
  final DateTime createdAt;
  final DateTime editedAt;

  Announcement({
    required this.id,
    required this.priorityNum,
    required this.title,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.editedAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        id: json['id'],
        priorityNum: json['priority_num'],
        title: json['title'],
        content: json['content'],
        type: json['type'],
        createdAt: DateTime.parse(json['created_at']),
        editedAt: DateTime.parse(json['edited_at']),
      );
}
