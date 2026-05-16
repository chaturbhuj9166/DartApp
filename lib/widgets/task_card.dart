import 'package:flutter/material.dart';

class TaskCard
extends StatelessWidget {

  final Map task;

  final VoidCallback onTap;

  const TaskCard({

    super.key,

    required this.task,

    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {

    return Card(

      child: ListTile(

        onTap: onTap,

        title: Text(

          task["title"],

          style:
          const TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),

        subtitle: Text(

          task["description"]
          ?? "",

        ),

        trailing: Container(

          padding:
          const EdgeInsets.symmetric(

            horizontal: 12,

            vertical: 6,

          ),

          decoration:
          BoxDecoration(

            color:
            Colors.blue.shade100,

            borderRadius:
            BorderRadius.circular(20),

          ),

          child: Text(

            task["status"],

          ),

        ),

      ),

    );

  }

}