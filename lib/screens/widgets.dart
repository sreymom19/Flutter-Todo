import 'package:flutter/material.dart';

class TaskCardWidgets extends StatelessWidget {
  final String? title;
  final String? desc;
  const TaskCardWidgets({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 32.0,
      ),
      margin: const EdgeInsets.only(
        bottom: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "(Uname Title)",
            style: const TextStyle(
                color: Color(0xff211551),
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              desc ?? "(No Description)",
              style: const TextStyle(
                color: Color(0xff86829D),
                fontSize: 16.0,
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TodoWidgets extends StatelessWidget {
  final String texts;
  final bool isDone;
  const TodoWidgets(this.texts, {required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      child: Row(
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            margin: const EdgeInsets.only(
              right: 12.0,
            ),
            decoration: BoxDecoration(
              color: isDone ? const Color(0xff7349fe) : Colors.transparent,
              borderRadius: BorderRadius.circular(6.0),
              border: isDone
                  ? null
                  : Border.all(color: const Color(0xff86829d), width: 1.5),
            ),
            child: Image.asset('assets/images/tick.png'),
          ),
          Text(
            texts,
            style: const TextStyle(
              color: Color(0xff211551),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
