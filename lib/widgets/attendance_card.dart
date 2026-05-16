import 'package:flutter/material.dart';

class AttendanceCard
extends StatelessWidget {

  final Map attendance;

  const AttendanceCard({

    super.key,

    required this.attendance,

  });

  @override
  Widget build(BuildContext context) {

    return Card(

      child: Padding(

        padding:
        const EdgeInsets.all(15),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(

              attendance["date"],

              style:
              const TextStyle(

                fontWeight:
                FontWeight.bold,

                fontSize: 18,

              ),

            ),

            const SizedBox(
              height: 10,
            ),

            Text(

              "Punch In: "
              "${attendance["punchIn"]}",

            ),

            Text(

              "Punch Out: "
              "${attendance["punchOut"]}",

            ),

            Text(

              "Hours: "
              "${attendance["hours"]}",

            ),

          ],

        ),

      ),

    );

  }

}