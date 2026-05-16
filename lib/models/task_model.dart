class TaskModel {

  final String id;

  final String title;

  final String description;

  final String status;

  final String reply;

  TaskModel({

    required this.id,

    required this.title,

    required this.description,

    required this.status,

    required this.reply,

  });

  factory TaskModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return TaskModel(

      id: json["_id"],

      title: json["title"],

      description:
      json["description"] ?? "",

      status: json["status"],

      reply: json["reply"] ?? "",

    );

  }

}