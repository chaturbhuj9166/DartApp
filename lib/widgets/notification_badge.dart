import 'package:flutter/material.dart';

class NotificationBadge
extends StatelessWidget {

  final int count;

  const NotificationBadge({

    super.key,

    required this.count,

  });

  @override
  Widget build(BuildContext context) {

    if(count == 0){

      return const SizedBox();

    }

    return Container(

      padding:
      const EdgeInsets.all(6),

      decoration:
      const BoxDecoration(

        color: Colors.red,

        shape: BoxShape.circle,

      ),

      child: Text(

        count.toString(),

        style: const TextStyle(

          color: Colors.white,

          fontSize: 12,

          fontWeight:
          FontWeight.bold,

        ),

      ),

    );

  }

}