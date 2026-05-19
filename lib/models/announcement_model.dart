class AnnouncementModel {
  final String id;

  final String title;

  final String description;

  final String status;

  final String reply;

  final String createdAt;

  AnnouncementModel({
    required this.id,

    required this.title,

    required this.description,

    required this.status,

    required this.reply,

    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json["_id"],

      title: json["title"] ?? "",

      description: json["description"] ?? "",

      status: json["status"] ?? "Unread",

      reply: json["reply"] ?? "",

      createdAt: json["createdAt"] ?? "",
    );
  }
}
