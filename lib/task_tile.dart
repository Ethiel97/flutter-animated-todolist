import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final String time;
  final bool completed;
  final Widget? leading;

  const TaskTile({
    super.key,
    required this.title,
    required this.time,
    this.leading,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    final leading = this.leading != null
        ? Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            child: this.leading,
          )
        : Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            value: completed,
            onChanged: (value) {},
          );

    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black54,
        ),
      ),
    );
  }
}

final tasks = [
  TaskTile(
    leading: Text(
      "☀️️",
      style: TextStyle(
        fontSize: 20,
        // color: Colors.yellow,
      ),
    ),
    title: "Wake up",
    time: "09:00",
  ),
  TaskTile(
    title: "Design Crit",
    time: "10:00",
  ),
  TaskTile(
    title: "Haircut with Vincent",
    time: "13:00",
  ),
  TaskTile(
    title: "Birthday party",
    time: "18:30",
  ),
  TaskTile(
    title: "Pushups X 100",
    time: "19:30",
  ),
  TaskTile(
    title: "Finish designs",
    time: "22:00",
  ),
];
