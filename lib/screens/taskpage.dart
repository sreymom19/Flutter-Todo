import 'package:flutter/material.dart';
import 'package:my_flutter_todo/database_helper.dart';
import 'package:my_flutter_todo/models/task.dart';
import 'package:my_flutter_todo/models/todo.dart';
import 'package:my_flutter_todo/screens/homepages.dart';

class TaskPage extends StatefulWidget {
  // final Int task; // this is your old code
  final Task? task; // thisis what i have changed
  const TaskPage({required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String _taskTitle = "";
  @override
  void initState() {
    if (widget.task != null) {
      _taskTitle = "${widget.task?.title}";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 6.0,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Image.asset('assets/images/arrow.png'),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          onSubmitted: (value) async {
                            print("Field value $value");
                            //Check if the field if not empty
                            if (value != "") {
                              //Check if the task is null
                              if (widget.task == null) {
                                DatabaseHelper dbHelper = DatabaseHelper();

                                Task newTask = Task(title: value);
                                await dbHelper.insertTask(newTask);
                              } else {
                                print("Update the exsiting Task");
                              }
                            }
                          },
                          controller: TextEditingController()
                            ..text = _taskTitle,
                          decoration: const InputDecoration(
                            hintText: "Enter Task Title",
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff211551),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Description for the task...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
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
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                  color: const Color(0xff86829d), width: 1.5),
                            ),
                            child: Image.asset('assets/images/tick.png'),
                          ),
                          Expanded(
                            child: TextField(
                              onSubmitted: (value) async {
                                //Check if the field if not empty
                                if (value != "") {
                                  //Check if the task is null
                                  if (widget.task != null) {
                                    DatabaseHelper dbHelper = DatabaseHelper();

                                    Todo newTodo = Todo(
                                      title: value,
                                      isDone: 0,
                                      taskID: widget.task?.id,
                                    );
                                    await dbHelper.insertTodo(newTodo);
                                  }
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "Enter todo item",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            Positioned(
              bottom: 24.0,
              right: 24.0,
              child: GestureDetector(
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                }),
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: const Color(0xfffe3577)),
                  child: Image.asset('assets/images/delete.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
