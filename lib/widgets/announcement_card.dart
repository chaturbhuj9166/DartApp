import 'package:flutter/material.dart';

class AnnouncementCard extends StatelessWidget {
  final Map announcement;

  final VoidCallback onTap;

  const AnnouncementCard({
    super.key,

    required this.announcement,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String title = announcement["title"] ?? "No Title";

    final String description = announcement["description"] ?? "";

    final String status = announcement["status"] ?? "Unread";

    return Card(
      color: const Color(0xFF1E293B),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: ListTile(
        contentPadding: const EdgeInsets.all(15),

        onTap: onTap,

        leading: Container(
          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            color: const Color.fromRGBO(59, 130, 246, 0.2),
          ),

          child: const Icon(Icons.campaign, color: Colors.blue),
        ),

        title: Text(
          title,

          maxLines: 1,

          overflow: TextOverflow.ellipsis,

          style: const TextStyle(
            color: Colors.white,

            fontWeight: FontWeight.bold,

            fontSize: 18,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),

          child: Text(
            description,

            maxLines: 2,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(color: Colors.white70),
          ),
        ),

        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

          decoration: BoxDecoration(
            color: status == "Seen" ? Colors.green : Colors.orange,

            borderRadius: BorderRadius.circular(20),
          ),

          child: Text(
            status,

            style: const TextStyle(
              color: Colors.white,

              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
