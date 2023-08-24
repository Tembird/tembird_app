class Update {
  final int id;
  final int buildNum;
  final String reason;
  final DateTime createAt;
  final bool isNecessary;
  final bool onMaintainance;

  Update({
    required this.id,
    required this.buildNum,
    required this.reason,
    required this.createAt,
    required this.isNecessary,
    required this.onMaintainance,
  });

  factory Update.fromJson(Map<String, dynamic> json) => Update(
        id: json['id'],
        buildNum: json['build_num'],
        reason: json['reason'],
        createAt: DateTime.parse(json['created_at']),
        isNecessary: json['is_necessary'] == 1,
        onMaintainance: json['on_ maintainance'] == 1,
      );
}
